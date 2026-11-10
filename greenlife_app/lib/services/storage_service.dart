import 'dart:convert';
import 'package:greenlife_app/config/app_config.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  static const String _tasksKey = AppConfig.tasksStorageKey;
  static const String _plantsKey = AppConfig.plantsStorageKey;
  static const String _notesKey = AppConfig.notesStorageKey;
  static const String _localeKey = AppConfig.localeStorageKey;

  late final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<void> saveTasks(List<CareTask> tasks) {
    return _saveList(_tasksKey, tasks.map(_taskToMap).toList());
  }

  Future<List<CareTask>?> loadTasks() async {
    final list = await _loadList(_tasksKey);
    return list?.map(_taskFromMap).toList();
  }

  Future<void> savePlants(List<Plant> plants) {
    return _saveList(_plantsKey, plants.map(_plantToMap).toList());
  }

  Future<List<Plant>?> loadPlants() async {
    final list = await _loadList(_plantsKey);
    return list?.map(_plantFromMap).toList();
  }

  Future<void> saveNotes(List<GrowthNote> notes) {
    return _saveList(_notesKey, notes.map(_noteToMap).toList());
  }

  Future<List<GrowthNote>?> loadNotes() async {
    final list = await _loadList(_notesKey);
    return list?.map(_noteFromMap).toList();
  }

  Future<void> saveLocaleCode(String languageCode) async {
    try {
      await _prefs.setString(_localeKey, languageCode);
    } catch (_) {
      return;
    }
  }

  Future<String?> loadLocaleCode() async {
    try {
      return await _prefs.getString(_localeKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _prefs.remove(_tasksKey);
      await _prefs.remove(_plantsKey);
      await _prefs.remove(_notesKey);
      await _prefs.remove(_localeKey);
    } catch (_) {
      return;
    }
  }

  Future<void> _saveList(String key, List<Map<String, Object?>> items) async {
    try {
      await _prefs.setString(key, jsonEncode(items));
    } catch (_) {
      return;
    }
  }

  Future<List<Map<String, dynamic>>?> _loadList(String key) async {
    try {
      final raw = await _prefs.getString(key);
      if (raw == null) return null;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return decoded.whereType<Map<String, dynamic>>().toList();
    } catch (_) {
      return null;
    }
  }

  Map<String, Object?> _taskToMap(CareTask task) {
    return {
      'id': task.id,
      'title': task.title,
      'plantName': task.plantName,
      'type': task.type,
      'dueDate': task.dueDate,
      'isCompleted': task.isCompleted,
      'dueAt': task.dueAt?.toIso8601String(),
      'recurrence': task.recurrence.name,
    };
  }

  CareTask _taskFromMap(Map<String, dynamic> map) {
    return CareTask(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      plantName: map['plantName'] as String? ?? '',
      type: map['type'] as String? ?? '',
      dueDate: map['dueDate'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      dueAt: DateTime.tryParse(map['dueAt'] as String? ?? ''),
      recurrence: CareTaskRecurrence.values.firstWhere(
        (value) => value.name == map['recurrence'],
        orElse: () => CareTaskRecurrence.none,
      ),
    );
  }

  Map<String, Object?> _plantToMap(Plant plant) {
    return {
      'id': plant.id,
      'name': plant.name,
      'scientificName': plant.scientificName,
      'category': plant.category,
      'description': plant.description,
      'careLevel': plant.careLevel,
      'waterNeed': plant.waterNeed,
      'sunlight': plant.sunlight,
      'imageAsset': plant.imageAsset,
      'imageUrl': plant.imageUrl,
      'isFavorite': plant.isFavorite,
      'inGarden': plant.inGarden,
      'plantedDate': plant.plantedDate,
      'careNotes': plant.careNotes,
      'tags': plant.tags,
    };
  }

  Plant _plantFromMap(Map<String, dynamic> map) {
    final rawTags = map['tags'];
    return Plant(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      scientificName: map['scientificName'] as String? ?? '',
      category: map['category'] as String? ?? '',
      description: map['description'] as String? ?? '',
      careLevel: map['careLevel'] as String? ?? '',
      waterNeed: map['waterNeed'] as String? ?? '',
      sunlight: map['sunlight'] as String? ?? '',
      imageAsset: map['imageAsset'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      isFavorite: map['isFavorite'] as bool? ?? false,
      inGarden:
          map['inGarden'] as bool? ?? _legacyInGarden(map['id'] as String? ?? ''),
      plantedDate: map['plantedDate'] as String? ?? '',
      careNotes: map['careNotes'] as String? ?? '',
      tags: rawTags is List ? rawTags.whereType<String>().toList() : <String>[],
    );
  }

  bool _legacyInGarden(String id) {
    final isCatalog = RegExp(r'^plant-\d$').hasMatch(id);
    if (!isCatalog) return true;
    return const {'plant-1', 'plant-2', 'plant-3', 'plant-4'}.contains(id);
  }

  Map<String, Object?> _noteToMap(GrowthNote note) {
    return {
      'id': note.id,
      'plantName': note.plantName,
      'title': note.title,
      'date': note.date,
      'summary': note.summary,
      'imagePath': note.imagePath,
    };
  }

  GrowthNote _noteFromMap(Map<String, dynamic> map) {
    return GrowthNote(
      id: map['id'] as String? ?? '',
      plantName: map['plantName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      date: map['date'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      imagePath: map['imagePath'] as String? ?? '',
    );
  }
}