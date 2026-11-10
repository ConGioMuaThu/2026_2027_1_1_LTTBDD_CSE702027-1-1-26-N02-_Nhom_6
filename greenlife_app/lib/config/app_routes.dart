import 'package:flutter/material.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/screens/care/add_task_screen.dart';
import 'package:greenlife_app/screens/care/task_detail_screen.dart';
import 'package:greenlife_app/screens/growth_journal/add_note_screen.dart';
import 'package:greenlife_app/screens/growth_journal/note_detail_screen.dart';
import 'package:greenlife_app/screens/my_plants/add_plant_screen.dart';
import 'package:greenlife_app/screens/my_plants/edit_plant_screen.dart';
import 'package:greenlife_app/screens/plant_library/plant_detail_screen.dart';
import 'package:greenlife_app/utils/app_constants.dart';

class AppTabs {
  AppTabs._();

  static const int home = 0;
  static const int library = 1;
  static const int garden = 2;
  static const int care = 3;
  static const int journal = 4;
  static const int tips = 5;
  static const int team = 6;
  static const int count = 7;
}

class AppRoutes {
  AppRoutes._();

  static Route<T> _page<T>(WidgetBuilder builder) {
    return MaterialPageRoute<T>(builder: builder);
  }

  static Route<Plant> addPlant({List<String> existingNames = const []}) {
    return _page((_) => AddPlantScreen(existingNames: existingNames));
  }

  static Route<Plant> editPlant({
    required Plant plant,
    List<String> existingNames = const [],
  }) {
    return _page(
      (_) => EditPlantScreen(plant: plant, existingNames: existingNames),
    );
  }

  static Route<void> plantDetail({
    required Plant plant,
    VoidCallback? onToggleFavorite,
    void Function(CareTask task)? onAddTask,
    List<String>? plantNames,
  }) {
    return _page(
      (_) => PlantDetailScreen(
        plant: plant,
        onToggleFavorite: onToggleFavorite,
        onAddTask: onAddTask,
        plantNames: plantNames,
      ),
    );
  }

  static Route<CareTask> addTask({
    List<String>? plantNames,
    String? initialPlantName,
  }) {
    return _page(
      (_) => AddTaskScreen(
        plantNames: plantNames,
        initialPlantName: initialPlantName,
      ),
    );
  }

  static Route<void> taskDetail({
    required CareTask task,
    required VoidCallback onToggle,
    VoidCallback? onDelete,
  }) {
    return _page(
      (_) => TaskDetailScreen(
        task: task,
        onToggle: onToggle,
        onDelete: onDelete,
      ),
    );
  }

  static Route<GrowthNote> addNote({
    List<String>? plantNames,
    String? initialPlantName,
    GrowthNote? initialNote,
  }) {
    return _page(
      (_) => AddNoteScreen(
        plantNames: plantNames,
        initialPlantName: initialPlantName,
        initialNote: initialNote,
      ),
    );
  }

  static Route<void> noteDetail({
    required GrowthNote note,
    VoidCallback? onDelete,
    void Function(GrowthNote note)? onUpdate,
    List<String>? plantNames,
  }) {
    return _page(
      (_) => NoteDetailScreen(
        note: note,
        onDelete: onDelete,
        onUpdate: onUpdate,
        plantNames: plantNames,
      ),
    );
  }

  static Route<T> fadeScale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, animation, _) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOutCubic))
                .animate(curved),
            child: page,
          ),
        );
      },
      transitionDuration: AppConstants.splashTransitionDuration,
      reverseTransitionDuration: AppConstants.splashReverseTransitionDuration,
    );
  }
}