import 'news_models.dart';

class CatalogArticle {
  const CatalogArticle({
    required this.id,
    required this.position,
    required this.feedDate,
    required this.article,
  });

  final String id;
  final int position;
  final String feedDate;
  final Article article;

  String get sourceHost {
    final host = Uri.tryParse(article.sourceUrl)?.host ?? '';
    return host.replaceFirst(RegExp(r'^www\.'), '');
  }
}

class NewsIssue {
  const NewsIssue({
    required this.date,
    required this.layout,
    required this.articles,
    this.coverAsset,
  });

  final String date;
  final String layout;
  final List<CatalogArticle> articles;
  final String? coverAsset;

  int get totalReadMinutes => articles.fold<int>(
    0,
    (sum, item) => sum + item.article.estimatedReadMinutes,
  );

  CatalogArticle? byId(String id) {
    for (final article in articles) {
      if (article.id == id) return article;
    }
    return null;
  }
}

class ArticleIds {
  static String from({required String date, required String sourceUrl}) {
    final compactDate = date.replaceAll('-', '');
    final uri = Uri.tryParse(sourceUrl);
    final slug = _slug(uri) ?? 'article';
    return '$compactDate-$slug';
  }

  static String? _slug(Uri? uri) {
    if (uri == null) return null;
    final segments = uri.pathSegments.where((part) => part.isNotEmpty).toList();
    if (segments.isEmpty) {
      return uri.host.replaceAll('.', '-').toLowerCase();
    }
    var last = segments.last.toLowerCase();
    if (last.contains('.')) {
      last = last.split('.').first;
    }
    last = last.replaceAll(RegExp(r'[^a-z0-9-]+'), '-');
    last = last
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    if (last.isEmpty) {
      return uri.host.replaceAll('.', '-').toLowerCase();
    }
    return last;
  }
}
