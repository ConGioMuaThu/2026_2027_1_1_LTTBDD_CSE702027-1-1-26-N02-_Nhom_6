import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/screens/care/add_task_screen.dart' show taskTypeInfoOf;

const Color _primary = Color(0xFF2F6A4F);
const Color _soft = Color(0xFFE2F4E4);
const Color _textColor = Color(0xFF1D2A1F);
const Color _muted = Color(0xFF5F6F62);

Future<void> showTaskDetailSheet(
  BuildContext context,
  CareTask task, {
  required VoidCallback onToggle,
}) {
  final strings = AppLocalizations.of(context);
  final isEnglish = Localizations.localeOf(context).languageCode == 'en';
  final typeInfo = taskTypeInfoOf(task.type);
  final statusText =
      task.isCompleted ? strings.completedStatus : strings.pendingStatus;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: typeInfo.color.withAlpha(38),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(typeInfo.icon, color: typeInfo.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SheetRow(label: strings.plant, value: task.plantName),
              _SheetRow(
                label: strings.taskType,
                value: typeInfo.label(isEnglish),
              ),
              _SheetRow(label: strings.dueDate, value: task.dueDate),
              _SheetRow(label: strings.status, value: statusText),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onToggle,
                  style: FilledButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    task.isCompleted
                        ? strings.togglePending
                        : strings.toggleDone,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showMemberDetailSheet(
  BuildContext context,
  Map<String, String> member,
) {
  final strings = AppLocalizations.of(context);
  final name = member['name'] ?? '';

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _soft,
                    child: Text(
                      name.isEmpty ? 'A' : name.substring(0, 1),
                      style: const TextStyle(
                        color: _primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SheetRow(label: strings.role, value: member['role'] ?? ''),
              _SheetRow(
                label: strings.assignment,
                value: member['focus'] ?? '',
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: _muted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}