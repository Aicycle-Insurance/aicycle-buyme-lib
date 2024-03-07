import 'package:equatable/equatable.dart';

class BaseResponse extends Equatable {
  final String? message;
  final dynamic result;
  final int? status;

  const BaseResponse({this.message, this.result, this.status});

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        message: json['message'],
        status: (json['status'] != null && json['status'] is num)
            ? int.tryParse(json['status'])
            : null,
        result: json['result'] ?? json['data'] ?? json['results'] ?? json,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'result': result,
        'status': status,
      };

  @override
  List<Object?> get props => [message, result, status];
}
