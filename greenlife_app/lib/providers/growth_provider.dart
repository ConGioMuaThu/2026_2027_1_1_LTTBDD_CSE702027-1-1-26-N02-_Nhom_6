import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/repositories/growth_repository.dart';

class GrowthProvider extends ChangeNotifier {
  GrowthProvider({
    required Locale locale,
    GrowthRepository? repository,
  })  : _locale = locale,
        _repository = repository ?? GrowthRepository() {
    _notes = _repository.initialNotes(locale);
  }

  final GrowthRepository _repository;
  final List<VoidCallback> _pending = [];

  Locale _locale;
  late List<GrowthNote> _notes;
  bool _loading = false;
  bool _disposed = false;

  UnmodifiableListView<GrowthNote> get notes => UnmodifiableListView(_notes);

  Future<void> load() async {
    _loading = true;

    try {
      final saved = await _repository.loadNotes();
      if (_disposed) return;
      if (saved != null) _notes = _repository.localize(saved, _locale);
    } finally {
      _loading = false;
      if (!_disposed) _flushPending();
    }

    if (!_disposed) notifyListeners();
  }

  void updateLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;

    _locale = locale;
    _notes = _repository.localize(_notes, locale);
    if (!_loading) _persist();
    notifyListeners();
  }

  void add(GrowthNote note) {
    _run(() {
      _repository.insertSorted(_notes, note);
      _persist();
      notifyListeners();
    });
  }

  void update(GrowthNote note) {
    _run(() {
      _notes.removeWhere((n) => n.id == note.id);
      _repository.insertSorted(_notes, note);
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

  void removeByPlant(String plantName) {
    _run(() {
      final before = _notes.length;
      _notes.removeWhere((n) => n.plantName == plantName);
      if (_notes.length == before) return;

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
    _repository.saveNotes(_notes);
  }

  GrowthNote _withPlantName(GrowthNote note, String name, VoidCallback onChanged) {
    onChanged();
    return _repository.withPlantName(note, name);
  }

  @override
  void dispose() {
    _disposed = true;
    _pending.clear();
    super.dispose();
  }
}