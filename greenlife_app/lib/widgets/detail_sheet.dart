import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/screens/care/add_task_screen.dart' show taskTypeInfoOf;

const Color _primary = Color(0xFF2F6A4F);
const Color _soft = Color(0xFFE2F4E4);
const Color _textColor = Color(0xFF1D2A1F);
const Color _muted = Color(0xFF5F6F62);

Future<void> showTaskDetailSheet(
  BuildContext context,
  CareTask task, {
  VoidCallback? onToggle,
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
              if (onToggle != null) ...[
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

Future<void> showPlantDetailSheet(BuildContext context, Plant plant) {
  final strings = AppLocalizations.of(context);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: SingleChildScrollView(
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
                  _PlantThumb(plant: plant),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plant.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          plant.scientificName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SheetRow(label: strings.category, value: plant.category),
              _SheetRow(label: strings.careLevel, value: plant.careLevel),
              _SheetRow(label: strings.water, value: plant.waterNeed),
              _SheetRow(label: strings.sunlight, value: plant.sunlight),
              const SizedBox(height: 8),
              Text(
                plant.description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF425246),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showTipDetailSheet(
  BuildContext context,
  Map<String, String> tip,
) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: SingleChildScrollView(
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _soft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.tips_and_updates, color: _primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip['title'] ?? '',
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
              Text(
                tip['content'] ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF425246),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showGrowthNoteDetailSheet(BuildContext context, GrowthNote note) {
  final strings = AppLocalizations.of(context);
  final isEnglish = Localizations.localeOf(context).languageCode == 'en';

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: SingleChildScrollView(
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _soft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.menu_book_outlined, color: _primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      note.title,
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
              _SheetRow(label: strings.plant, value: note.plantName),
              _SheetRow(
                label: isEnglish ? 'Date' : 'Ngày ghi',
                value: note.date,
              ),
              const SizedBox(height: 8),
              Text(
                note.summary,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Color(0xFF425246),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _PlantThumb extends StatelessWidget {
  const _PlantThumb({required this.plant});

  final Plant plant;

  Widget _placeholder() {
    return Container(
      width: 64,
      height: 64,
      color: _soft,
      alignment: Alignment.center,
      child: Text(plant.imageAsset, style: const TextStyle(fontSize: 30)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: plant.imageUrl.isEmpty
          ? _placeholder()
          : Image.network(
              plant.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _placeholder(),
            ),
    );
  }
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