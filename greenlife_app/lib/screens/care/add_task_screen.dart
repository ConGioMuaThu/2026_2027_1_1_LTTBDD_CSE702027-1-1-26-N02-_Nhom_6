import 'package:flutter/material.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/utils/app_colors.dart';
import 'package:greenlife_app/utils/app_constants.dart';
import 'package:greenlife_app/utils/date_utils.dart';
import 'package:greenlife_app/utils/validators.dart';

class TaskTypeInfo {
  const TaskTypeInfo({
    required this.id,
    required this.icon,
    required this.color,
    required this.labelVi,
    required this.labelEn,
  });

  final String id;
  final IconData icon;
  final Color color;
  final String labelVi;
  final String labelEn;

  String label(bool isEnglish) => isEnglish ? labelEn : labelVi;
}

const List<TaskTypeInfo> kTaskTypes = [
  TaskTypeInfo(
    id: 'watering',
    icon: Icons.water_drop_outlined,
    color: Color(0xFF4A90C2),
    labelVi: 'Tưới nước',
    labelEn: 'Watering',
  ),
  TaskTypeInfo(
    id: 'fertilize',
    icon: Icons.eco_outlined,
    color: Color(0xFF74B97D),
    labelVi: 'Bón phân',
    labelEn: 'Fertilize',
  ),
  TaskTypeInfo(
    id: 'inspection',
    icon: Icons.search,
    color: Color(0xFFEAB349),
    labelVi: 'Kiểm tra lá',
    labelEn: 'Check leaves',
  ),
  TaskTypeInfo(
    id: 'prune',
    icon: Icons.content_cut,
    color: Color(0xFFE46D5F),
    labelVi: 'Tỉa cành',
    labelEn: 'Prune stems',
  ),
];

TaskTypeInfo taskTypeInfoOf(String id) {
  return kTaskTypes.firstWhere(
    (type) => type.id == id,
    orElse: () => const TaskTypeInfo(
      id: 'other',
      icon: Icons.task_alt,
      color: AppColors.textSecondary,
      labelVi: 'Khác',
      labelEn: 'Other',
    ),
  );
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
    this.plantNames,
    this.initialPlantName,
  });

  final List<String>? plantNames;
  final String? initialPlantName;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  late List<String> _plantOptions;
  late DateTime _date;
  late TimeOfDay _time;
  late String _autoTitle;

  String _type = kTaskTypes.first.id;
  String? _plantName;
  bool _initialized = false;

  bool get _isEnglish => Localizations.localeOf(context).languageCode == 'en';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final locale = Localizations.localeOf(context);
    _plantOptions = List<String>.from(
      widget.plantNames ?? samplePlantsFor(locale).map((p) => p.name),
    );

    final initial = widget.initialPlantName;
    if (initial != null && !_plantOptions.contains(initial)) {
      _plantOptions.insert(0, initial);
    }
    _plantName = initial ?? (_plantOptions.isNotEmpty ? _plantOptions.first : null);

    final start = DateTime.now().add(const Duration(hours: 1));
    _date = AppDateUtils.dateOnly(start);
    _time = TimeOfDay(hour: start.hour, minute: 0);

    _autoTitle = taskTypeInfoOf(_type).label(_isEnglish);
    _titleController.text = _autoTitle;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onTypeSelected(TaskTypeInfo info) {
    setState(() {
      final current = _titleController.text.trim();
      if (current.isEmpty || current == _autoTitle) {
        _autoTitle = info.label(_isEnglish);
        _titleController.text = _autoTitle;
      }
      _type = info.id;
    });
  }

  Future<void> _pickDate() async {
    final today = AppDateUtils.today();

    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(today) ? today : _date,
      firstDate: today,
      lastDate: today.add(const Duration(days: AppConstants.taskMaxDaysAhead)),
    );

    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );

    if (picked != null && mounted) {
      setState(() => _time = picked);
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final dueAt = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );

    if (dueAt.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).dueTimeInPast),
        ),
      );
      return;
    }

    final task = CareTask(
      id: 'task-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      plantName: _plantName!,
      type: _type,
      dueDate: AppDateUtils.formatDueDate(dueAt, isEnglish: _isEnglish),
      dueAt: dueAt,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isEnglish = _isEnglish;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
        title: Text(
          strings.addTaskTitle,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _SectionLabel(strings.taskType),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final info in kTaskTypes) _buildTypeChip(info, isEnglish),
                ],
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.title),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.done,
                maxLength: AppConstants.titleMaxLength,
                decoration: _inputDecoration(
                  strings.taskTitleLabel,
                  Icons.edit_outlined,
                ),
                validator: Validators.text(
                  emptyMessage: strings.taskTitleRequired,
                  min: AppConstants.titleMinLength,
                  tooShortMessage: strings.taskTitleTooShort,
                ),
              ),
              const SizedBox(height: 12),
              _SectionLabel(strings.plant),
              DropdownButtonFormField<String>(
                initialValue: _plantName,
                isExpanded: true,
                decoration: _inputDecoration(
                  strings.plant,
                  Icons.local_florist_outlined,
                ),
                items: [
                  for (final name in _plantOptions)
                    DropdownMenuItem(value: name, child: Text(name)),
                ],
                onChanged: (value) => setState(() => _plantName = value),
                validator: (value) =>
                    Validators.selection(value, strings.choosePlantRequired),
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.dueDate),
              Row(
                children: [
                  Expanded(
                    child: _PickerField(
                      label: strings.dateLabel,
                      value: AppDateUtils.formatDate(_date),
                      icon: Icons.calendar_today_outlined,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PickerField(
                      label: strings.timeLabel,
                      value: AppDateUtils.formatTime(_time),
                      icon: Icons.access_time,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(strings.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: Text(strings.save),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(TaskTypeInfo info, bool isEnglish) {
    final selected = _type == info.id;

    return ChoiceChip(
      showCheckmark: false,
      selected: selected,
      selectedColor: info.color,
      backgroundColor: Colors.white,
      avatar: Icon(
        info.icon,
        size: 18,
        color: selected ? Colors.white : info.color,
      ),
      label: Text(info.label(isEnglish)),
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.text,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) => _onTypeSelected(info),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: InputDecorator(
        decoration: _inputDecoration(label, icon),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String label, IconData icon) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: AppColors.primary.withAlpha(51)),
  );

  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.primary),
    filled: true,
    fillColor: Colors.white,
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  );
}