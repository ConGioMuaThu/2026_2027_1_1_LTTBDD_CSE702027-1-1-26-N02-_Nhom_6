import 'package:flutter/material.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/growth_note.dart';

const Color _primary = Color(0xFF2F6A4F);
const Color _background = Color(0xFFF5F8F2);
const Color _textColor = Color(0xFF1D2A1F);

/// Màn hình thêm ghi chú nhật ký phát triển.
///
/// Trả về [GrowthNote] qua `Navigator.pop` khi người dùng bấm Lưu,
/// hoặc `null` nếu người dùng hủy / quay lại.
class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({
    super.key,
    this.plantNames,
    this.initialPlantName,
  });

  /// Danh sách tên cây để chọn. Nếu null sẽ dùng danh sách cây mẫu.
  final List<String>? plantNames;

  /// Cây được chọn sẵn (ví dụ mở từ trang chi tiết cây).
  final String? initialPlantName;

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
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final locale = Localizations.localeOf(context);
    final provided = widget.plantNames;
    _plantOptions = List<String>.from(
      (provided != null && provided.isNotEmpty)
          ? provided
          : samplePlantsFor(locale).map((p) => p.name),
    );

    final initial = widget.initialPlantName;
    if (initial != null && !_plantOptions.contains(initial)) {
      _plantOptions.insert(0, initial);
    }
    _plantName =
        initial ?? (_plantOptions.isNotEmpty ? _plantOptions.first : null);

    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isAfter(today) ? today : _date,
      // Nhật ký ghi lại những gì đã xảy ra nên chỉ cho chọn đến hôm nay.
      firstDate: DateTime(today.year - 5),
      lastDate: today,
    );

    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final note = GrowthNote(
      id: 'note-${DateTime.now().millisecondsSinceEpoch}',
      plantName: _plantName!,
      title: _titleController.text.trim(),
      date: _formatDate(_date),
      summary: _summaryController.text.trim(),
    );

    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: _textColor),
        title: Text(
          strings.newNoteTitle,
          style: const TextStyle(
            color: _textColor,
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
                    value == null ? strings.choosePlantRequired : null,
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.title),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 40,
                decoration: _inputDecoration(
                  strings.title,
                  Icons.edit_outlined,
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return strings.noteTitleRequired;
                  if (text.length < 3) return strings.noteTitleTooShort;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _SectionLabel(strings.noteDate),
              _PickerField(
                label: strings.dateLabel,
                value: _formatDate(_date),
                icon: Icons.calendar_today_outlined,
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.descriptionGrowth),
              TextFormField(
                controller: _summaryController,
                minLines: 4,
                maxLines: 8,
                maxLength: 300,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  strings.noteContentHint,
                  Icons.notes_outlined,
                ).copyWith(alignLabelWithHint: true),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return strings.noteContentRequired;
                  if (text.length < 10) return strings.noteContentTooShort;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _primary,
                        side: const BorderSide(color: _primary),
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
                        backgroundColor: _primary,
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
          color: _textColor,
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
            color: _textColor,
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String label, IconData icon) {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(color: _primary.withAlpha(51)),
  );

  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: _primary),
    filled: true,
    fillColor: Colors.white,
    border: border,
    enabledBorder: border,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: _primary, width: 1.5),
    ),
  );
}

String _two(int n) => n.toString().padLeft(2, '0');

/// Định dạng dd/MM/yyyy, khớp với dữ liệu mẫu ('18/10/2026').
String _formatDate(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';