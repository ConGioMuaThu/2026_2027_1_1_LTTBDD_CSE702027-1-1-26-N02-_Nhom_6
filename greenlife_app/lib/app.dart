import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:greenlife_app/config/theme.dart';
import 'package:greenlife_app/l10n/app_localizations.dart';
import 'package:greenlife_app/screens/main_screen.dart';
import 'package:greenlife_app/screens/splash_screen.dart';

class GreenLifeApp extends StatefulWidget {
  const GreenLifeApp({super.key});

  @override
  State<GreenLifeApp> createState() => _GreenLifeAppState();
}

class _GreenLifeAppState extends State<GreenLifeApp> {
  Locale _locale = const Locale('vi');

  void _setLocale(Locale locale) {
    final supported = AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );

    if (!supported) return;

    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenLife',
      debugShowCheckedModeBanner: false,
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
