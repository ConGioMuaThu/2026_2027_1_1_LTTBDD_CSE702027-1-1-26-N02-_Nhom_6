import 'package:flutter/material.dart';
import 'package:greenlife_app/models/care_task.dart';
import 'package:greenlife_app/models/growth_note.dart';
export 'package:greenlife_app/data/care_tips_data.dart';
export 'package:greenlife_app/data/plant_data.dart';

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
      'contact': 'phong@gmail.com',
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