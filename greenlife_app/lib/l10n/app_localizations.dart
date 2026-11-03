import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('vi'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _values = {
    'vi': {
      'greeting': 'Chào bạn,',
      'appName': 'GreenLife',
      'searchHint': 'Tìm cây, nhiệm vụ hoặc mẹo',
      'plantCareAssistant': 'Plant Care Assistant',
      'careMessage': 'Hôm nay là ngày tốt để chăm sóc cây của bạn.',
      'viewCareSchedule': 'Xem lịch chăm sóc',
      'initMessage': 'Khởi tạo vườn xanh cho bạn...',
      'language': 'Ngôn ngữ',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
      'home': 'Trang chủ',
      'library': 'Thư viện',
      'garden': 'Vườn',
      'care': 'Chăm sóc',
      'journal': 'Nhật ký',
      'tips': 'Mẹo',
      'about': 'Giới thiệu',
      'teamInfo': 'Thông tin nhóm',
      'teamDescription': 'Trợ lý chăm sóc cây xanh thông minh',
      'searchMembers': 'Tìm thành viên',
      'noMembersFound': 'Không tìm thấy thành viên nào.',
      'treeLibrary': 'Thư viện cây xanh',
      'searchTrees': 'Tìm cây theo tên hoặc mô tả',
      'noTreesFound': 'Không tìm thấy cây nào phù hợp.',
      'myGarden': 'Vườn cây của tôi',
      'addPlant': 'Thêm cây mới',
      'cancel': 'Hủy',
      'save': 'Lưu',
      'add': 'Thêm',
      'plantName': 'Tên cây',
      'plantType': 'Loại cây',
      'waterNeed': 'Nhu cầu nước',
      'searchGarden': 'Tìm cây trong vườn',
      'noGardenMatch': 'Không có cây nào phù hợp.',
      'careSchedule': 'Lịch chăm sóc',
      'thisWeek': 'Tuần này',
      'tasks': 'nhiệm vụ',
      'completed': 'Hoàn thành',
      'searchTasks': 'Tìm nhiệm vụ theo cây hoặc loại',
      'noTasksFound': 'Không tìm thấy nhiệm vụ nào.',
    },
    'en': {
      'greeting': 'Hello,',
      'appName': 'GreenLife',
      'searchHint': 'Search plants, tasks or tips',
      'plantCareAssistant': 'Plant Care Assistant',
      'careMessage': 'Today is a great day to care for your plants.',
      'viewCareSchedule': 'View care schedule',
      'initMessage': 'Growing your green space...',
      'language': 'Language',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
      'home': 'Home',
      'library': 'Library',
      'garden': 'Garden',
      'care': 'Care',
      'journal': 'Journal',
      'tips': 'Tips',
      'about': 'About',
      'teamInfo': 'Team information',
      'teamDescription': 'Smart plant care assistant',
      'searchMembers': 'Search members',
      'noMembersFound': 'No members found.',
      'treeLibrary': 'Plant library',
      'searchTrees': 'Search plants by name or description',
      'noTreesFound': 'No matching plants found.',
      'myGarden': 'My garden',
      'addPlant': 'Add new plant',
      'cancel': 'Cancel',
      'save': 'Save',
      'add': 'Add',
      'plantName': 'Plant name',
      'plantType': 'Plant type',
      'waterNeed': 'Water need',
      'searchGarden': 'Search plants in the garden',
      'noGardenMatch': 'No plants match your search.',
      'careSchedule': 'Care schedule',
      'thisWeek': 'This week',
      'tasks': 'tasks',
      'completed': 'Completed',
      'searchTasks': 'Search tasks by plant or type',
      'noTasksFound': 'No tasks found.',
    },
  };

  String get greeting => _val('greeting');
  String get appName => _val('appName');
  String get searchHint => _val('searchHint');
  String get plantCareAssistant => _val('plantCareAssistant');
  String get careMessage => _val('careMessage');
  String get viewCareSchedule => _val('viewCareSchedule');
  String get initMessage => _val('initMessage');
  String get language => _val('language');
  String get english => _val('english');
  String get vietnamese => _val('vietnamese');
  String get home => _val('home');
  String get library => _val('library');
  String get garden => _val('garden');
  String get care => _val('care');
  String get journal => _val('journal');
  String get tips => _val('tips');
  String get about => _val('about');
  String get teamInfo => _val('teamInfo');
  String get teamDescription => _val('teamDescription');
  String get searchMembers => _val('searchMembers');
  String get noMembersFound => _val('noMembersFound');
  String get treeLibrary => _val('treeLibrary');
  String get searchTrees => _val('searchTrees');
  String get noTreesFound => _val('noTreesFound');
  String get myGarden => _val('myGarden');
  String get addPlant => _val('addPlant');
  String get cancel => _val('cancel');
  String get save => _val('save');
  String get add => _val('add');
  String get plantName => _val('plantName');
  String get plantType => _val('plantType');
  String get waterNeed => _val('waterNeed');
  String get searchGarden => _val('searchGarden');
  String get noGardenMatch => _val('noGardenMatch');
  String get careSchedule => _val('careSchedule');
  String get thisWeek => _val('thisWeek');
  String get tasksLabel => _val('tasks');
  String get completed => _val('completed');
  String get searchTasks => _val('searchTasks');
  String get noTasksFound => _val('noTasksFound');

  String _val(String key) => _values[locale.languageCode]?[key] ?? _values['vi']![key]!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
