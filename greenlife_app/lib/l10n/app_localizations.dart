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
