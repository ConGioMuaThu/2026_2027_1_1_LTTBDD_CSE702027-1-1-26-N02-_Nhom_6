import 'package:flutter/material.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/screens/care/care_screen.dart';
import 'package:greenlife_app/screens/developers/developers_screen.dart';

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
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          CareScreen(tasks: _tasks, onToggleTask: _toggleTask),
          const DevelopersScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Care'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Team'),
        ],
      ),
    );
  }
}