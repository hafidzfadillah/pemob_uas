
enum ApiStatus { initial, loading, success, error }

class ApiResult<T> {
  final ApiStatus status;
  final T? data;
  final String? error;

  ApiResult.initial() : status = ApiStatus.initial, data = null, error = null;
  ApiResult.loading() : status = ApiStatus.loading, data = null, error = null;
  ApiResult.success(this.data) : status = ApiStatus.success, error = null;
  ApiResult.error(this.error) : status = ApiStatus.error, data = null;
}
