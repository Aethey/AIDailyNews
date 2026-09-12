import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_models.freezed.dart';
part 'news_models.g.dart';

@freezed
abstract class DailyIssue with _$DailyIssue {
  const factory DailyIssue({
    required String date,
    required String layout,
    required List<Article> articles,
  }) = _DailyIssue;

  factory DailyIssue.fromJson(Map<String, dynamic> json) =>
      _$DailyIssueFromJson(json);
}

@freezed
abstract class Article with _$Article {
  const factory Article({
    required String title,
    required String summary,
    required String body,
    @JsonKey(name: 'source_url') required String sourceUrl,
    @JsonKey(name: 'estimated_read_minutes') required int estimatedReadMinutes,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
