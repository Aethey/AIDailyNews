class ReadSession {
  ReadSession({required this.articleId, DateTime? startedAt})
    : _startedAt = startedAt ?? DateTime.now();

  final String articleId;
  DateTime _startedAt;
  Duration _accumulated = Duration.zero;
  bool _foreground = true;
  int maxScrollPercent = 100;

  void pause() {
    if (!_foreground) return;
    _accumulated += DateTime.now().difference(_startedAt);
    _foreground = false;
  }

  void resume() {
    if (_foreground) return;
    _startedAt = DateTime.now();
    _foreground = true;
  }

  int get readingTimeSec {
    var total = _accumulated;
    if (_foreground) {
      total += DateTime.now().difference(_startedAt);
    }
    return total.inSeconds;
  }
}
