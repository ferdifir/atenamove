class ApiResponse {
  final int? code;
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['status'],
      success: json['success'],
      message: json['msg'] ?? json['errorMsg'] ?? '',
      data: json['data'],
    );
  }

  @override
  String toString() {
    return 'ApiResponse(code: $code, success: $success, message: $message, data: $data)';
  }
}
