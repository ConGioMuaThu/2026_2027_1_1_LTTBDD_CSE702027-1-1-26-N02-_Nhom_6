import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/screens/care/add_task_screen.dart';
import 'package:greenlife_app/utils/app_colors.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
    this.onUpdate,
    this.plantNames,
  });

  final CareTask task;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;
  final void Function(CareTask task)? onUpdate;
  final List<String>? plantNames;

  Future<void> _edit(BuildContext context) async {
    final updated = await Navigator.push<CareTask>(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(
          plantNames: plantNames,
          initialTask: task,
        ),
      ),
    );

    if (updated == null || !context.mounted) return;
    onUpdate!(updated);
    Navigator.pop(context);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final strings = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.deleteTaskQuestion),
        content: Text(strings.deleteTaskMessage(task.title, task.plantName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(strings.deleteAction),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      onDelete!();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final typeInfo = taskTypeInfoOf(task.type);
    final statusColor = task.isCompleted ? AppColors.taskDone : AppColors.taskPending;
    final statusText =
        task.isCompleted ? strings.completedStatus : strings.pendingStatus;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
        actions: [
          if (onUpdate != null)
            IconButton(
              onPressed: () => _edit(context),
              tooltip: strings.editTask,
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
        title: Text(
          strings.taskDetailsTitle,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.soft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: typeInfo.color.withAlpha(38),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(typeInfo.icon, size: 38, color: typeInfo.color),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    task.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.local_florist_outlined,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          task.plantName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Chip(
                    avatar: Icon(
                      task.isCompleted ? Icons.check_circle : Icons.schedule,
                      size: 18,
                      color: statusColor,
                    ),
                    label: Text(statusText),
                    labelStyle: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.local_florist_outlined,
                    label: strings.plant,
                    value: task.plantName,
                  ),
                  const Divider(height: 1),
                  _InfoRow(
                    icon: typeInfo.icon,
                    label: strings.taskType,
                    value: typeInfo.label(isEnglish),
                  ),
                  const Divider(height: 1),
                  _InfoRow(
                    icon: Icons.event_outlined,
                    label: strings.dueDate,
                    value: task.dueDate,
                  ),
                  const Divider(height: 1),
                  _InfoRow(
                    icon: Icons.flag_outlined,
                    label: strings.status,
                    value: statusText,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                onToggle();
                Navigator.pop(context);
              },
              icon: Icon(
                task.isCompleted ? Icons.undo : Icons.check_circle_outline,
              ),
              label: Text(
                task.isCompleted ? strings.togglePending : strings.toggleDone,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline),
                label: Text(strings.deleteTask),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 15, color: AppColors.textSecondary)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}