import 'package:flutter/material.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/screens/care/care_screen.dart';
import 'package:greenlife_app/screens/developers/developers_screen.dart';
import 'package:greenlife_app/screens/home/home_screen.dart';
import 'package:greenlife_app/screens/my_plants/my_plants_screen.dart';
import 'package:greenlife_app/screens/plant_library/plant_library_screen.dart';
import 'package:greenlife_app/screens/tips/tips_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  late List<CareTask> _tasks = sampleTasksFor(widget.locale);
  late List<Plant> _plants = samplePlantsFor(widget.locale);
  late List<GrowthNote> _notes = sampleNotesFor(widget.locale);

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locale.languageCode != widget.locale.languageCode) {
      _reloadForLocale();
    }
  }

  void _reloadForLocale() {
    final freshTasks = {
      for (final task in sampleTasksFor(widget.locale)) task.id: task,
    };
    final freshPlants = {
      for (final plant in samplePlantsFor(widget.locale)) plant.id: plant,
    };

    _tasks = [
      for (final task in _tasks)
        freshTasks.containsKey(task.id)
            ? _taskWithCompleted(freshTasks[task.id]!, task.isCompleted)
            : task,
    ];
    _plants = [
      for (final plant in _plants)
        freshPlants.containsKey(plant.id)
            ? _plantWithFavorite(freshPlants[plant.id]!, plant.isFavorite)
            : plant,
    ];
    _notes = sampleNotesFor(widget.locale);
  }

  CareTask _taskWithCompleted(CareTask t, bool isCompleted) {
    return CareTask(
      id: t.id,
      title: t.title,
      plantName: t.plantName,
      type: t.type,
      dueDate: t.dueDate,
      isCompleted: isCompleted,
    );
  }

  Plant _plantWithFavorite(Plant p, bool isFavorite) {
    return Plant(
      id: p.id,
      name: p.name,
      scientificName: p.scientificName,
      category: p.category,
      description: p.description,
      careLevel: p.careLevel,
      waterNeed: p.waterNeed,
      sunlight: p.sunlight,
      imageAsset: p.imageAsset,
      imageUrl: p.imageUrl,
      isFavorite: isFavorite,
      tags: p.tags,
    );
  }

  void _toggleTask(String id) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == id);
      if (i == -1) return;
      _tasks[i] = _taskWithCompleted(_tasks[i], !_tasks[i].isCompleted);
    });
  }

  void _addTask(CareTask task) {
    setState(() => _tasks.insert(0, task));
  }

  void _toggleFavorite(String id) {
    setState(() {
      final i = _plants.indexWhere((p) => p.id == id);
      if (i == -1) return;
      _plants[i] = _plantWithFavorite(_plants[i], !_plants[i].isFavorite);
    });
  }

  void _addPlant(Plant plant) {
    setState(() => _plants.insert(0, plant));
  }

  void _deletePlant(String id) {
    setState(() => _plants.removeWhere((p) => p.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            plants: _plants,
            tasks: _tasks,
            notes: _notes,
            locale: widget.locale,
            onLocaleChanged: widget.onLocaleChanged,
          ),
          PlantLibraryScreen(
            plants: _plants,
            onToggleFavorite: _toggleFavorite,
            onAddTask: _addTask,
          ),
          MyPlantsScreen(
            plants: _plants,
            onAddPlant: _addPlant,
            onDeletePlant: _deletePlant,
          ),
          CareScreen(
            tasks: _tasks,
            onToggleTask: _toggleTask,
            onAddTask: _addTask,
          ),
          const TipsScreen(),
          const DevelopersScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: strings.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_florist_outlined),
            selectedIcon: const Icon(Icons.local_florist),
            label: strings.library,
          ),
          NavigationDestination(
            icon: const Icon(Icons.yard_outlined),
            selectedIcon: const Icon(Icons.yard),
            label: strings.garden,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: strings.care,
          ),
          NavigationDestination(
            icon: const Icon(Icons.tips_and_updates_outlined),
            selectedIcon: const Icon(Icons.tips_and_updates),
            label: strings.tips,
          ),
          NavigationDestination(
            icon: const Icon(Icons.groups_outlined),
            selectedIcon: const Icon(Icons.groups),
            label: strings.teamInfo,
          ),
        ],
      ),
    );
  }
}