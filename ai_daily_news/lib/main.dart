import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/identity/installation_identity.dart';
import 'features/news/presentation/news_providers.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error, stackTrace) {
    debugPrint('Firebase init failed: $error\n$stackTrace');
  }

  final prefs = await SharedPreferences.getInstance();

  try {
    final installationId = await InstallationIdentity.ensure(prefs: prefs);
    await FirebaseAnalytics.instance.setUserId(id: installationId);
  } catch (error, stackTrace) {
    debugPrint('Identity init failed: $error\n$stackTrace');
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const AiDailyNewsApp(),
    ),
  );
}
