import 'package:flutter/material.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/screens/care/care_screen.dart';
import 'package:greenlife_app/screens/developers/developers_screen.dart';
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
  late final List<CareTask> _tasks = sampleTasksFor(widget.locale);

  void _toggleTask(String id) {
    setState(() {
      final i = _tasks.indexWhere((t) => t.id == id);
      if (i == -1) return;
      final t = _tasks[i];
      _tasks[i] = CareTask(
        id: t.id,
        title: t.title,
        plantName: t.plantName,
        type: t.type,
        dueDate: t.dueDate,
        isCompleted: !t.isCompleted,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          CareScreen(tasks: _tasks, onToggleTask: _toggleTask),
          const PlantLibraryScreen(),
          const TipsScreen(),
          const DevelopersScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calendar_month),
            label: strings.care,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_florist),
            label: strings.library,
          ),
          NavigationDestination(
            icon: const Icon(Icons.tips_and_updates),
            label: strings.tips,
          ),
          NavigationDestination(
            icon: const Icon(Icons.groups),
            label: strings.teamInfo,
          ),
        ],
      ),
    );
  }
}