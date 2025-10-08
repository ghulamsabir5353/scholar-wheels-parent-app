abstract class ViewState<T> {}

class LoadingState<T> extends ViewState<T> {}

class EmptyState<T> extends ViewState<T> {
  final String message;
  EmptyState({this.message = 'No Data Found'});
}

class DataState<T> extends ViewState<T> {
  final T data;
  DataState({required this.data});
}

class ErrorState<T> extends ViewState<T> {
  final String message;
  final dynamic retryFunction;
  ErrorState(this.message, {this.retryFunction});
}

class ExceptionState<T> extends ViewState<T> {
  final Exception exception;
  ExceptionState(this.exception);
}
