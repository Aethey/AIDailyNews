import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/dates.dart';
import '../../../core/theme/paper_theme.dart';
import '../data/catalog.dart';
import 'issue_cover.dart';
import 'news_providers.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(latestIssueProvider);
    return latest.when(
      loading: () => const _StatusPane(label: '纸面准备中'),
      error: (error, _) => _StatusPane(label: '今日号无法打开', detail: '$error'),
      data: (issue) {
        if (issue == null) {
          return const _StatusPane(label: '今日号还没有到');
        }
        return _TodayCover(issue: issue);
      },
    );
  }
}

class _TodayCover extends ConsumerWidget {
  const _TodayCover({required this.issue});

  final NewsIssue issue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paper = context.paper;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Material(
        color: paper.surface,
        child: InkWell(
          onTap: () =>
              ref.read(shellProvider.notifier).openReader(date: issue.date),
          child: SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: paper.border),
                boxShadow: [
                  BoxShadow(
                    color: paper.fg.withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  IssueCoverImage(assetPath: issue.coverAsset),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          paper.bg.withValues(alpha: 0.72),
                          paper.bg.withValues(alpha: 0.08),
                          paper.bg.withValues(alpha: 0.82),
                        ],
                        stops: const [0, 0.42, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 18,
                    right: 20,
                    child: Text(
                      deskDateLabel(issue.date),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            '约 ${issue.totalReadMinutes} 分钟',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontSize: 11, letterSpacing: 1.2),
                          ),
                        ),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: paper.fg,
                            border: Border.all(color: paper.fg),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: paper.surface,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPane extends StatelessWidget {
  const _StatusPane({required this.label, this.detail});

  final String label;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: Theme.of(context).textTheme.headlineSmall),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(
                detail!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
