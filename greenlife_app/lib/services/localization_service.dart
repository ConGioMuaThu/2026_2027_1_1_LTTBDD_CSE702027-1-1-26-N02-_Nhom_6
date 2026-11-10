import 'dart:ui';
import 'package:greenlife_app/config/app_config.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/services/storage_service.dart';

class LocalizationService {
  LocalizationService._();

  static final LocalizationService instance = LocalizationService._();

  static const Locale vietnamese = Locale('vi');
  static const Locale english = Locale('en');
  static const Locale defaultLocale = AppConfig.defaultLocale;

  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  Locale fromCode(String? code) {
    if (code == null) return defaultLocale;
    final locale = Locale(code);
    return isSupported(locale) ? locale : defaultLocale;
  }

  Locale deviceLocale() {
    final device = PlatformDispatcher.instance.locale;
    return isSupported(device) ? Locale(device.languageCode) : defaultLocale;
  }

  Future<Locale> loadLocale() async {
    final code = await StorageService.instance.loadLocaleCode();
    if (code == null) return deviceLocale();
    return fromCode(code);
  }

  Future<void> saveLocale(Locale locale) {
    return StorageService.instance.saveLocaleCode(locale.languageCode);
  }

  Locale toggle(Locale current) {
    return current.languageCode == vietnamese.languageCode ? english : vietnamese;
  }
}