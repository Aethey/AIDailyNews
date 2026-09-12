import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  Future<void> articleImpression({
    required String articleId,
    required int position,
    required String feedDate,
  }) {
    return _log('article_impression', {
      'article_id': articleId,
      'position': position,
      'feed_date': feedDate,
    });
  }

  Future<void> articleOpen({
    required String articleId,
    required int position,
    required String feedDate,
  }) {
    return _log('article_open', {
      'article_id': articleId,
      'position': position,
      'feed_date': feedDate,
    });
  }

  Future<void> articleRead({
    required String articleId,
    required int readingTimeSec,
    required int maxScrollPercent,
  }) {
    return _log('article_read', {
      'article_id': articleId,
      'reading_time_sec': readingTimeSec,
      'max_scroll_percent': maxScrollPercent,
    });
  }

  Future<void> originalLinkClick({required String articleId}) {
    return _log('original_link_click', {'article_id': articleId});
  }

  Future<void> articleReopen({required String articleId}) {
    return _log('article_reopen', {'article_id': articleId});
  }

  Future<void> _log(String name, Map<String, Object> parameters) async {
    debugPrint('[analytics] sending $name $parameters');
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      debugPrint('[analytics] $name ok');
    } catch (error, stackTrace) {
      debugPrint('[analytics] $name failed: $error\n$stackTrace');
    }
  }
}
