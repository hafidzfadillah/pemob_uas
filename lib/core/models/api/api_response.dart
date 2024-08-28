class ApiResponse {
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiResponse({required this.statusCode, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(statusCode: json['statusCode'], data: json['data']);
  }

  factory ApiResponse.failure(int code, Map<String, dynamic> json) =>
      ApiResponse(statusCode: code, data: json);
}
