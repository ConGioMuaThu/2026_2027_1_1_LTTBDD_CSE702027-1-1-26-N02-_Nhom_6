import 'package:flutter/material.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/widgets/detail_sheet.dart';

class MyPlantsScreen extends StatefulWidget {
  final List<Plant> plants;
  final void Function(Plant plant) onAddPlant;
  final void Function(String plantId) onDeletePlant;

  const MyPlantsScreen({
    super.key,
    required this.plants,
    required this.onAddPlant,
    required this.onDeletePlant,
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

  List<Plant> get _filteredPlants {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.plants;
    }
    return widget.plants.where((plant) {
      return plant.name.toLowerCase().contains(query) ||
          plant.category.toLowerCase().contains(query) ||
          plant.waterNeed.toLowerCase().contains(query);
    }).toList();
  }

  void _showAddPlantDialog(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final categoryController = TextEditingController(text: strings.indoorPlantDefault);
    final waterNeedController = TextEditingController(text: strings.waterNeedDefault);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(strings.addPlantTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: strings.plantName),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: strings.plantType),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: waterNeedController,
                  decoration: InputDecoration(labelText: strings.waterNeed),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final newPlant = Plant(
                  id: 'plant-${DateTime.now().millisecondsSinceEpoch}',
                  name: name,
                  scientificName: 'Plant ${widget.plants.length + 1}',
                  category: categoryController.text.trim().isEmpty
                      ? strings.indoorPlantDefault
                      : categoryController.text.trim(),
                  description: strings.newPlantDescription,
                  careLevel: strings.easyCareLevel,
                  waterNeed: waterNeedController.text.trim().isEmpty
                      ? strings.waterNeedDefault
                      : waterNeedController.text.trim(),
                  sunlight: strings.indirectSunlight,
                  imageAsset: '🌿',
                  imageUrl:
                      'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?auto=format&fit=crop&w=900&q=80',
                  tags: ['new', 'personal'],
                );

                widget.onAddPlant(newPlant);
                Navigator.pop(dialogContext);
              },
              child: Text(strings.add),
            ),
          ],
        );
      },
    );
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
                  onPressed: () => _showAddPlantDialog(context),
                  icon: const Icon(Icons.add_circle_outline, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: strings.searchGarden,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: filteredPlants.isEmpty
                  ? Center(
                      child: Text(strings.noGardenMatch),
                    )
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
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.delete_outline, color: Colors.red),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => widget.onDeletePlant(plant.id),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() => _selectedPlantId = plant.id);
                                showPlantDetailSheet(context, plant);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF2F6A4F) : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: plant.imageUrl.isNotEmpty
                                          ? Image.network(
                                              plant.imageUrl,
                                              width: 72,
                                              height: 72,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                width: 72,
                                                height: 72,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFE2F4E4),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    plant.imageAsset,
                                                    style: const TextStyle(fontSize: 30),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 72,
                                              height: 72,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE2F4E4),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  plant.imageAsset,
                                                  style: const TextStyle(fontSize: 30),
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            plant.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            plant.category,
                                            style: const TextStyle(
                                              color: Color(0xFF5F6F62),
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
                                              Text(
                                                plant.waterNeed,
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Color(0xFF5F6F62),
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
