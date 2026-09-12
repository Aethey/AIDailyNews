// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyIssue _$DailyIssueFromJson(Map<String, dynamic> json) => _DailyIssue(
  date: json['date'] as String,
  layout: json['layout'] as String,
  articles: (json['articles'] as List<dynamic>)
      .map((e) => Article.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DailyIssueToJson(_DailyIssue instance) =>
    <String, dynamic>{
      'date': instance.date,
      'layout': instance.layout,
      'articles': instance.articles.map((e) => e.toJson()).toList(),
    };

_Article _$ArticleFromJson(Map<String, dynamic> json) => _Article(
  title: json['title'] as String,
  summary: json['summary'] as String,
  body: json['body'] as String,
  sourceUrl: json['source_url'] as String,
  estimatedReadMinutes: (json['estimated_read_minutes'] as num).toInt(),
);

Map<String, dynamic> _$ArticleToJson(_Article instance) => <String, dynamic>{
  'title': instance.title,
  'summary': instance.summary,
  'body': instance.body,
  'source_url': instance.sourceUrl,
  'estimated_read_minutes': instance.estimatedReadMinutes,
};
