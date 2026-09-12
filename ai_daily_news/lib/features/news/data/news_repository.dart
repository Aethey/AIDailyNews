import 'catalog.dart';
import 'news_data_source.dart';

class NewsRepository {
  NewsRepository(this._dataSource);

  final AssetNewsDataSource _dataSource;

  Future<List<NewsIssue>> loadIssues() => _dataSource.loadIssues();
}
