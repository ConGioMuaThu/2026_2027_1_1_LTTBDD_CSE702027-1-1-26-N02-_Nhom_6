import 'package:flutter/material.dart';
import 'package:greenlife_app/config/app_routes.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/repositories/care_repository.dart';
import 'package:greenlife_app/utils/app_colors.dart';
import 'package:greenlife_app/utils/date_utils.dart';
import 'package:greenlife_app/widgets/empty_state.dart';
import 'package:greenlife_app/widgets/search_bar.dart';

class CareScreen extends StatefulWidget {
  final List<CareTask> tasks;
  final void Function(String taskId) onToggleTask;
  final void Function(CareTask task)? onAddTask;
  final void Function(String taskId)? onDeleteTask;
  final void Function(CareTask task)? onUpdateTask;
  final List<String>? plantNames;

  const CareScreen({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    this.onAddTask,
    this.onDeleteTask,
    this.onUpdateTask,
    this.plantNames,
  });

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedTaskId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CareTask> get _filteredTasks {
    final query = _searchController.text.trim().toLowerCase();
    final sorted = CareRepository.sortByDue(widget.tasks);
    if (query.isEmpty) {
      return sorted;
    }
    return sorted.where((task) {
      final typeLabels = AppLocalizations.supportedLocales
          .map((locale) => AppLocalizations(locale).taskTypeLabel(task.type));
      return task.title.toLowerCase().contains(query) ||
          task.plantName.toLowerCase().contains(query) ||
          task.type.toLowerCase().contains(query) ||
          typeLabels.any((label) => label.toLowerCase().contains(query));
    }).toList();
  }

  Future<void> _openAddTask() async {
    final newTask = await Navigator.push<CareTask>(
      context,
      AppRoutes.addTask(plantNames: widget.plantNames),
    );
    if (newTask != null) {
      widget.onAddTask?.call(newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final totalTasks = widget.tasks.length;
    final completedTasks = widget.tasks.where((task) => task.isCompleted).length;
    final filteredTasks = _filteredTasks;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    strings.careScheduleTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (widget.onAddTask != null)
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.add),
                    onPressed: _openAddTask,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.pendingStatus,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${totalTasks - completedTasks} ${strings.tasksCount}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.soft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.completedLabel,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$completedTasks/$totalTasks',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            CustomSearchBar(
              controller: _searchController,
              hintText: strings.searchTasksHint,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredTasks.isEmpty
                  ? EmptyState(message: strings.noTasksFoundDetail)
                  : ListView.separated(
                      itemCount: filteredTasks.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        final dueAt = task.dueAt;
                        final overdue = !task.isCompleted &&
                            dueAt != null &&
                            AppDateUtils.isOverdue(dueAt);
                        final color = task.isCompleted
                            ? AppColors.taskDone
                            : overdue
                                ? AppColors.danger
                                : AppColors.taskPending;
                        final isSelected = _selectedTaskId == task.id;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() => _selectedTaskId = task.id);
                              Navigator.push(
                                context,
                                AppRoutes.taskDetail(
                                  task: task,
                                  plantNames: widget.plantNames,
                                  onUpdate: widget.onUpdateTask == null
                                      ? null
                                      : (updated) {
                                          widget.onUpdateTask!(updated);
                                          setState(() {});
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(strings.taskUpdated),
                                            ),
                                          );
                                        },
                                  onToggle: () {
                                    widget.onToggleTask(task.id);
                                    setState(() {});
                                  },
                                  onDelete: widget.onDeleteTask == null
                                      ? null
                                      : () {
                                          widget.onDeleteTask!(task.id);
                                          setState(() {});
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(strings.taskDeleted),
                                            ),
                                          );
                                        },
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: color.withAlpha(28),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      task.isCompleted
                                          ? Icons.check
                                          : overdue
                                              ? Icons.warning_amber_rounded
                                              : Icons.notifications_active,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${task.plantName} • ${strings.taskTypeLabel(task.type)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          overdue
                                              ? '${task.dueDate} • ${strings.overdue}'
                                              : task.dueDate,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: overdue
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: overdue
                                                ? AppColors.danger
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    value: task.isCompleted,
                                    onChanged: (_) {
                                      widget.onToggleTask(task.id);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}