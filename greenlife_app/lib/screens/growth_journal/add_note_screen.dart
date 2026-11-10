import 'package:flutter/material.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/growth_note.dart';
import 'package:greenlife_app/services/image_service.dart';
import 'package:greenlife_app/utils/app_colors.dart';
import 'package:greenlife_app/utils/app_constants.dart';
import 'package:greenlife_app/utils/date_utils.dart';
import 'package:greenlife_app/utils/validators.dart';
import 'package:greenlife_app/widgets/plant_image.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    super.key,
    this.plantNames,
    this.initialPlantName,
    this.initialNote,
  });

  final List<String>? plantNames;

  final String? initialPlantName;

  final GrowthNote? initialNote;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();

  late List<String> _plantOptions;
  late DateTime _date;

  String? _plantName;
  String? _image;
  bool _pickingImage = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final locale = Localizations.localeOf(context);
    final provided = widget.plantNames;
    _plantOptions = List<String>.from(
      provided ?? samplePlantsFor(locale).map((p) => p.name),
    );

    final editing = widget.initialNote;
    final initial = editing?.plantName ?? widget.initialPlantName;
    if (initial != null && !_plantOptions.contains(initial)) {
      _plantOptions.insert(0, initial);
    }
    _plantName =
        initial ?? (_plantOptions.isNotEmpty ? _plantOptions.first : null);

    _date = AppDateUtils.today();

    if (editing != null) {
      _titleController.text = editing.title;
      _summaryController.text = editing.summary;
      _date = AppDateUtils.parseDate(editing.date) ?? _date;
      _image = editing.imagePath.isEmpty ? null : editing.imagePath;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool camera}) async {
    if (_pickingImage) return;
    setState(() => _pickingImage = true);

    final reference = camera
        ? await ImageService.instance.takeAndStore()
        : await ImageService.instance.pickAndStore();

    if (!mounted) return;
    setState(() {
      _pickingImage = false;
      if (reference != null) _image = reference;
    });
  }

  Widget _buildPhotoSection(AppLocalizations strings) {
    final image = _image;

    if (image != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: plantImage(
              image,
              width: double.infinity,
              height: 170,
              placeholder: () => Container(
                height: 170,
                color: AppColors.soft,
                alignment: Alignment.center,
                child: const Icon(Icons.image_outlined, size: 48),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _image = null),
            icon: const Icon(Icons.delete_outline),
            label: Text(strings.removePhoto),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          ),
        ],
      );
    }

    final style = OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _pickingImage ? null : () => _pickImage(camera: false),
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(strings.pickFromGallery),
            style: style,
          ),
        ),
        if (ImageService.instance.canUseCamera) ...[
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _pickingImage ? null : () => _pickImage(camera: true),
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(strings.takePhoto),
              style: style,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _pickDate() async {
    final today = AppDateUtils.today();
    final earliest = DateTime(today.year - AppConstants.noteHistoryYears);

    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isAfter(today) ? today : _date,
      firstDate: _date.isBefore(earliest) ? _date : earliest,
      lastDate: today,
    );

    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  bool get _isDirty {
    final note = widget.initialNote;
    final title = _titleController.text.trim();
    final summary = _summaryController.text.trim();
    if (note == null) {
      return title.isNotEmpty || summary.isNotEmpty || _image != null;
    }
    return title != note.title ||
        summary != note.summary ||
        _plantName != note.plantName ||
        AppDateUtils.formatDate(_date) != note.date ||
        (_image ?? '') != note.imagePath;
  }

  Future<bool> _confirmDiscard() async {
    final strings = AppLocalizations.of(context);

    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.discardChangesQuestion),
        content: Text(strings.discardChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.keepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(strings.discardAction),
          ),
        ],
      ),
    );

    return discard == true;
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final note = GrowthNote(
      id: widget.initialNote?.id ?? 'note-${DateTime.now().millisecondsSinceEpoch}',
      plantName: _plantName!,
      title: _titleController.text.trim(),
      date: AppDateUtils.formatDate(_date),
      summary: _summaryController.text.trim(),
      imagePath: _image ?? '',
    );

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    final scaffold = Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
        title: Text(
          widget.initialNote == null ? strings.newNoteTitle : strings.editNote,
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
          onChanged: () => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              _SectionLabel(strings.plant),
              DropdownButtonFormField<String>(
                initialValue: _plantName,
                isExpanded: true,
                decoration: _inputDecoration(
                  strings.plantName,
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
              _SectionLabel(strings.title),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                maxLength: AppConstants.titleMaxLength,
                decoration: _inputDecoration(
                  strings.title,
                  Icons.edit_outlined,
                ),
                validator: Validators.text(
                  emptyMessage: strings.noteTitleRequired,
                  min: AppConstants.titleMinLength,
                  tooShortMessage: strings.noteTitleTooShort,
                ),
              ),
              const SizedBox(height: 12),
              _SectionLabel(strings.noteDate),
              _PickerField(
                label: strings.dateLabel,
                value: AppDateUtils.formatDate(_date),
                icon: Icons.calendar_today_outlined,
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.descriptionGrowth),
              TextFormField(
                controller: _summaryController,
                minLines: 4,
                maxLines: 8,
                maxLength: AppConstants.noteSummaryMaxLength,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  strings.noteContentHint,
                  Icons.notes_outlined,
                ).copyWith(alignLabelWithHint: true),
                validator: Validators.text(
                  emptyMessage: strings.noteContentRequired,
                  min: AppConstants.noteSummaryMinLength,
                  tooShortMessage: strings.noteContentTooShort,
                ),
              ),
              const SizedBox(height: 16),
              _SectionLabel(strings.photoLabel),
              _buildPhotoSection(strings),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.maybePop(context),
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

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final discard = await _confirmDiscard();

        if (!mounted) return;

        if (discard) {
          navigator.pop();
        }
      },
      child: scaffold,
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