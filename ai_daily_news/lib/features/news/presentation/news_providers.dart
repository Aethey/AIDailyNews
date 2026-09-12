import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/storage/local_store.dart';
import '../../../core/theme/paper_theme.dart';
import '../data/catalog.dart';
import '../data/news_data_source.dart';
import '../data/news_repository.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('sharedPreferencesProvider must be overridden in main()');
});

final localStoreProvider = Provider<LocalStore>((ref) {
  return LocalStore(ref.watch(sharedPreferencesProvider));
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(AssetNewsDataSource());
});

final issuesProvider = FutureProvider<List<NewsIssue>>((ref) {
  return ref.watch(newsRepositoryProvider).loadIssues();
});

final latestIssueProvider = Provider<AsyncValue<NewsIssue?>>((ref) {
  return ref.watch(issuesProvider).whenData((issues) {
    return issues.isEmpty ? null : issues.first;
  });
});

class PaperModeNotifier extends Notifier<PaperMode> {
  @override
  PaperMode build() => ref.watch(localStoreProvider).paperMode();

  Future<void> toggle() async {
    final next = state == PaperMode.morning
        ? PaperMode.night
        : PaperMode.morning;
    state = next;
    await ref.read(localStoreProvider).savePaperMode(next);
  }
}

final paperModeProvider = NotifierProvider<PaperModeNotifier, PaperMode>(
  PaperModeNotifier.new,
);

class BookmarksNotifier extends Notifier<List<BookmarkRecord>> {
  @override
  List<BookmarkRecord> build() => ref.watch(localStoreProvider).bookmarks();

  bool contains(String articleId) {
    return state.any((item) => item.articleId == articleId);
  }

  Future<void> toggle(CatalogArticle article) async {
    final next = [...state];
    final index = next.indexWhere((item) => item.articleId == article.id);
    if (index >= 0) {
      next.removeAt(index);
    } else {
      next.insert(
        0,
        BookmarkRecord(articleId: article.id, feedDate: article.feedDate),
      );
    }
    state = next;
    await ref.read(localStoreProvider).saveBookmarks(next);
  }
}

final bookmarksProvider =
    NotifierProvider<BookmarksNotifier, List<BookmarkRecord>>(
      BookmarksNotifier.new,
    );

class IssueProgressNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => ref.watch(localStoreProvider).issueProgress();

  Future<void> markPage({required String date, required int pageIndex}) async {
    final current = state[date] ?? -1;
    if (pageIndex <= current) return;
    final next = {...state, date: pageIndex};
    state = next;
    await ref.read(localStoreProvider).saveIssueProgress(next);
  }
}

final issueProgressProvider =
    NotifierProvider<IssueProgressNotifier, Map<String, int>>(
      IssueProgressNotifier.new,
    );

enum IssueReadState { unread, partial, done }

IssueReadState issueReadState(NewsIssue issue, Map<String, int> progress) {
  if (!progress.containsKey(issue.date)) return IssueReadState.unread;
  final page = progress[issue.date]!;
  if (issue.articles.isEmpty || page >= issue.articles.length - 1) {
    return IssueReadState.done;
  }
  return IssueReadState.partial;
}

class OpenedArticlesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => ref.watch(localStoreProvider).openedArticleIds();

  bool hasOpened(String articleId) => state.contains(articleId);

  Future<void> markOpened(String articleId) async {
    if (state.contains(articleId)) return;
    final next = {...state, articleId};
    state = next;
    await ref.read(localStoreProvider).saveOpenedArticleIds(next);
  }
}

final openedArticlesProvider =
    NotifierProvider<OpenedArticlesNotifier, Set<String>>(
      OpenedArticlesNotifier.new,
    );

enum AppTab { today, shelf, bookmarks }

class ReaderSession {
  const ReaderSession({
    required this.date,
    required this.initialPage,
    required this.pageIndex,
    this.openedFromFeed = true,
  });

  final String date;
  final int initialPage;
  final int pageIndex;
  final bool openedFromFeed;

  ReaderSession copyWith({int? pageIndex}) {
    return ReaderSession(
      date: date,
      initialPage: initialPage,
      pageIndex: pageIndex ?? this.pageIndex,
      openedFromFeed: openedFromFeed,
    );
  }
}

class ShellState {
  const ShellState({
    this.tab = AppTab.today,
    this.searchOpen = false,
    this.reader,
  });

  final AppTab tab;
  final bool searchOpen;
  final ReaderSession? reader;

  ShellState copyWith({
    AppTab? tab,
    bool? searchOpen,
    ReaderSession? reader,
    bool clearReader = false,
  }) {
    return ShellState(
      tab: tab ?? this.tab,
      searchOpen: searchOpen ?? this.searchOpen,
      reader: clearReader ? null : (reader ?? this.reader),
    );
  }
}

class ShellNotifier extends Notifier<ShellState> {
  @override
  ShellState build() => const ShellState();

  void selectTab(AppTab tab) {
    state = state.copyWith(tab: tab, searchOpen: false, clearReader: true);
  }

  void toggleSearch() {
    state = state.copyWith(searchOpen: !state.searchOpen);
  }

  void closeSearch() {
    state = state.copyWith(searchOpen: false);
  }

  Future<void> openReader({
    required String date,
    int pageIndex = 0,
    bool openedFromFeed = true,
  }) async {
    state = state.copyWith(
      searchOpen: false,
      reader: ReaderSession(
        date: date,
        initialPage: pageIndex,
        pageIndex: pageIndex,
        openedFromFeed: openedFromFeed,
      ),
    );
    await ref.read(localStoreProvider).saveLastOpenedIssue(date);
    await ref
        .read(issueProgressProvider.notifier)
        .markPage(date: date, pageIndex: pageIndex);
  }

  void closeReader() {
    state = state.copyWith(clearReader: true);
  }

  void setReaderPage(int pageIndex) {
    final reader = state.reader;
    if (reader == null || reader.pageIndex == pageIndex) return;
    state = state.copyWith(reader: reader.copyWith(pageIndex: pageIndex));
    ref
        .read(issueProgressProvider.notifier)
        .markPage(date: reader.date, pageIndex: pageIndex);
  }
}

final shellProvider = NotifierProvider<ShellNotifier, ShellState>(
  ShellNotifier.new,
);

CatalogArticle? findArticle(List<NewsIssue> issues, String articleId) {
  for (final issue in issues) {
    final match = issue.byId(articleId);
    if (match != null) return match;
  }
  return null;
}
