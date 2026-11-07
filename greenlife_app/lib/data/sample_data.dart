import 'package:flutter/material.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/growth_note.dart';
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

List<Plant> samplePlantsFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

  return [
    Plant(
      id: 'plant-1',
      name: isEnglish ? 'Pothos' : 'Trầu bà',
      scientificName: 'Epipremnum aureum',
      category: isEnglish ? 'Indoor' : 'Trong nhà',
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
      category: isEnglish ? 'Outdoor' : 'Ngoài trời',
      description: isEnglish
          ? 'Vibrant blossoms that bring charm to balconies and small gardens.'
          : 'Hoa nở rực rỡ, mang lại vẻ đẹp cho ban công và vườn nhỏ.',
      careLevel: isEnglish ? 'Moderate' : 'Trung bình',
      waterNeed: isEnglish ? '3-4 times/week' : '3-4 lần/tuần',
      sunlight: isEnglish ? '4-6 hours of sun' : 'Nắng 4-6 giờ',
      imageAsset: '🌹',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-tkmIUiq52skDWCnjjZbJxf6R78DvX5-5utL2PUWzgHDQBWGBMbIe6nc_&s=10',
      tags: isEnglish ? ['fragrant', 'sunny', 'colorful'] : ['quả', 'nắng', 'sắc màu'],
    ),
    Plant(
      id: 'plant-3',
      name: isEnglish ? 'Echeveria' : 'Sen đá',
      scientificName: 'Echeveria',
      category: isEnglish ? 'Succulent' : 'Xương rồng',
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
      category: isEnglish ? 'Indoor' : 'Trong nhà',
      description: isEnglish
          ? 'Drought-tolerant and perfect for adding calm, fresh green to compact spaces.'
          : 'Cây chịu hạn tốt, giúp không gian thêm xanh và thanh bình.',
      careLevel: isEnglish ? 'Easy' : 'Dễ',
      waterNeed: isEnglish ? 'Every 2 weeks' : 'Mỗi 2 tuần',
      sunlight: isEnglish ? 'Soft light' : 'Ánh sáng mềm',
      imageAsset: '🌱',
      imageUrl:
          'https://lomonoxop.edu.vn/images/ckeditor/images/lomonoxop/cay%20luoi%20ho.png',
      isFavorite: true,
      tags: isEnglish ? ['resilient', 'small spaces'] : ['bền bỉ', 'không gian nhỏ'],
    ),
  ];
}

List<CareTask> sampleTasksFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

  return [
    CareTask(
      id: 'task-1',
      title: isEnglish ? 'Watering' : 'Tưới nước',
      plantName: isEnglish ? 'Pothos' : 'Trầu bà',
      type: 'watering',
      dueDate: isEnglish ? 'Today, 08:00' : 'Hôm nay, 08:00',
      isCompleted: false,
    ),
    CareTask(
      id: 'task-2',
      title: isEnglish ? 'Fertilize' : 'Bón phân',
      plantName: isEnglish ? 'Rose' : 'Hoa hồng',
      type: 'fertilize',
      dueDate: isEnglish ? 'Tomorrow, 15:30' : 'Ngày mai, 15:30',
    ),
    CareTask(
      id: 'task-3',
      title: isEnglish ? 'Check leaves' : 'Kiểm tra lá',
      plantName: isEnglish ? 'Snake plant' : 'Lưỡi hổ',
      type: 'inspection',
      dueDate: isEnglish ? 'Wednesday, 10:00' : 'Thứ Tư, 10:00',
      isCompleted: true,
    ),
    CareTask(
      id: 'task-4',
      title: isEnglish ? 'Prune stems' : 'Tỉa cành',
      plantName: isEnglish ? 'Echeveria' : 'Sen đá',
      type: 'prune',
      dueDate: isEnglish ? 'Thursday, 17:00' : 'Thứ Năm, 17:00',
    ),
  ];
}

List<GrowthNote> sampleNotesFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

  return [
    GrowthNote(
      id: 'note-1',
      plantName: isEnglish ? 'Pothos' : 'Trầu bà',
      title: isEnglish ? 'New leaves unfurled' : 'Lá mới bung ra',
      date: '18/10/2026',
      summary: isEnglish
          ? 'The plant grew strongly after a week of proper watering; the new leaves are darker and more vibrant.'
          : 'Cây phát triển mạnh sau 1 tuần chăm sóc đúng lịch tưới, lá mới có màu xanh đậm hơn.',
    ),
    GrowthNote(
      id: 'note-2',
      plantName: isEnglish ? 'Rose' : 'Hoa hồng',
      title: isEnglish ? 'First flower bud' : 'Nụ hoa đầu tiên',
      date: '12/10/2026',
      summary: isEnglish
          ? 'Excited to observe a new bud opening; more light and balanced moisture are needed.'
          : 'Hào hứng quan sát nụ mới mở, cần tăng cường ánh sáng và giữ độ ẩm vừa phải.',
    ),
    GrowthNote(
      id: 'note-3',
      plantName: isEnglish ? 'Snake plant' : 'Lưỡi hổ',
      title: isEnglish ? 'Plant is stable' : 'Cây ổn định',
      date: '08/10/2026',
      summary: isEnglish
          ? 'Leaves are evenly green with no signs of wilting; continue routine checks to maintain health.'
          : 'Màu xanh đều, không dấu hiệu úa lá; thực hiện kiểm tra định kỳ để duy trì sức khỏe.',
    ),
  ];
}

List<Map<String, String>> greenTipsFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

  return [
    {
      'title': isEnglish ? 'Water correctly' : 'Tưới nước đúng cách',
      'content': isEnglish
          ? 'Check soil moisture before watering to prevent root rot. Water evenly and avoid prolonged waterlogging.'
          : 'Để tránh úng rễ, hãy kiểm tra độ ẩm đất trước khi tưới. Nước nên được hấp thu đều và không ngập lâu.',
    },
    {
      'title': isEnglish ? 'Choose suitable soil' : 'Chọn đất phù hợp',
      'content': isEnglish
          ? 'Use loose, well-draining soil with good aeration and organic compost to keep plants healthy.'
          : 'Hỗn hợp đất tơi xốp, thoát nước tốt và có thể bổ sung phân hữu cơ để cây phát triển khỏe mạnh.',
    },
    {
      'title': isEnglish ? 'Indoor nutrition' : 'Dinh dưỡng trong nhà',
      'content': isEnglish
          ? 'Place indoor plants in indirect light and keep them away from fans, heaters, and direct drafts.'
          : 'Cây trong nhà nên được đặt nơi có ánh sáng gián tiếp và tránh xa quạt gió, máy sưởi trực tiếp.',
    },
  ];
}

List<Map<String, String>> projectTeamFor(Locale locale) {
  final isEnglish = locale.languageCode == 'en';

   return [
    {
      'name': 'Trịnh Xuân Hồng Phong',
      'role': 'Leader / Product Owner',
      'focus': isEnglish
          ? 'Project timeline management'
          : 'Quản lý tiến độ dự án',
      'bio': isEnglish
          ? 'Leads the product direction, coordinates the roadmap, and ensures the app stays aligned with user goals and real-world care routines.'
          : 'Dẫn dắt hướng đi sản phẩm, điều phối lộ trình và đảm bảo ứng dụng luôn phù hợp với nhu cầu người dùng và thói quen chăm sóc thực tế.',
      'experience': isEnglish
          ? 'Experienced in product management and mobile application development'
          : 'Có kinh nghiệm trong quản lý sản phẩm và triển khai ứng dụng di động',
      'specialty': isEnglish
          ? 'Roadmap planning, feature prioritization, stakeholder communication'
          : 'Lập kế hoạch lộ trình, ưu tiên tính năng, giao tiếp với bên liên quan',
      'contact': 'phong@gmai.com',
    },
    {
      'name': 'Nguyễn Huy Kiên',
      'role': 'UI/UX Designer',
      'focus': isEnglish
          ? 'User experience design'
          : 'Thiết kế trải nghiệm người dùng',
      'bio': isEnglish
          ? 'Transforms complex plant-care workflows into friendly interactions with clean visual systems and intuitive user journeys.'
          : 'Biến quy trình chăm sóc cây phức tạp thành trải nghiệm thân thiện nhờ hệ thống giao diện rõ ràng và hành trình người dùng dễ hiểu.',
      'experience': isEnglish
          ? 'Experienced in UI/UX design for mobile products'
          : 'Có kinh nghiệm trong thiết kế UI/UX cho sản phẩm di động',
      'specialty': isEnglish
          ? 'Interaction design, design systems, mobile interface prototyping'
          : 'Thiết kế tương tác, hệ thống thiết kế, nguyên mẫu giao diện di động',
      'contact': 'kien@gmail.com',
    },
  ];
}
