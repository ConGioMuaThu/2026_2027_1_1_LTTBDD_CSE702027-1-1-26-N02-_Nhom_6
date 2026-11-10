import 'package:flutter/widgets.dart' show Locale;
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:greenlife_app/utils/date_utils.dart';

class GrowthRepository {
  GrowthRepository({StorageService? storage})
      : _storage = storage ?? StorageService.instance;

  final StorageService _storage;

  List<GrowthNote> initialNotes(Locale locale) => sampleNotesFor(locale);

  Future<List<GrowthNote>?> loadNotes() => _storage.loadNotes();

  Future<void> saveNotes(List<GrowthNote> notes) => _storage.saveNotes(notes);

  DateTime dateOf(GrowthNote note) {
    return AppDateUtils.parseDate(note.date) ?? AppDateUtils.epoch;
  }

  void insertSorted(List<GrowthNote> notes, GrowthNote note) {
    final date = dateOf(note);
    final index = notes.indexWhere((item) => !dateOf(item).isAfter(date));
    notes.insert(index == -1 ? notes.length : index, note);
  }

  List<GrowthNote> notesOfPlant(List<GrowthNote> notes, String plantName) {
    return notes.where((note) => note.plantName == plantName).toList();
  }

  GrowthNote withPlantName(GrowthNote note, String plantName) {
    return GrowthNote(
      id: note.id,
      plantName: plantName,
      title: note.title,
      date: note.date,
      summary: note.summary,
      imagePath: note.imagePath,
    );
  }

  bool isUntouchedSample(GrowthNote note) {
    for (final locale in AppLocalizations.supportedLocales) {
      for (final sample in sampleNotesFor(locale)) {
        if (note.imagePath.isEmpty &&
            sample.id == note.id &&
            sample.title == note.title &&
            sample.summary == note.summary &&
            sample.plantName == note.plantName &&
            sample.date == note.date) {
          return true;
        }
      }
    }
    return false;
  }

  List<GrowthNote> localize(List<GrowthNote> source, Locale locale) {
    final fresh = {
      for (final note in sampleNotesFor(locale)) note.id: note,
    };

    return [
      for (final note in source)
        fresh.containsKey(note.id) && isUntouchedSample(note)
            ? fresh[note.id]!
            : note,
    ];
  }
}