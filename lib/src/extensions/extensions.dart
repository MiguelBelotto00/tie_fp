part of tie_fp;

extension ResultFuture<T> on Future<T> {
  /// Convert a Future to a Result
  /// set [report] to false to disable error logging
  ///
  Future<Result<T>> toResult({bool report = true}) async {
    try {
      return Success(await this);
    } catch (e, s) {
      return Failure(e, stackTrace: s, report: report);
    }
  }
}

extension ResultT<T> on T {
  Result<T> toSuccess() => Success(this);
}

extension ResultFromJson<T> on T Function(Map<String, dynamic>) {
  /// Convert a fromJson factory to a Result
  /// set [report] to false to disable error logging
  ///
  /// ```dart
  /// final result = AlgoliaCarruselSection.fromJson.toResult(json);
  /// ```
  Result<T> toResult(Map<String, dynamic> json, {bool report = true}) {
    try {
      return Success(this(json));
    } catch (e, s) {
      return Failure(e, stackTrace: s, report: report);
    }
  }
}
