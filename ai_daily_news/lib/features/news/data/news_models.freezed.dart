// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyIssue {

 String get date; String get layout; List<Article> get articles;
/// Create a copy of DailyIssue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyIssueCopyWith<DailyIssue> get copyWith => _$DailyIssueCopyWithImpl<DailyIssue>(this as DailyIssue, _$identity);

  /// Serializes this DailyIssue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DailyIssue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyIssue&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.layout, _this.layout) || other.layout == _this.layout)&&const DeepCollectionEquality().equals(other.articles, _this.articles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailyIssue;
  return Object.hash(runtimeType,_this.date,_this.layout,const DeepCollectionEquality().hash(_this.articles));
}

@override
String toString() {
  final _this = this as DailyIssue;
  return 'DailyIssue(date: ${_this.date}, layout: ${_this.layout}, articles: ${_this.articles})';
}


}

/// @nodoc
abstract mixin class $DailyIssueCopyWith<$Res>  {
  factory $DailyIssueCopyWith(DailyIssue value, $Res Function(DailyIssue) _then) = _$DailyIssueCopyWithImpl;
@useResult
$Res call({
 String date, String layout, List<Article> articles
});




}
/// @nodoc
class _$DailyIssueCopyWithImpl<$Res>
    implements $DailyIssueCopyWith<$Res> {
  _$DailyIssueCopyWithImpl(this._self, this._then);

  final DailyIssue _self;
  final $Res Function(DailyIssue) _then;

/// Create a copy of DailyIssue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? layout = null,Object? articles = null,}) {
  return _then(DailyIssue(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as String,articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<Article>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyIssue].
extension DailyIssuePatterns on DailyIssue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyIssue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyIssue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyIssue value)  $default,){
final _that = this;
switch (_that) {
case _DailyIssue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyIssue value)?  $default,){
final _that = this;
switch (_that) {
case _DailyIssue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String layout,  List<Article> articles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyIssue() when $default != null:
return $default(_that.date,_that.layout,_that.articles);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String layout,  List<Article> articles)  $default,) {final _that = this;
switch (_that) {
case _DailyIssue():
return $default(_that.date,_that.layout,_that.articles);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String layout,  List<Article> articles)?  $default,) {final _that = this;
switch (_that) {
case _DailyIssue() when $default != null:
return $default(_that.date,_that.layout,_that.articles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyIssue implements DailyIssue {
  const _DailyIssue({required this.date, required this.layout, required  List<Article> articles}): _articles = articles;
  factory _DailyIssue.fromJson(Map<String, dynamic> json) => _$DailyIssueFromJson(json);

@override final  String date;
@override final  String layout;
 final  List<Article> _articles;
@override List<Article> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}


/// Create a copy of DailyIssue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyIssueCopyWith<_DailyIssue> get copyWith => __$DailyIssueCopyWithImpl<_DailyIssue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyIssueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyIssue&&(identical(other.date, date) || other.date == date)&&(identical(other.layout, layout) || other.layout == layout)&&const DeepCollectionEquality().equals(other.articles, _articles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,layout,const DeepCollectionEquality().hash(_articles));
}

@override
String toString() {
    return 'DailyIssue(date: $date, layout: $layout, articles: $articles)';
}


}

/// @nodoc
abstract mixin class _$DailyIssueCopyWith<$Res> implements $DailyIssueCopyWith<$Res> {
  factory _$DailyIssueCopyWith(_DailyIssue value, $Res Function(_DailyIssue) _then) = __$DailyIssueCopyWithImpl;
@override @useResult
$Res call({
 String date, String layout, List<Article> articles
});




}
/// @nodoc
class __$DailyIssueCopyWithImpl<$Res>
    implements _$DailyIssueCopyWith<$Res> {
  __$DailyIssueCopyWithImpl(this._self, this._then);

  final _DailyIssue _self;
  final $Res Function(_DailyIssue) _then;

/// Create a copy of DailyIssue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? layout = null,Object? articles = null,}) {
  return _then(_DailyIssue(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as String,articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<Article>,
  ));
}


}


/// @nodoc
mixin _$Article {

 String get title; String get summary; String get body;@JsonKey(name: 'source_url') String get sourceUrl;@JsonKey(name: 'estimated_read_minutes') int get estimatedReadMinutes;
/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArticleCopyWith<Article> get copyWith => _$ArticleCopyWithImpl<Article>(this as Article, _$identity);

  /// Serializes this Article to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Article;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Article&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.sourceUrl, _this.sourceUrl) || other.sourceUrl == _this.sourceUrl)&&(identical(other.estimatedReadMinutes, _this.estimatedReadMinutes) || other.estimatedReadMinutes == _this.estimatedReadMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Article;
  return Object.hash(runtimeType,_this.title,_this.summary,_this.body,_this.sourceUrl,_this.estimatedReadMinutes);
}

@override
String toString() {
  final _this = this as Article;
  return 'Article(title: ${_this.title}, summary: ${_this.summary}, body: ${_this.body}, sourceUrl: ${_this.sourceUrl}, estimatedReadMinutes: ${_this.estimatedReadMinutes})';
}


}

/// @nodoc
abstract mixin class $ArticleCopyWith<$Res>  {
  factory $ArticleCopyWith(Article value, $Res Function(Article) _then) = _$ArticleCopyWithImpl;
@useResult
$Res call({
 String title, String summary, String body,@JsonKey(name: 'source_url') String sourceUrl,@JsonKey(name: 'estimated_read_minutes') int estimatedReadMinutes
});




}
/// @nodoc
class _$ArticleCopyWithImpl<$Res>
    implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._self, this._then);

  final Article _self;
  final $Res Function(Article) _then;

/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? summary = null,Object? body = null,Object? sourceUrl = null,Object? estimatedReadMinutes = null,}) {
  return _then(Article(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,estimatedReadMinutes: null == estimatedReadMinutes ? _self.estimatedReadMinutes : estimatedReadMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Article].
extension ArticlePatterns on Article {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Article value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Article() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Article value)  $default,){
final _that = this;
switch (_that) {
case _Article():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Article value)?  $default,){
final _that = this;
switch (_that) {
case _Article() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String summary,  String body, @JsonKey(name: 'source_url')  String sourceUrl, @JsonKey(name: 'estimated_read_minutes')  int estimatedReadMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Article() when $default != null:
return $default(_that.title,_that.summary,_that.body,_that.sourceUrl,_that.estimatedReadMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String summary,  String body, @JsonKey(name: 'source_url')  String sourceUrl, @JsonKey(name: 'estimated_read_minutes')  int estimatedReadMinutes)  $default,) {final _that = this;
switch (_that) {
case _Article():
return $default(_that.title,_that.summary,_that.body,_that.sourceUrl,_that.estimatedReadMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String summary,  String body, @JsonKey(name: 'source_url')  String sourceUrl, @JsonKey(name: 'estimated_read_minutes')  int estimatedReadMinutes)?  $default,) {final _that = this;
switch (_that) {
case _Article() when $default != null:
return $default(_that.title,_that.summary,_that.body,_that.sourceUrl,_that.estimatedReadMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Article implements Article {
  const _Article({required this.title, required this.summary, required this.body, @JsonKey(name: 'source_url') required this.sourceUrl, @JsonKey(name: 'estimated_read_minutes') required this.estimatedReadMinutes});
  factory _Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

@override final  String title;
@override final  String summary;
@override final  String body;
@override@JsonKey(name: 'source_url') final  String sourceUrl;
@override@JsonKey(name: 'estimated_read_minutes') final  int estimatedReadMinutes;

/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArticleCopyWith<_Article> get copyWith => __$ArticleCopyWithImpl<_Article>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArticleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Article&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.body, body) || other.body == body)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.estimatedReadMinutes, estimatedReadMinutes) || other.estimatedReadMinutes == estimatedReadMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,summary,body,sourceUrl,estimatedReadMinutes);
}

@override
String toString() {
    return 'Article(title: $title, summary: $summary, body: $body, sourceUrl: $sourceUrl, estimatedReadMinutes: $estimatedReadMinutes)';
}


}

/// @nodoc
abstract mixin class _$ArticleCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$ArticleCopyWith(_Article value, $Res Function(_Article) _then) = __$ArticleCopyWithImpl;
@override @useResult
$Res call({
 String title, String summary, String body,@JsonKey(name: 'source_url') String sourceUrl,@JsonKey(name: 'estimated_read_minutes') int estimatedReadMinutes
});




}
/// @nodoc
class __$ArticleCopyWithImpl<$Res>
    implements _$ArticleCopyWith<$Res> {
  __$ArticleCopyWithImpl(this._self, this._then);

  final _Article _self;
  final $Res Function(_Article) _then;

/// Create a copy of Article
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? summary = null,Object? body = null,Object? sourceUrl = null,Object? estimatedReadMinutes = null,}) {
  return _then(_Article(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,estimatedReadMinutes: null == estimatedReadMinutes ? _self.estimatedReadMinutes : estimatedReadMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
