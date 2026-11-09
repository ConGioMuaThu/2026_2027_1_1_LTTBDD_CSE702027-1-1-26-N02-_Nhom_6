import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/services/storage_service.dart';
import 'package:greenlife_app/utils/date_utils.dart';

class GrowthProvider extends ChangeNotifier {
  GrowthProvider({
    required Locale locale,
    StorageService? storage,
  })  : _locale = locale,
        _storage = storage ?? StorageService.instance,
        _notes = sampleNotesFor(locale);

  final StorageService _storage;
  final List<VoidCallback> _pending = [];

  Locale _locale;
  List<GrowthNote> _notes;
  bool _loading = false;
  bool _disposed = false;

  UnmodifiableListView<GrowthNote> get notes => UnmodifiableListView(_notes);

  Future<void> load() async {
    _loading = true;

    try {
      final saved = await _storage.loadNotes();
      if (_disposed) return;
      if (saved != null) _notes = _localized(saved, _locale);
    } finally {
      _loading = false;
      if (!_disposed) _flushPending();
    }

    if (!_disposed) notifyListeners();
  }

  void updateLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;

    _locale = locale;
    _notes = _localized(_notes, locale);
    if (!_loading) _persist();
    notifyListeners();
  }

  void add(GrowthNote note) {
    _run(() {
      _insert(note);
      _persist();
      notifyListeners();
    });
  }

  void update(GrowthNote note) {
    _run(() {
      _notes.removeWhere((n) => n.id == note.id);
      _insert(note);
      _persist();
      notifyListeners();
    });
  }

  void renamePlant(String oldName, String newName) {
    _run(() {
      var changed = false;
      final updated = [
        for (final note in _notes)
          if (note.plantName == oldName)
            _withPlantName(note, newName, () => changed = true)
          else
            note,
      ];
      if (!changed) return;

      _notes = updated;
      _persist();
      notifyListeners();
    });
  }

  void remove(String id) {
    _run(() {
      _notes.removeWhere((n) => n.id == id);
      _persist();
      notifyListeners();
    });
  }

  void _run(VoidCallback action) {
    if (_loading) {
      _pending.add(action);
    } else {
      action();
    }
  }

  void _flushPending() {
    final queued = List<VoidCallback>.of(_pending);
    _pending.clear();
    for (final action in queued) {
      action();
    }
  }

  void _persist() {
    _storage.saveNotes(_notes);
  }

  GrowthNote _withPlantName(GrowthNote note, String name, VoidCallback onChanged) {
    onChanged();
    return GrowthNote(
      id: note.id,
      plantName: name,
      title: note.title,
      date: note.date,
      summary: note.summary,
    );
  }

  DateTime _dateOf(GrowthNote note) {
    return AppDateUtils.parseDate(note.date) ?? AppDateUtils.epoch;
  }

  void _insert(GrowthNote note) {
    final date = _dateOf(note);
    final index = _notes.indexWhere((n) => !_dateOf(n).isAfter(date));
    _notes.insert(index == -1 ? _notes.length : index, note);
  }

  bool _isUntouchedSample(GrowthNote note) {
    for (final locale in AppLocalizations.supportedLocales) {
      for (final sample in sampleNotesFor(locale)) {
        if (sample.id == note.id &&
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

  List<GrowthNote> _localized(List<GrowthNote> source, Locale locale) {
    final fresh = {
      for (final note in sampleNotesFor(locale)) note.id: note,
    };

    return [
      for (final note in source)
        fresh.containsKey(note.id) && _isUntouchedSample(note)
            ? fresh[note.id]!
            : note,
    ];
  }

  @override
  void dispose() {
    _disposed = true;
    _pending.clear();
    super.dispose();
  }
}