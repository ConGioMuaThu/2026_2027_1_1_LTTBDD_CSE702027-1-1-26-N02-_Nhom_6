import 'package:flutter/material.dart';
import 'package:greenlife_app/app.dart';
import 'package:greenlife_app/services/localization_service.dart';
import 'package:greenlife_app/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locale = await LocalizationService.instance.loadLocale();
  await NotificationService.instance.init();
  runApp(GreenLifeApp(initialLocale: locale));
}