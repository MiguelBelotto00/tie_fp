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

  /// Convert a no-argument function to a Result
  /// set [report] to false to disable error logging
  ///
  /// ```dart
  /// final result = someFunction.toResult();
  /// ```
  Result<T> toResult({bool report = true}) {
    try {
      return Success(this);
    } catch (e, s) {
      return Failure(e, stackTrace: s, report: report);
    }
  }
}

extension ResultFunction<T> on T{
  
}

extension ResultFunction1<T, A> on T Function(A) {
  /// Convert a single-argument function to a Result (e.g., fromJson)
  /// set [report] to false to disable error logging
  ///
  /// ```dart
  /// final result = Model.fromJson.toResult(json);
  /// ```
  Result<T> toResult(A arg, {bool report = true}) {
    try {
      return Success(this(arg));
    } catch (e, s) {
      return Failure(e, stackTrace: s, report: report);
    }
  }
}
