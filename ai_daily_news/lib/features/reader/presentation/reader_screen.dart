import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vellum_engine/page_curl.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/analytics/read_session.dart';
import '../../../core/format/dates.dart';
import '../../../core/theme/paper_theme.dart';
import '../../news/data/catalog.dart';
import '../../news/presentation/news_providers.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key, required this.session, required this.issue});

  final ReaderSession session;
  final NewsIssue issue;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen>
    with WidgetsBindingObserver {
  late final PageCurlController _controller;
  late final AnalyticsService _analytics;
  Timer? _impressionTimer;
  ReadSession? _readSession;
  final Set<String> _impressed = {};
  String? _activeArticleId;
  bool _openedLogged = false;
  Size? _pageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _analytics = ref.read(analyticsServiceProvider);
    _controller = PageCurlController(
      pages: _bookPages(widget.issue),
      config: _configFor(PaperMode.morning, const Size(390, 700)),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyTheme(ref.read(paperModeProvider));
      final start = widget.session.initialPage.clamp(
        0,
        widget.issue.articles.length - 1,
      );
      if (start > 0) {
        _controller.jumpToPage(start);
      }
      _onPageActivated(start, logOpen: true);
    });
  }

  @override
  void dispose() {
    _impressionTimer?.cancel();
    _flushRead();
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _readSession?.resume();
    } else {
      _readSession?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final paper = context.paper;
    final pageIndex = ref.watch(
      shellProvider.select((state) => state.reader?.pageIndex ?? 0),
    );
    final article = widget
        .issue
        .articles[pageIndex.clamp(0, widget.issue.articles.length - 1)];
    final bookmarked = ref.watch(
      bookmarksProvider.select(
        (items) => items.any((item) => item.articleId == article.id),
      ),
    );

    ref.listen(paperModeProvider, (previous, next) {
      _applyTheme(next);
    });

    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = constraints.biggest;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _syncPageSize(size);
              });
              // The engine always inset 24x16 and draws a book drop shadow.
              // Expand then clip so the paper fills the reader with no card frame.
              return ClipRect(
                child: OverflowBox(
                  minWidth: size.width + 24,
                  maxWidth: size.width + 24,
                  minHeight: size.height + 16,
                  maxHeight: size.height + 16,
                  child: PageCurlBookView(
                    controller: _controller,
                    initialPage: widget.session.initialPage,
                    onPageChanged: (index) {
                      ref.read(shellProvider.notifier).setReaderPage(index);
                      _onPageActivated(index);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 92,
          child: Text(
            '${twoDigits(pageIndex + 1)} / ${twoDigits(widget.issue.articles.length)}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: paper.muted,
              fontSize: 11,
              letterSpacing: 1.8,
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 24,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Row(
                children: [
                  Expanded(
                    child: _ReaderDockButton(
                      label: '返回',
                      onTap: () =>
                          ref.read(shellProvider.notifier).closeReader(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ReaderDockButton(
                      label: '书签',
                      pressed: bookmarked,
                      onTap: () =>
                          ref.read(bookmarksProvider.notifier).toggle(article),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ReaderDockButton(
                      label: '原文',
                      onTap: () => _openOriginal(article),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _syncPageSize(Size size) {
    if (_pageSize == size) return;
    _pageSize = size;
    _applyTheme(ref.read(paperModeProvider));
  }

  void _applyTheme(PaperMode mode) {
    final size =
        _pageSize ??
        (mounted ? MediaQuery.sizeOf(context) : const Size(390, 700));
    _controller.config = _configFor(mode, size);
  }

  PageCurlConfig _configFor(PaperMode mode, Size size) {
    final paper = mode == PaperMode.morning
        ? PaperColors.morning
        : PaperColors.night;
    final height = size.height.clamp(360.0, 1400.0);
    final width = size.width.clamp(260.0, 620.0);
    return PageCurlConfig(
      pageRatio: width / height,
      shadowStrength: 0.55,
      shadowWidth: 28,
      typography: const BookTypography(
        horizontalPadding: 22,
        topPadding: 8,
        bottomPadding: 96,
        titleSize: 32,
        bodySize: 15,
        lineHeight: 1.55,
        paragraphSpacing: 16,
        pageNumberSize: 0,
      ),
      theme: BookTheme(
        name: mode.name,
        pageColor: paper.bg,
        pageColorEnd: paper.bg,
        titleColor: paper.fg,
        bodyColor: paper.fg,
        pageNumberColor: paper.bg,
        captionColor: paper.muted,
        borderWidth: 0,
        vignetteOpacity: 0,
        edgeShadeOpacity: 0,
        backFaceTint: paper.bg,
      ),
    );
  }

  List<BookPage> _bookPages(NewsIssue issue) {
    return [
      for (var i = 0; i < issue.articles.length; i++)
        BookPage.rich(
          pageNumber: i + 1,
          contents: [
            TitleBlock(issue.articles[i].article.title),
            ParagraphBlock(issue.articles[i].article.summary),
            ParagraphBlock(issue.articles[i].article.body),
          ],
        ),
    ];
  }

  void _onPageActivated(int index, {bool logOpen = false}) {
    if (widget.issue.articles.isEmpty) return;
    final article =
        widget.issue.articles[index.clamp(0, widget.issue.articles.length - 1)];
    _flushRead();
    _activeArticleId = article.id;
    _readSession = ReadSession(articleId: article.id);

    if (logOpen && !_openedLogged) {
      _openedLogged = true;
      final opened = ref.read(openedArticlesProvider.notifier);
      if (opened.hasOpened(article.id)) {
        unawaited(_analytics.articleReopen(articleId: article.id));
      }
      unawaited(opened.markOpened(article.id));
      unawaited(
        _analytics.articleOpen(
          articleId: article.id,
          position: article.position,
          feedDate: article.feedDate,
        ),
      );
    }

    _impressionTimer?.cancel();
    _impressionTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted || _activeArticleId != article.id) return;
      if (!_impressed.add(article.id)) return;
      unawaited(
        _analytics.articleImpression(
          articleId: article.id,
          position: article.position,
          feedDate: article.feedDate,
        ),
      );
    });
  }

  void _flushRead() {
    final session = _readSession;
    _readSession = null;
    if (session == null) return;
    unawaited(
      _analytics.articleRead(
        articleId: session.articleId,
        readingTimeSec: session.readingTimeSec,
        maxScrollPercent: session.maxScrollPercent,
      ),
    );
  }

  Future<void> _openOriginal(CatalogArticle article) async {
    final uri = Uri.tryParse(article.article.sourceUrl);
    if (uri == null) return;
    await _analytics.originalLinkClick(articleId: article.id);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _ReaderDockButton extends StatelessWidget {
  const _ReaderDockButton({
    required this.label,
    required this.onTap,
    this.pressed = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool pressed;

  @override
  Widget build(BuildContext context) {
    final paper = context.paper;
    return Material(
      color: paper.surface,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: pressed
                  ? Color.lerp(paper.accent, paper.border, 0.55)!
                  : paper.border,
            ),
          ),
          child: SizedBox(
            height: 48,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: pressed ? paper.accent : paper.fg,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
