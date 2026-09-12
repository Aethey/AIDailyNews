import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/dates.dart';
import '../../../core/theme/paper_theme.dart';
import '../../news/data/catalog.dart';
import '../../news/presentation/issue_cover.dart';
import '../../news/presentation/news_providers.dart';

class ShelfScreen extends ConsumerWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final issues = ref.watch(issuesProvider);
    final progress = ref.watch(issueProgressProvider);
    final paper = context.paper;

    return issues.when(
      loading: () => const Center(child: Text('書架を並べています')),
      error: (error, _) => Center(child: Text('$error')),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('号はまだありません'));
        }
        final date = parseIssueDate(items.first.date);
        return ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    monthTitle(items.first.date),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Text(
                  '${date.year}',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(fontSize: 12, letterSpacing: 1.4),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('読んだ朝が、一冊ずつ残る', style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 16),
            for (var i = 0; i < items.length; i += 4)
              _Ledge(
                issues: items.skip(i).take(4).toList(),
                progress: progress,
                paper: paper,
              ),
          ],
        );
      },
    );
  }
}

class _Ledge extends ConsumerWidget {
  const _Ledge({
    required this.issues,
    required this.progress,
    required this.paper,
  });

  final List<NewsIssue> issues;
  final Map<String, int> progress;
  final PaperColors paper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SizedBox(
        height: 154,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 9,
                decoration: BoxDecoration(
                  color: Color.lerp(paper.surface, paper.fg, 0.22),
                  border: Border(top: BorderSide(color: paper.border)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < issues.length; i++)
                    Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
                      child: _BookSpine(
                        issue: issues[i],
                        inkIndex: parseIssueDate(issues[i].date).day,
                        readState: issueReadState(issues[i], progress),
                        onTap: () => ref
                            .read(shellProvider.notifier)
                            .openReader(date: issues[i].date),
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
}

class _BookSpine extends StatelessWidget {
  const _BookSpine({
    required this.issue,
    required this.inkIndex,
    required this.readState,
    required this.onTap,
  });

  final NewsIssue issue;
  final int inkIndex;
  final IssueReadState readState;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final paper = context.paper;
    final day = parseIssueDate(issue.date).day.toString().padLeft(2, '0');
    final label = issue.articles.isEmpty
        ? 'AI'
        : issue.articles.first.article.title;
    final colors = _inkColors(paper, inkIndex % 4, readState);

    return Material(
      color: colors.background,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 96,
          height: 128,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(border: Border.all(color: colors.border)),
          child: Stack(
            children: [
              Positioned.fill(
                child: IssueCoverImage(assetPath: issue.coverAsset),
              ),
              Positioned.fill(
                child: ColoredBox(
                  color: colors.background.withValues(
                    alpha: issue.coverAsset == null ? 1 : 0.28,
                  ),
                ),
              ),
              if (readState == IssueReadState.done)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 3, color: colors.spine),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 8, 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.foreground,
                        fontSize: 13,
                        letterSpacing: 0.4,
                      ),
                    ),
                    Text(
                      'AI',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: colors.foreground,
                            fontSize: 20,
                            height: 0.88,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Container(
                        height: 1,
                        color: colors.foreground.withValues(alpha: 0.4),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.foreground,
                        fontSize: 8,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InkColors {
  const _InkColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.spine,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final Color spine;
}

_InkColors _inkColors(PaperColors paper, int ink, IssueReadState readState) {
  late Color background;
  late Color foreground;
  switch (ink) {
    case 0:
      background = Color.lerp(paper.surface, paper.accent, 0.20)!;
      foreground = paper.fg;
    case 1:
      background = Color.lerp(paper.fg, paper.accent, 0.26)!;
      foreground = paper.surface;
    case 2:
      background = Color.lerp(paper.surface, paper.fg, 0.24)!;
      foreground = paper.fg;
    default:
      background = paper.surface;
      foreground = paper.fg;
  }

  if (readState == IssueReadState.unread) {
    background = Color.lerp(paper.surface, paper.fg, 0.09)!;
    foreground = Color.lerp(paper.fg, paper.surface, 0.20)!;
  } else if (readState == IssueReadState.partial) {
    background = Color.lerp(background, paper.surface, 0.45)!;
    foreground = paper.fg;
  }

  return _InkColors(
    background: background,
    foreground: foreground,
    border: paper.border,
    spine: Color.lerp(paper.surface, paper.fg, 0.30)!,
  );
}
