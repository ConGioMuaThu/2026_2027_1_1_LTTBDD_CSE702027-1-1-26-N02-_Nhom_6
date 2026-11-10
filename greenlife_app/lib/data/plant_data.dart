import 'package:flutter/material.dart';
import 'package:greenlife_app/models/plant.dart';
import 'package:greenlife_app/models/plant_category.dart';

List<PlantCategory> plantCategoriesFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

  return [
    PlantCategory(id: 'all', name: isEnglish ? 'All' : 'Tất cả', icon: '🌿'),
    PlantCategory(id: 'indoor', name: isEnglish ? 'Indoor' : 'Trong nhà', icon: '🏠'),
    PlantCategory(id: 'outdoor', name: isEnglish ? 'Outdoor' : 'Ngoài trời', icon: '🌤️'),
    PlantCategory(id: 'succulent', name: isEnglish ? 'Succulent' : 'Xương rồng', icon: '🌵'),
    PlantCategory(id: 'flower', name: isEnglish ? 'Flower' : 'Hoa', icon: '🌼'),
  ];
}

String _categoryName(Locale locale, String id) {
  return plantCategoriesFor(locale).firstWhere((category) => category.id == id).name;
}

List<Plant> samplePlantsFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

  return [
    Plant(
      id: 'plant-1',
      name: isEnglish ? 'Pothos' : 'Trầu bà',
      scientificName: 'Epipremnum aureum',
      category: _categoryName(locale, 'indoor'),
      description: isEnglish
          ? 'Easy-care climbing plant perfect for living and work spaces.'
          : 'Cây thân leo dễ chăm sóc, thích hợp cho không gian sống và làm việc.',
      careLevel: isEnglish ? 'Easy' : 'Dễ',
      waterNeed: isEnglish ? '2-3 times/week' : '2-3 lần/tuần',
      sunlight: isEnglish ? 'Indirect light' : 'Ánh sáng gián tiếp',
      imageAsset: '🌿',
      imageUrl: 'assets/images/plants/plant-1.jpg',
      isFavorite: true,
      tags: isEnglish ? ['airy', 'odor removal', 'revitalizing'] : ['thoáng', 'khử mùi', 'trẻ hóa'],
    ),
    Plant(
      id: 'plant-2',
      name: isEnglish ? 'Rose' : 'Hoa hồng',
      scientificName: 'Rosa hybrida',
      category: _categoryName(locale, 'flower'),
      description: isEnglish
          ? 'Vibrant blossoms that bring charm to balconies and small gardens.'
          : 'Hoa nở rực rỡ, mang lại vẻ đẹp cho ban công và vườn nhỏ.',
      careLevel: isEnglish ? 'Moderate' : 'Trung bình',
      waterNeed: isEnglish ? '3-4 times/week' : '3-4 lần/tuần',
      sunlight: isEnglish ? '4-6 hours of sun' : 'Nắng 4-6 giờ',
      imageAsset: '🌹',
      imageUrl: 'assets/images/plants/plant-2.jpg',
      tags: isEnglish ? ['fragrant', 'sunny', 'colorful'] : ['thơm', 'nắng', 'sắc màu'],
    ),
    Plant(
      id: 'plant-3',
      name: isEnglish ? 'Echeveria' : 'Sen đá',
      scientificName: 'Echeveria',
      category: _categoryName(locale, 'succulent'),
      description: isEnglish
          ? 'Thrives in dry conditions and is ideal for desks and compact spaces.'
          : 'Thích môi trường khô ráo và rất phù hợp cho bàn làm việc.',
      careLevel: isEnglish ? 'Easy' : 'Dễ',
      waterNeed: isEnglish ? '1-2 times/month' : '1-2 lần/tháng',
      sunlight: isEnglish ? 'Direct sun' : 'Nắng trực tiếp',
      imageAsset: '🌵',
      imageUrl: 'assets/images/plants/plant-3.jpg',
      tags: isEnglish ? ['cool', 'low water', 'desk plant'] : ['mát', 'ít nước', 'bàn làm việc'],
    ),
    Plant(
      id: 'plant-4',
      name: isEnglish ? 'Snake plant' : 'Lưỡi hổ',
      scientificName: 'Sansevieria trifasciata',
      category: _categoryName(locale, 'indoor'),
      description: isEnglish
          ? 'Drought-tolerant and perfect for adding calm, fresh green to compact spaces.'
          : 'Cây chịu hạn tốt, giúp không gian thêm xanh và thanh bình.',
      careLevel: isEnglish ? 'Easy' : 'Dễ',
      waterNeed: isEnglish ? 'Every 2 weeks' : 'Mỗi 2 tuần',
      sunlight: isEnglish ? 'Soft light' : 'Ánh sáng mềm',
      imageAsset: '🌱',
      imageUrl: 'assets/images/plants/plant-4.jpg',
      isFavorite: true,
      tags: isEnglish ? ['resilient', 'small spaces'] : ['bền bỉ', 'không gian nhỏ'],
    ),
    Plant(
      id: 'plant-5',
      name: isEnglish ? 'Lavender' : 'Oải hương',
      scientificName: 'Lavandula angustifolia',
      category: _categoryName(locale, 'flower'),
      description: isEnglish
          ? 'Fragrant purple flowers that attract pollinators and help you relax.'
          : 'Hoa tím thơm dịu, thu hút ong bướm và giúp thư giãn.',
      careLevel: isEnglish ? 'Moderate' : 'Trung bình',
      waterNeed: isEnglish ? '1-2 times/week' : '1-2 lần/tuần',
      sunlight: isEnglish ? 'Full sun' : 'Nắng nhiều',
      imageAsset: '💜',
      imageUrl: 'assets/images/plants/plant-5.jpg',
      tags: isEnglish ? ['fragrant', 'purple', 'sunny'] : ['thơm', 'màu tím', 'nắng'],
    ),
    Plant(
      id: 'plant-6',
      name: isEnglish ? 'Orchid' : 'Lan hồ điệp',
      scientificName: 'Phalaenopsis',
      category: _categoryName(locale, 'flower'),
      description: isEnglish
          ? 'Elegant, long-lasting blooms that suit bright indoor spots.'
          : 'Hoa thanh lịch, bền lâu, hợp góc nhà nhiều ánh sáng.',
      careLevel: isEnglish ? 'Moderate' : 'Trung bình',
      waterNeed: isEnglish ? 'Once a week' : 'Mỗi tuần một lần',
      sunlight: isEnglish ? 'Bright indirect light' : 'Ánh sáng gián tiếp mạnh',
      imageAsset: '🌸',
      imageUrl: 'assets/images/plants/plant-6.jpg',
      tags: isEnglish ? ['elegant', 'long-lasting', 'indoor'] : ['thanh lịch', 'bền lâu', 'trong nhà'],
    ),
    Plant(
      id: 'plant-7',
      name: isEnglish ? 'Basil' : 'Húng quế',
      scientificName: 'Ocimum basilicum',
      category: _categoryName(locale, 'outdoor'),
      description: isEnglish
          ? 'Aromatic herb that grows quickly and is great for cooking.'
          : 'Rau thơm mọc nhanh, tỏa hương và rất hợp nấu ăn.',
      careLevel: isEnglish ? 'Easy' : 'Dễ',
      waterNeed: isEnglish ? '3-4 times/week' : '3-4 lần/tuần',
      sunlight: isEnglish ? '6 hours of sun' : 'Nắng 6 giờ',
      imageAsset: '🌿',
      imageUrl: 'assets/images/plants/plant-7.jpg',
      tags: isEnglish ? ['edible', 'aromatic', 'fast-growing'] : ['ăn được', 'thơm', 'mọc nhanh'],
    ),
    Plant(
      id: 'plant-8',
      name: isEnglish ? 'Mint' : 'Bạc hà',
      scientificName: 'Mentha spicata',
      category: _categoryName(locale, 'outdoor'),
      description: isEnglish
          ? 'Refreshing herb that spreads quickly in pots and small gardens.'
          : 'Rau thơm mát, lan nhanh trong chậu và vườn nhỏ.',
      careLevel: isEnglish ? 'Easy' : 'Dễ',
      waterNeed: isEnglish ? 'Every 2 days' : 'Mỗi 2 ngày',
      sunlight: isEnglish ? 'Partial sun' : 'Nắng một phần',
      imageAsset: '🍃',
      imageUrl: 'assets/images/plants/plant-8.jpg',
      tags: isEnglish ? ['refreshing', 'edible', 'spreads'] : ['mát', 'ăn được', 'lan nhanh'],
    ),
    Plant(
      id: 'plant-9',
      name: isEnglish ? 'Bunny ear cactus' : 'Xương rồng tai thỏ',
      scientificName: 'Opuntia microdasys',
      category: _categoryName(locale, 'succulent'),
      description: isEnglish
          ? 'Soft-looking pads that store water and need very little care.'
          : 'Thân dẹt trông mềm mại, trữ nước tốt và rất ít cần chăm sóc.',
      careLevel: isEnglish ? 'Easy' : 'Dễ',
      waterNeed: isEnglish ? '1-2 times/month' : '1-2 lần/tháng',
      sunlight: isEnglish ? 'Direct sun' : 'Nắng trực tiếp',
      imageAsset: '🌵',
      imageUrl: 'assets/images/plants/plant-9.png',
      tags: isEnglish ? ['low water', 'decorative', 'sun lover'] : ['ít nước', 'trang trí', 'ưa nắng'],
    ),
  ];
}