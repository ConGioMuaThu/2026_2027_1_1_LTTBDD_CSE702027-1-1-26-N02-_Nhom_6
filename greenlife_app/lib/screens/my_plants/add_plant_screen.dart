import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/utils/app_colors.dart';
import 'package:greenlife_app/utils/app_constants.dart';
import 'package:greenlife_app/utils/validators.dart';

const List<String> _plantIcons = [
  '🌿',
  '🌱',
  '🌵',
  '🌹',
  '🌸',
  '🌻',
  '🌳',
  '🍀',
  '🌴',
];

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({
    super.key,
    this.existingNames = const [],
    this.initialPlant,
  });

  final List<String> existingNames;
  final Plant? initialPlant;

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scientificController = TextEditingController();
  final _waterController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  late String _icon;
  late String _category;
  late String _careLevel;
  late String _sunlight;
  bool _initialized = false;

  bool get _isEditing => widget.initialPlant != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final strings = AppLocalizations.of(context);
    final plant = widget.initialPlant;

    if (plant == null) {
      _icon = _plantIcons.first;
      _category = strings.categoryIndoor;
      _careLevel = strings.careLevelEasy;
      _sunlight = strings.sunlightIndirect;
      _waterController.text = strings.waterNeedDefault;
      return;
    }

    _icon = plant.imageAsset;
    _category = plant.category;
    _careLevel = plant.careLevel;
    _sunlight = plant.sunlight;
    _nameController.text = plant.name;
    _scientificController.text = plant.scientificName;
    _waterController.text = plant.waterNeed;
    _descriptionController.text = plant.description;
    _imageUrlController.text = plant.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scientificController.dispose();
    _waterController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  bool get _isDirty {
    final plant = widget.initialPlant;
    final name = _nameController.text.trim();
    final scientific = _scientificController.text.trim();
    final description = _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (plant == null) {
      return name.isNotEmpty ||
          scientific.isNotEmpty ||
          description.isNotEmpty ||
          imageUrl.isNotEmpty;
    }

    return name != plant.name ||
        scientific != plant.scientificName ||
        description != plant.description ||
        imageUrl != plant.imageUrl ||
        _waterController.text.trim() != plant.waterNeed ||
        _icon != plant.imageAsset ||
        _category != plant.category ||
        _careLevel != plant.careLevel ||
        _sunlight != plant.sunlight;
  }

  Set<String> get _takenNames {
    final own = widget.initialPlant?.name.trim().toLowerCase();
    return {
      for (final name in widget.existingNames)
        if (name.trim().toLowerCase() != own) name.trim().toLowerCase(),
    };
  }

  String? _validateName(String? value, AppLocalizations strings) {
    final error = Validators.text(
      emptyMessage: strings.plantNameRequired,
      min: AppConstants.plantNameMinLength,
      tooShortMessage: strings.plantNameTooShort,
    )(value);
    if (error != null) return error;

    return _takenNames.contains(value!.trim().toLowerCase())
        ? strings.plantNameDuplicate
        : null;
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

    final strings = AppLocalizations.of(context);
    final description = _descriptionController.text.trim();
    final previous = widget.initialPlant;

    final plant = Plant(
      id: previous?.id ?? 'plant-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      scientificName: _scientificController.text.trim(),
      category: _category,
      description: description.isEmpty ? strings.newPlantDescription : description,
      careLevel: _careLevel,
      waterNeed: _waterController.text.trim(),
      sunlight: _sunlight,
      imageAsset: _icon,
      imageUrl: _imageUrlController.text.trim(),
      isFavorite: previous?.isFavorite ?? false,
      tags: previous?.tags ?? const [],
    );

    Navigator.pop(context, plant);
  }

  List<String> _options(List<String> base, String current) {
    if (current.isEmpty || base.contains(current)) return base;
    return [current, ...base];
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);

    final categories = _options(
      [
        strings.categoryIndoor,
        strings.categoryOutdoor,
        strings.categorySucculent,
      ],
      _category,
    );
    final careLevels = _options(
      [
        strings.careLevelEasy,
        strings.careLevelModerate,
        strings.careLevelHard,
      ],
      _careLevel,
    );
    final sunlights = _options(
      [
        strings.sunlightIndirect,
        strings.sunlightSoft,
        strings.sunlightPartial,
        strings.sunlightDirect,
      ],
      _sunlight,
    );
    final icons = _options(_plantIcons, _icon);

    final scaffold = Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
        title: Text(
          _isEditing ? strings.editPlant : strings.addPlantTitle,
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
              _SectionLabel(strings.plantIcon),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final icon in icons)
                    ChoiceChip(
                      label: Text(icon, style: const TextStyle(fontSize: 22)),
                      selected: _icon == icon,
                      selectedColor: AppColors.soft,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: _icon == icon
                            ? AppColors.primary
                            : AppColors.primary.withAlpha(51),
                      ),
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _icon = icon),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.plantName),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                maxLength: AppConstants.plantNameMaxLength,
                decoration: _inputDecoration(
                  strings.plantName,
                  Icons.local_florist_outlined,
                ),
                validator: (value) => _validateName(value, strings),
              ),
              const SizedBox(height: 12),
              _SectionLabel(strings.scientificName),
              TextFormField(
                controller: _scientificController,
                textInputAction: TextInputAction.next,
                maxLength: AppConstants.scientificNameMaxLength,
                decoration: _inputDecoration(
                  strings.scientificName,
                  Icons.science_outlined,
                ),
              ),
              const SizedBox(height: 12),
              _SectionLabel(strings.category),
              _dropdown(
                value: _category,
                items: categories,
                icon: Icons.category_outlined,
                label: strings.plantType,
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.careLevel),
              _dropdown(
                value: _careLevel,
                items: careLevels,
                icon: Icons.spa_outlined,
                label: strings.careLevel,
                onChanged: (value) => setState(() => _careLevel = value),
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.sunlight),
              _dropdown(
                value: _sunlight,
                items: sunlights,
                icon: Icons.wb_sunny_outlined,
                label: strings.sunlight,
                onChanged: (value) => setState(() => _sunlight = value),
              ),
              const SizedBox(height: 20),
              _SectionLabel(strings.waterNeed),
              TextFormField(
                controller: _waterController,
                textInputAction: TextInputAction.next,
                maxLength: AppConstants.titleMaxLength,
                decoration: _inputDecoration(
                  strings.waterNeed,
                  Icons.water_drop_outlined,
                ),
                validator: (value) =>
                    Validators.requiredField(value, strings.waterNeedRequired),
              ),
              const SizedBox(height: 12),
              _SectionLabel(strings.descriptionLabel),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 6,
                maxLength: AppConstants.plantDescriptionMaxLength,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: _inputDecoration(
                  strings.descriptionLabel,
                  Icons.notes_outlined,
                ).copyWith(alignLabelWithHint: true),
              ),
              const SizedBox(height: 12),
              _SectionLabel(strings.imageUrlOptional),
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration(
                  strings.imageUrlOptional,
                  Icons.image_outlined,
                ),
                validator: (value) =>
                    Validators.optionalUrl(value, strings.invalidImageUrl),
              ),
              const SizedBox(height: 24),
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
                      label: Text(_isEditing ? strings.save : strings.add),
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
        final discard = await _confirmDiscard();
        if (discard && mounted) Navigator.pop(context);
      },
      child: scaffold,
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: _inputDecoration(label, icon),
      items: [
        for (final item in items)
          DropdownMenuItem(
            value: item,
            child: Text(item, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
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