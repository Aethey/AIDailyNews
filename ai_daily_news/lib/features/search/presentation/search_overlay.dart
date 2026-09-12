import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/paper_theme.dart';
import '../../news/data/catalog.dart';
import '../../news/presentation/news_providers.dart';

class SearchOverlay extends ConsumerStatefulWidget {
  const SearchOverlay({super.key});

  @override
  ConsumerState<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends ConsumerState<SearchOverlay> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paper = context.paper;
    final issues = ref.watch(issuesProvider).value ?? const <NewsIssue>[];
    final hits = _search(issues, _query);

    return ColoredBox(
      color: paper.bg,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontSize: 22),
              cursorColor: paper.accent,
              decoration: InputDecoration(
                hintText: '号のなかを探す',
                hintStyle: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontSize: 22, color: paper.muted),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: paper.fg),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: paper.fg),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: paper.accent, width: 2),
                ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  for (final hit in hits)
                    InkWell(
                      onTap: () => ref
                          .read(shellProvider.notifier)
                          .openReader(
                            date: hit.feedDate,
                            pageIndex: hit.position,
                            openedFromFeed: false,
                          ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: paper.border),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hit.article.title,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${hit.sourceHost}  ·  ${hit.feedDate}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CatalogArticle> _search(List<NewsIssue> issues, String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return const [];
    final results = <CatalogArticle>[];
    for (final issue in issues) {
      for (final article in issue.articles) {
        final haystack = [
          article.article.title,
          article.article.summary,
          article.sourceHost,
        ].join(' ').toLowerCase();
        if (haystack.contains(needle)) {
          results.add(article);
        }
      }
    }
    return results;
  }
}
