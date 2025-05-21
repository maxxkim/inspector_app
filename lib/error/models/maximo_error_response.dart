import 'package:inspector_tps/error/app_error.dart';

class MaximoErrorResponse extends AppError {
  MaximoErrorResponse({
    super.statusCode,
    super.message,
    super.reasonCode,
  });

  factory MaximoErrorResponse.fromJson(Map<String, dynamic> json) {
    return MaximoErrorResponse(
      message: json["message"],
      statusCode: json["statusCode"],
      reasonCode: json["reasonCode"],
    );
  }
}
