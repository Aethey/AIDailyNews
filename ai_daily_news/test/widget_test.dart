import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_daily_news/app/app.dart';
import 'package:ai_daily_news/features/news/data/catalog.dart';
import 'package:ai_daily_news/features/news/data/news_models.dart';
import 'package:ai_daily_news/features/news/presentation/news_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Today screen shows the current issue', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final issue = NewsIssue(
      date: '2026-09-12',
      layout: 'single_page_article',
      articles: [
        CatalogArticle(
          id: '20260912-agents-api',
          position: 0,
          feedDate: '2026-09-12',
          article: const Article(
            title: 'OpenAI 发布 Agents API',
            summary: 'Harness 开放为托管 API。',
            body: 'OpenAI 发布 Agents API。',
            sourceUrl: 'https://openai.com/index/introducing-the-agents-api/',
            estimatedReadMinutes: 1,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          issuesProvider.overrideWith((ref) async => [issue]),
        ],
        child: const AiDailyNewsApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('AI Morning Journal'), findsOneWidget);
    expect(find.text('Saturday, September 12'), findsOneWidget);
    expect(find.text('约 1 分钟'), findsOneWidget);
    expect(find.text('今日'), findsOneWidget);
    expect(find.text('书架'), findsOneWidget);
    expect(find.text('书签'), findsWidgets);
  });
}
