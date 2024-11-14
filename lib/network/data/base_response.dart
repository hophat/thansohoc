class BaseResponse {
  final int? codeStatus;
  final bool? success;
  final String? message;
  final dynamic data;

  BaseResponse({
    required this.codeStatus,
    required this.success,
    required this.message,
    required this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json, {String baseField = 'data'}) {
    return BaseResponse(
      codeStatus: json['codeStatus'],
      success: json['success'],
      message: json['message'],
      data: json[baseField],
    );
  }

  factory BaseResponse.serverErr({int? codeStatus, dynamic data, bool? success, String? msg}) {
    return BaseResponse(
      codeStatus: codeStatus ?? 500,
      success: success ?? false,
      message: msg ?? 'Server error',
      data: data,
    );
  }
}