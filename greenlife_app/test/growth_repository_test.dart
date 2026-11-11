import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/repositories/growth_repository.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:greenlife_app/utils/date_utils.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

GrowthNote _note(
  String id, {
  String date = '01/01/2026',
  String plantName = 'Trầu bà',
  String title = 'Tiêu đề',
  String summary = 'Tóm tắt',
  String imagePath = '',
}) {
  return GrowthNote(
    id: id,
    plantName: plantName,
    title: title,
    date: date,
    summary: summary,
    imagePath: imagePath,
  );
}

void main() {
  const vi = Locale('vi');
  const en = Locale('en');
  final repository = GrowthRepository();

  setUpAll(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  setUp(() async {
    await StorageService.instance.clearAll();
  });

  group('dateOf', () {
    test('parses the note date', () {
      expect(repository.dateOf(_note('a', date: '18/10/2026')),
          DateTime(2026, 10, 18));
    });

    test('falls back to the epoch for an invalid date', () {
      expect(repository.dateOf(_note('a', date: 'hôm qua')),
          AppDateUtils.epoch);
      expect(repository.dateOf(_note('a', date: '31/02/2026')),
          AppDateUtils.epoch);
    });
  });

  group('insertSorted', () {
    test('keeps notes ordered from newest to oldest', () {
      final notes = <GrowthNote>[];

      repository.insertSorted(notes, _note('mid', date: '10/06/2026'));
      repository.insertSorted(notes, _note('new', date: '20/06/2026'));
      repository.insertSorted(notes, _note('old', date: '01/01/2026'));

      expect(notes.map((n) => n.id), ['new', 'mid', 'old']);
    });

    test('a note with the same date goes before existing ones', () {
      final notes = [_note('first', date: '10/06/2026')];

      repository.insertSorted(notes, _note('second', date: '10/06/2026'));

      expect(notes.map((n) => n.id), ['second', 'first']);
    });

    test('appends the oldest note and handles an empty list', () {
      final notes = [_note('a', date: '10/06/2026')];

      repository.insertSorted(notes, _note('b', date: '01/06/2026'));
      expect(notes.last.id, 'b');

      final empty = <GrowthNote>[];
      repository.insertSorted(empty, _note('only'));
      expect(empty.map((n) => n.id), ['only']);
    });

    test('notes with an invalid date sort as the oldest', () {
      final notes = [_note('valid', date: '10/06/2026')];

      repository.insertSorted(notes, _note('broken', date: 'xxx'));

      expect(notes.map((n) => n.id), ['valid', 'broken']);
    });
  });

  group('plant helpers', () {
    test('notesOfPlant matches the exact plant name', () {
      final notes = [
        _note('1', plantName: 'Trầu bà'),
        _note('2', plantName: 'Sen đá'),
        _note('3', plantName: 'Trầu bà'),
      ];

      expect(repository.notesOfPlant(notes, 'Trầu bà').map((n) => n.id),
          ['1', '3']);
      expect(repository.notesOfPlant(notes, 'Hoa hồng'), isEmpty);
    });

    test('withPlantName changes only the plant name', () {
      final note = _note('1', imagePath: '/tmp/a.jpg');

      final renamed = repository.withPlantName(note, 'Cây mới');

      expect(renamed.plantName, 'Cây mới');
      expect(renamed.id, note.id);
      expect(renamed.title, note.title);
      expect(renamed.date, note.date);
      expect(renamed.summary, note.summary);
      expect(renamed.imagePath, '/tmp/a.jpg');
    });
  });

  group('isUntouchedSample and localize', () {
    test('recognises sample notes in either language', () {
      for (final locale in [vi, en]) {
        for (final sample in sampleNotesFor(locale)) {
          expect(repository.isUntouchedSample(sample), isTrue,
              reason: '${locale.languageCode}/${sample.id}');
        }
      }
    });

    test('an edited or photographed sample is no longer untouched', () {
      final sample = sampleNotesFor(vi).first;

      expect(
        repository.isUntouchedSample(_note(
          sample.id,
          plantName: sample.plantName,
          title: 'Tiêu đề đã sửa',
          summary: sample.summary,
          date: sample.date,
        )),
        isFalse,
      );
      expect(
        repository.isUntouchedSample(_note(
          sample.id,
          plantName: sample.plantName,
          title: sample.title,
          summary: sample.summary,
          date: sample.date,
          imagePath: '/tmp/photo.jpg',
        )),
        isFalse,
      );
    });

    test('localize translates untouched samples and leaves user notes alone',
        () {
      final viSamples = sampleNotesFor(vi);
      final enSamples = sampleNotesFor(en);
      final custom = _note('custom', title: 'Ghi chú của tôi');

      final localized = repository.localize([...viSamples, custom], en);

      expect(localized.length, viSamples.length + 1);
      for (var i = 0; i < viSamples.length; i++) {
        expect(localized[i].title, enSamples[i].title);
        expect(localized[i].plantName, enSamples[i].plantName);
      }
      expect(localized.last, same(custom));
    });

    test('localize keeps an edited sample as the user left it', () {
      final sample = sampleNotesFor(vi).first;
      final edited = _note(
        sample.id,
        plantName: sample.plantName,
        title: 'Tôi đã sửa',
        summary: sample.summary,
        date: sample.date,
      );

      expect(repository.localize([edited], en).single, same(edited));
    });
  });

  group('initialNotes and persistence', () {
    test('initialNotes returns the sample notes for the locale', () {
      expect(repository.initialNotes(en).map((n) => n.title),
          sampleNotesFor(en).map((n) => n.title));
    });

    test('saveNotes then loadNotes returns the saved notes', () async {
      expect(await repository.loadNotes(), isNull);

      await repository.saveNotes([_note('saved', title: 'Đã lưu')]);

      final loaded = await repository.loadNotes();
      expect(loaded!.single.id, 'saved');
      expect(loaded.single.title, 'Đã lưu');
    });
  });
}
