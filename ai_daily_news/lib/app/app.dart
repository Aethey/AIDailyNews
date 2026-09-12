import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/paper_theme.dart';
import '../features/news/presentation/news_providers.dart';
import 'app_shell.dart';

class AiDailyNewsApp extends ConsumerWidget {
  const AiDailyNewsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(paperModeProvider);
    return MaterialApp(
      title: 'AI Morning Journal',
      debugShowCheckedModeBanner: false,
      theme: buildPaperTheme(mode),
      home: const AppShell(),
    );
  }
}
