import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/paper_theme.dart';
import '../../news/data/catalog.dart';
import '../../news/presentation/news_providers.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paper = context.paper;
    final records = ref.watch(bookmarksProvider);
    final issues = ref.watch(issuesProvider);

    return issues.when(
      loading: () => const Center(child: Text('栞を開いています')),
      error: (error, _) => Center(child: Text('$error')),
      data: (loaded) {
        final articles = <CatalogArticle>[];
        for (final record in records) {
          final match = findArticle(loaded, record.articleId);
          if (match != null) articles.add(match);
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
          children: [
            Text(
              'BOOKMARKS',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: paper.accent, letterSpacing: 1.6),
            ),
            const SizedBox(height: 8),
            Text('书签', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 6),
            Text('印をつけた記事', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 16),
            if (articles.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  'まだ栞はありません',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            else
              for (final article in articles)
                InkWell(
                  onTap: () => ref
                      .read(shellProvider.notifier)
                      .openReader(
                        date: article.feedDate,
                        pageIndex: article.position,
                        openedFromFeed: false,
                      ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: paper.border)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.article.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            article.article.summary,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${article.sourceHost}  ·  ${article.feedDate}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}
