import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/screens/my_plants/add_plant_screen.dart';
import 'package:greenlife_app/screens/my_plants/edit_plant_screen.dart';
import 'package:greenlife_app/utils/app_colors.dart';
import 'package:greenlife_app/widgets/detail_sheet.dart';
import 'package:greenlife_app/widgets/empty_state.dart';
import 'package:greenlife_app/widgets/plant_image.dart';
import 'package:greenlife_app/widgets/search_bar.dart';

enum _PlantAction { edit, delete }

class MyPlantsScreen extends StatefulWidget {
  final List<Plant> plants;
  final void Function(Plant plant) onAddPlant;
  final void Function(String plantId) onDeletePlant;
  final void Function(Plant plant)? onUpdatePlant;

  /// Tên của TẤT CẢ cây (kể cả thư viện) để kiểm tra trùng tên.
  final List<String>? existingNames;

  const MyPlantsScreen({
    super.key,
    required this.plants,
    required this.onAddPlant,
    required this.onDeletePlant,
    this.onUpdatePlant,
    this.existingNames,
  });

  @override
  State<MyPlantsScreen> createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedPlantId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _plantNames =>
      widget.existingNames ?? widget.plants.map((p) => p.name).toList();

  List<Plant> get _filteredPlants {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.plants;
    }
    return widget.plants.where((plant) {
      return plant.name.toLowerCase().contains(query) ||
          plant.scientificName.toLowerCase().contains(query) ||
          plant.category.toLowerCase().contains(query) ||
          plant.waterNeed.toLowerCase().contains(query);
    }).toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openAddPlant() async {
    final strings = AppLocalizations.of(context);

    final plant = await Navigator.push<Plant>(
      context,
      MaterialPageRoute(
        builder: (_) => AddPlantScreen(existingNames: _plantNames),
      ),
    );
    if (plant == null || !mounted) return;

    widget.onAddPlant(plant);
    _showMessage(strings.plantAdded);
  }

  Future<void> _openEditPlant(Plant plant) async {
    final strings = AppLocalizations.of(context);

    final updated = await Navigator.push<Plant>(
      context,
      MaterialPageRoute(
        builder: (_) => EditPlantScreen(
          plant: plant,
          existingNames: _plantNames,
        ),
      ),
    );
    if (updated == null || !mounted) return;

    widget.onUpdatePlant?.call(updated);
    _showMessage(strings.plantUpdated);
  }

  Future<bool> _confirmDelete(Plant plant) async {
    final strings = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.deletePlantQuestion),
        content: Text(strings.deletePlantMessage(plant.name)),
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

    return confirmed == true;
  }

  void _deletePlant(Plant plant) {
    final strings = AppLocalizations.of(context);

    widget.onDeletePlant(plant.id);
    if (_selectedPlantId == plant.id) {
      setState(() => _selectedPlantId = null);
    }
    _showMessage(strings.plantDeleted);
  }

  Future<void> _onMenuAction(_PlantAction action, Plant plant) async {
    switch (action) {
      case _PlantAction.edit:
        await _openEditPlant(plant);
      case _PlantAction.delete:
        final confirmed = await _confirmDelete(plant);
        if (confirmed && mounted) _deletePlant(plant);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final filteredPlants = _filteredPlants;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.myGardenTitle,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                IconButton(
                  onPressed: _openAddPlant,
                  tooltip: strings.addPlantTitle,
                  icon: const Icon(Icons.add_circle_outline, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 14),
            CustomSearchBar(
              controller: _searchController,
              hintText: strings.searchGarden,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: filteredPlants.isEmpty
                  ? (widget.plants.isEmpty
                      ? EmptyState(
                          icon: Icons.local_florist_outlined,
                          title: strings.emptyGardenTitle,
                          message: strings.emptyGardenMessage,
                        )
                      : Center(
                          child: Text(strings.noGardenMatch),
                        ))
                  : ListView.separated(
                      itemCount: filteredPlants.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final plant = filteredPlants[index];
                        final isSelected = _selectedPlantId == plant.id;
                        return Dismissible(
                          key: ValueKey(plant.id),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withAlpha(38),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: AppColors.danger,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => _confirmDelete(plant),
                          onDismissed: (_) => _deletePlant(plant),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() => _selectedPlantId = plant.id);
                                showPlantDetailSheet(context, plant);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: _PlantThumbnail(plant: plant),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            plant.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            plant.category,
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.water_drop,
                                                size: 16,
                                                color: Color(0xFF4BA0C8),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  plant.waterNeed,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<_PlantAction>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: AppColors.textSecondary,
                                      ),
                                      onSelected: (action) =>
                                          _onMenuAction(action, plant),
                                      itemBuilder: (_) => [
                                        if (widget.onUpdatePlant != null)
                                          PopupMenuItem(
                                            value: _PlantAction.edit,
                                            child: ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.zero,
                                              leading: const Icon(Icons.edit_outlined),
                                              title: Text(strings.editPlant),
                                            ),
                                          ),
                                        PopupMenuItem(
                                          value: _PlantAction.delete,
                                          child: ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            leading: const Icon(
                                              Icons.delete_outline,
                                              color: AppColors.danger,
                                            ),
                                            title: Text(
                                              strings.deletePlant,
                                              style: const TextStyle(
                                                color: AppColors.danger,
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

class _PlantThumbnail extends StatelessWidget {
  const _PlantThumbnail({required this.plant});

  final Plant plant;

  Widget _placeholder() {
    return Container(
      width: 72,
      height: 72,
      color: AppColors.soft,
      child: Center(
        child: Text(
          plant.imageAsset,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (plant.imageUrl.isEmpty) return _placeholder();

    return plantImage(
      plant.imageUrl,
      width: 72,
      height: 72,
      placeholder: _placeholder,
    );
  }
}