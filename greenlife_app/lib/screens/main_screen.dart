import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/providers/care_provider.dart';
import 'package:greenlife_app/providers/growth_provider.dart';
import 'package:greenlife_app/providers/plant_provider.dart';
import 'package:greenlife_app/screens/care/care_screen.dart';
import 'package:greenlife_app/screens/developers/developers_screen.dart';
import 'package:greenlife_app/screens/growth_journal/growth_journal_screen.dart';
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

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _index = 0;
  late final CareProvider _care = CareProvider(locale: widget.locale);
  late final PlantProvider _plants = PlantProvider(locale: widget.locale);
  late final GrowthProvider _growth = GrowthProvider(locale: widget.locale);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _care.load();
    _plants.load();
    _growth.load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    Future.microtask(() {
      if (!mounted) return;
      _care.updateLocale(locale);
      _plants.updateLocale(locale);
      _growth.updateLocale(locale);
    });
  }

  void _updatePlant(Plant plant) {
    final previous = _plants.findById(plant.id);
    _plants.update(plant);

    if (previous != null && previous.name != plant.name) {
      _care.renamePlant(previous.name, plant.name);
      _growth.renamePlant(previous.name, plant.name);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _care.refreshLabels();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _care.dispose();
    _plants.dispose();
    _growth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([_care, _plants, _growth]),
      builder: (context, _) => _buildScaffold(context, strings),
    );
  }

  Widget _buildScaffold(BuildContext context, AppLocalizations strings) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            plants: _plants.plants,
            tasks: _care.tasks,
            notes: _growth.notes,
            locale: Localizations.localeOf(context),
            onLocaleChanged: widget.onLocaleChanged,
            onToggleTask: _care.toggle,
            onViewCareSchedule: () => setState(() => _index = 3),
          ),
          PlantLibraryScreen(
            plants: _plants.plants,
            onToggleFavorite: _plants.toggleFavorite,
            onAddTask: _care.add,
          ),
          MyPlantsScreen(
            plants: _plants.plants,
            onAddPlant: _plants.add,
            onDeletePlant: _plants.remove,
            onUpdatePlant: _updatePlant,
          ),
          CareScreen(
            tasks: _care.tasks,
            onToggleTask: _care.toggle,
            onAddTask: _care.add,
            onDeleteTask: _care.remove,
            plantNames: _plants.plantNames,
          ),
          GrowthJournalScreen(
            notes: _growth.notes,
            onAddNote: _growth.add,
            onDeleteNote: _growth.remove,
            onUpdateNote: _growth.update,
            plantNames: _plants.plantNames,
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
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: strings.journal,
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