import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/paper_theme.dart';
import '../features/bookmarks/presentation/bookmarks_screen.dart';
import '../features/news/data/catalog.dart';
import '../features/news/presentation/news_providers.dart';
import '../features/news/presentation/today_screen.dart';
import '../features/reader/presentation/reader_screen.dart';
import '../features/search/presentation/search_overlay.dart';
import '../features/shelf/presentation/shelf_screen.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paper = context.paper;
    final shell = ref.watch(shellProvider);
    final mode = ref.watch(paperModeProvider);
    final issues = ref.watch(issuesProvider).value ?? const <NewsIssue>[];
    final readerIssue = shell.reader == null
        ? null
        : _issueByDate(issues, shell.reader!.date);

    return Scaffold(
      backgroundColor: paper.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _Masthead(
                  paper: paper,
                  mode: mode,
                  searchOpen: shell.searchOpen,
                  onSearch: () =>
                      ref.read(shellProvider.notifier).toggleSearch(),
                  onBookmarks: () => ref
                      .read(shellProvider.notifier)
                      .selectTab(AppTab.bookmarks),
                  onTogglePaper: () =>
                      ref.read(paperModeProvider.notifier).toggle(),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(child: _tabBody(shell.tab)),
                      if (shell.searchOpen && shell.reader == null)
                        const Positioned.fill(child: SearchOverlay()),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: paper.border)),
                  ),
                  child: Row(
                    children: [
                      _TabButton(
                        label: '今日',
                        selected: shell.tab == AppTab.today,
                        onTap: () => ref
                            .read(shellProvider.notifier)
                            .selectTab(AppTab.today),
                      ),
                      _TabButton(
                        label: '书架',
                        selected: shell.tab == AppTab.shelf,
                        onTap: () => ref
                            .read(shellProvider.notifier)
                            .selectTab(AppTab.shelf),
                      ),
                      _TabButton(
                        label: '书签',
                        selected: shell.tab == AppTab.bookmarks,
                        onTap: () => ref
                            .read(shellProvider.notifier)
                            .selectTab(AppTab.bookmarks),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: _ReaderOverlay(
                session: shell.reader,
                issue: readerIssue,
                background: paper.bg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBody(AppTab tab) {
    switch (tab) {
      case AppTab.today:
        return const TodayScreen();
      case AppTab.shelf:
        return const ShelfScreen();
      case AppTab.bookmarks:
        return const BookmarksScreen();
    }
  }

  NewsIssue? _issueByDate(List<NewsIssue> issues, String date) {
    for (final issue in issues) {
      if (issue.date == date) return issue;
    }
    return null;
  }
}

class _ReaderOverlay extends StatelessWidget {
  const _ReaderOverlay({
    required this.session,
    required this.issue,
    required this.background,
  });

  final ReaderSession? session;
  final NewsIssue? issue;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (session == null) {
      child = const SizedBox.expand(key: ValueKey('reader-closed'));
    } else if (issue == null) {
      child = ColoredBox(
        key: ValueKey('reader-missing-${session!.date}'),
        color: background,
        child: const Center(child: Text('这一号找不到了')),
      );
    } else {
      child = ColoredBox(
        key: ValueKey('reader-${session!.date}-${session!.initialPage}'),
        color: background,
        child: ReaderScreen(session: session!, issue: issue!),
      );
    }

    return IgnorePointer(
      ignoring: session == null,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        reverseDuration: const Duration(milliseconds: 280),
        switchInCurve: const Cubic(0.22, 1, 0.36, 1),
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (current, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.985, end: 1).animate(animation),
              alignment: Alignment.center,
              child: current,
            ),
          );
        },
        child: child,
      ),
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead({
    required this.paper,
    required this.mode,
    required this.searchOpen,
    required this.onSearch,
    required this.onBookmarks,
    required this.onTogglePaper,
  });

  final PaperColors paper;
  final PaperMode mode;
  final bool searchOpen;
  final VoidCallback onSearch;
  final VoidCallback onBookmarks;
  final VoidCallback onTogglePaper;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                'AI Morning Journal',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: paper.fg,
                  fontSize: 9,
                  letterSpacing: 1.8,
                ),
              ),
            ),
            const Spacer(),
            _ToolButton(
              label: mode == PaperMode.morning ? '朝' : '夜',
              onTap: onTogglePaper,
            ),
            _ToolButton(label: searchOpen ? '关闭' : '搜索', onTap: onSearch),
            _ToolButton(label: '书签', onTap: onBookmarks),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: context.paper.fg,
              fontSize: 9,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final paper = context.paper;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: selected ? paper.fg : Colors.transparent),
            ),
          ),
          child: SizedBox(
            height: 56,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: paper.fg,
                  fontSize: 10,
                  letterSpacing: 1.8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
