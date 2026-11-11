import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenlife_app/data/sample_data.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/providers/plant_provider.dart';
import 'package:greenlife_app/repositories/plant_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Plant _testPlant({String id = 'custom-plant', String name = 'Cây thử nghiệm'}) {
  return Plant(
    id: id,
    name: name,
    scientificName: 'Testus plantus',
    category: 'Indoor',
    description: 'A plant used in tests.',
    careLevel: 'Easy',
    waterNeed: 'Weekly',
    sunlight: 'Indirect light',
    imageAsset: '',
    tags: const ['test'],
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PlantRepository', () {
    final repository = PlantRepository();

    test('findById returns the matching plant', () {
      final plant = _testPlant();

      expect(repository.findById([plant], plant.id), same(plant));
      expect(repository.findById([plant], 'missing'), isNull);
    });

    test('copyWith renames a plant and preserves its id', () {
      final plant = _testPlant();

      final renamed = repository.copyWith(plant, name: 'Cây mới');

      expect(renamed.name, 'Cây mới');
      expect(renamed.id, plant.id);
      expect(renamed.scientificName, plant.scientificName);
    });
  });

  group('Plant catalog detection', () {
    test('catalogIds matches the ids in samplePlantsFor', () {
      for (final locale in const [Locale('vi'), Locale('en')]) {
        final ids = samplePlantsFor(locale).map((p) => p.id).toSet();
        expect(ids, Plant.catalogIds);
      }
    });

    test('isCatalog is true for every catalog plant', () {
      for (final plant in samplePlantsFor(const Locale('vi'))) {
        expect(plant.isCatalog, isTrue, reason: plant.id);
      }
    });

    test('isCatalog is false for user plants, including plant-10', () {
      expect(_testPlant(id: 'plant-10').isCatalog, isFalse);
      expect(_testPlant(id: 'plant-1731000000000').isCatalog, isFalse);
      expect(_testPlant(id: 'custom-plant').isCatalog, isFalse);
    });

    test('removeFromGarden keeps a catalog plant but deletes a user plant', () {
      final provider = PlantProvider(locale: const Locale('vi'));
      addTearDown(provider.dispose);

      provider.removeFromGarden('plant-1');
      expect(provider.findById('plant-1')?.inGarden, isFalse);

      provider.add(_testPlant(id: 'plant-10'));
      provider.removeFromGarden('plant-10');
      expect(provider.findById('plant-10'), isNull);
    });
  });

  group('PlantProvider', () {
    late PlantProvider provider;

    setUp(() {
      provider = PlantProvider(locale: const Locale('vi'));
    });

    tearDown(() {
      provider.dispose();
    });

    test('add inserts a plant into the collection', () {
      final plant = _testPlant();

      provider.add(plant);

      expect(provider.findById(plant.id), isNotNull);
      expect(provider.plantNames, contains(plant.name));
    });

    test('remove deletes a custom plant', () {
      final plant = _testPlant();
      provider.add(plant);

      provider.remove(plant.id);

      expect(provider.findById(plant.id), isNull);
    });

    test('update changes a plant name', () {
      final plant = _testPlant();
      provider.add(plant);
      final renamed = Plant(
        id: plant.id,
        name: 'Cây đã đổi tên',
        scientificName: plant.scientificName,
        category: plant.category,
        description: plant.description,
        careLevel: plant.careLevel,
        waterNeed: plant.waterNeed,
        sunlight: plant.sunlight,
        imageAsset: plant.imageAsset,
        imageUrl: plant.imageUrl,
        isFavorite: plant.isFavorite,
        inGarden: plant.inGarden,
        plantedDate: plant.plantedDate,
        careNotes: plant.careNotes,
        tags: plant.tags,
      );

      provider.update(renamed);

      expect(provider.findById(plant.id)?.name, 'Cây đã đổi tên');
    });
  });
}