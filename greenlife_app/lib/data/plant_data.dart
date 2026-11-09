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
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTU9LqG7eM6uHTSyZ4vDjji5fnzOKM-mRRoP7XFrqzkmWN2CAO_Wd2zwNus&s=10',
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
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-tkmIUiq52skDWCnjjZbJxf6R78DvX5-5utL2PUWzgHDQBWGBMbIe6nc_&s=10',
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
      imageUrl:
          'https://cdn.eva.vn/upload/3-2022/images/2022-07-15/image13-1657867526-681-width1080height1007.jpg',
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
      imageUrl:
          'https://monhasfarm.com/wp-content/uploads/2025/03/8cb4490a502648609bd49542e68eafe8tplv-o3syd03w52-origin-jpeg-600x600.jpeg',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNkZGIhL-F2ZUOxYEEmKeZJrrsiEtVOe3W9RE6tGGcAg&s=10',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSa5J-k_-OTWEZMuxSohg24SvaeOk09jBJ5PHBeBqgESA&s=10',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_3QtxwGGcwewQXmiXKy6s4YHLY5FMre5zvYEOU0HhNQ&s=10',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8YLdiGFhAVrQjnKH6xiBkT02URauqJbCw0lmnu7EScQ&s=10',
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
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRuhYqK0M7mhan8UZJYfs9wFaQRYJuLEZaWMaQpCXIySg&s=10',
      tags: isEnglish ? ['low water', 'decorative', 'sun lover'] : ['ít nước', 'trang trí', 'ưa nắng'],
    ),
  ];
}