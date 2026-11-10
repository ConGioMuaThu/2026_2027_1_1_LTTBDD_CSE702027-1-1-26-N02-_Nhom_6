import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:greenlife_app/config/app_config.dart';
import 'package:greenlife_app/config/theme.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/screens/main_screen.dart';
import 'package:greenlife_app/screens/splash_screen.dart';
import 'package:greenlife_app/services/localization_service.dart';

class GreenLifeApp extends StatefulWidget {
  const GreenLifeApp({super.key, this.initialLocale = AppConfig.defaultLocale});

  final Locale initialLocale;

  @override
  State<GreenLifeApp> createState() => _GreenLifeAppState();
}

class _GreenLifeAppState extends State<GreenLifeApp> {
  late Locale _locale = widget.initialLocale;

  void _setLocale(Locale locale) {
    if (!LocalizationService.instance.isSupported(locale)) return;

    setState(() {
      _locale = locale;
    });
    LocalizationService.instance.saveLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: AppConfig.showDebugBanner,
      theme: AppTheme.lightTheme,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: GreenLifeSplash(
        home: MainScreen(
          locale: _locale,
          onLocaleChanged: _setLocale,
        ),
      ),
    );
  }
}