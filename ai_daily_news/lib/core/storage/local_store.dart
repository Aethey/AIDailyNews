import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../theme/paper_theme.dart';

class BookmarkRecord {
  const BookmarkRecord({required this.articleId, required this.feedDate});

  final String articleId;
  final String feedDate;

  Map<String, String> toJson() => {
    'articleId': articleId,
    'feedDate': feedDate,
  };

  factory BookmarkRecord.fromJson(Map<String, dynamic> json) {
    return BookmarkRecord(
      articleId: json['articleId'] as String,
      feedDate: json['feedDate'] as String,
    );
  }
}

class LocalStore {
  LocalStore(this._prefs);

  static const _bookmarksKey = 'bookmarks';
  static const _progressKey = 'issue_progress';
  static const _openedKey = 'opened_article_ids';
  static const _paperModeKey = 'paper_mode';
  static const _lastIssueKey = 'last_opened_issue';

  final SharedPreferences _prefs;

  List<BookmarkRecord> bookmarks() {
    final raw = _prefs.getString(_bookmarksKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((item) => BookmarkRecord.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> saveBookmarks(List<BookmarkRecord> records) {
    return _prefs.setString(
      _bookmarksKey,
      jsonEncode(records.map((item) => item.toJson()).toList()),
    );
  }

  Map<String, int> issueProgress() {
    final raw = _prefs.getString(_progressKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return {};
    return decoded.map(
      (key, value) => MapEntry(key.toString(), (value as num).toInt()),
    );
  }

  Future<void> saveIssueProgress(Map<String, int> progress) {
    return _prefs.setString(_progressKey, jsonEncode(progress));
  }

  Set<String> openedArticleIds() {
    return _prefs.getStringList(_openedKey)?.toSet() ?? <String>{};
  }

  Future<void> saveOpenedArticleIds(Set<String> ids) {
    return _prefs.setStringList(_openedKey, ids.toList());
  }

  PaperMode paperMode() {
    return _prefs.getString(_paperModeKey) == PaperMode.night.name
        ? PaperMode.night
        : PaperMode.morning;
  }

  Future<void> savePaperMode(PaperMode mode) {
    return _prefs.setString(_paperModeKey, mode.name);
  }

  String? lastOpenedIssue() => _prefs.getString(_lastIssueKey);

  Future<void> saveLastOpenedIssue(String date) {
    return _prefs.setString(_lastIssueKey, date);
  }
}
