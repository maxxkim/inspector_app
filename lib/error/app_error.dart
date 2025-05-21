class AppError {
  String? message;
  String? statusCode;
  String? reasonCode;

  AppError({
    this.statusCode,
    this.message,
    this.reasonCode,
  });
}