import 'package:flutter/material.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/screens/plant_library/plant_detail_screen.dart';
import 'package:greenlife_app/widgets/plant_card.dart';

class PlantLibraryScreen extends StatefulWidget {
  final List<Plant> plants;
  final void Function(String plantId)? onToggleFavorite;
  final void Function(CareTask task)? onAddTask;

  const PlantLibraryScreen({
    super.key,
    this.plants = const [],
    this.onToggleFavorite,
    this.onAddTask,
  });

  @override
  State<PlantLibraryScreen> createState() => _PlantLibraryScreenState();
}

class _PlantLibraryScreenState extends State<PlantLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryId = 'all';
  String? _selectedPlantId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Plant> get _displayPlants {
    final locale = Localizations.localeOf(context);
    final source = widget.plants.isEmpty ? samplePlantsFor(locale) : widget.plants;
    final categories = plantCategoriesFor(locale);
    final query = _searchController.text.trim().toLowerCase();

    return source.where((plant) {
      final matchesCategory = _selectedCategoryId == 'all' ||
          plant.category.toLowerCase() ==
              categories
                  .firstWhere((category) => category.id == _selectedCategoryId,
                      orElse: () => categories.first)
                  .name
                  .toLowerCase();

      final matchesSearch = query.isEmpty ||
          plant.name.toLowerCase().contains(query) ||
          plant.scientificName.toLowerCase().contains(query) ||
          plant.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final categories = plantCategoriesFor(locale);
    final displayPlants = _displayPlants;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.plantLibraryTitle,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: strings.searchPlants,
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
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategoryId == category.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = category.id;
                        _selectedPlantId = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2F6A4F) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(
                            category.icon,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF2A382D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: displayPlants.isEmpty
                  ? Center(
                      child: Text(strings.noPlantsFound),
                    )
                  : GridView.builder(
                      itemCount: displayPlants.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final plant = displayPlants[index];
                        return PlantCard(
                          plant: plant,
                          isSelected: _selectedPlantId == plant.id,
                          onTap: () {
                            setState(() => _selectedPlantId = plant.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlantDetailScreen(
                                  plant: plant,
                                  onToggleFavorite: widget.onToggleFavorite == null
                                      ? null
                                      : () => widget.onToggleFavorite!(plant.id),
                                  onAddTask: widget.onAddTask,
                                  plantNames: widget.plants.isEmpty
                                      ? null
                                      : widget.plants.map((p) => p.name).toList(),
                                ),
                              ),
                            );
                          },
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