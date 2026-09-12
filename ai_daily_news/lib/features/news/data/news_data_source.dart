import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'catalog.dart';
import 'news_models.dart';

class AssetNewsDataSource {
  AssetNewsDataSource({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  Future<List<NewsIssue>> loadIssues() async {
    final assets = await _listAssets();
    final paths =
        assets
            .where(
              (path) =>
                  path.contains('resources/') && path.endsWith('/news.json'),
            )
            .toList()
          ..sort();
    final issuePaths = paths.isNotEmpty
        ? paths
        : const ['resources/2026-09-12/news.json'];

    final issues = <NewsIssue>[];
    for (final path in issuePaths) {
      try {
        final raw = await _bundle.loadString(path);
        final decoded = jsonDecode(raw);
        if (decoded is! Map<String, dynamic>) continue;
        issues.add(
          _toCatalog(
            DailyIssue.fromJson(decoded),
            jsonPath: path,
            assets: assets,
          ),
        );
      } catch (error) {
        debugPrint('Failed to load $path: $error');
      }
    }
    issues.sort((a, b) => b.date.compareTo(a.date));
    return issues;
  }

  Future<Set<String>> _listAssets() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(_bundle);
      return manifest.listAssets().toSet();
    } catch (error) {
      debugPrint('Asset manifest unavailable: $error');
      return <String>{};
    }
  }

  NewsIssue _toCatalog(
    DailyIssue issue, {
    required String jsonPath,
    required Set<String> assets,
  }) {
    final used = <String>{};
    final articles = <CatalogArticle>[];
    for (var i = 0; i < issue.articles.length; i++) {
      final article = issue.articles[i];
      var id = ArticleIds.from(date: issue.date, sourceUrl: article.sourceUrl);
      if (!used.add(id)) {
        id = '$id-${i + 1}';
        used.add(id);
      }
      articles.add(
        CatalogArticle(
          id: id,
          position: i,
          feedDate: issue.date,
          article: article,
        ),
      );
    }
    final slash = jsonPath.lastIndexOf('/');
    final dir = slash >= 0 ? jsonPath.substring(0, slash) : jsonPath;
    final coverPath = '$dir/cover.svg';
    return NewsIssue(
      date: issue.date,
      layout: issue.layout,
      articles: articles,
      coverAsset: assets.contains(coverPath) ? coverPath : null,
    );
  }
}
