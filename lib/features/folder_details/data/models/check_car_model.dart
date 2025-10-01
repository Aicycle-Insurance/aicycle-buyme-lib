import 'package:equatable/equatable.dart';

class CheckCarModel extends Equatable {
  final num? state;
  final String? message;

  const CheckCarModel({this.state, this.message});

  factory CheckCarModel.fromJson(Map<String, dynamic> json) {
    return CheckCarModel(
      state: num.tryParse(json['state'].toString()),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (state != null) 'state': state,
    if (message != null) 'message': message,
  };

  CheckCarModel copyWith({num? state, String? message}) {
    return CheckCarModel(
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props {
    return [state, message];
  }
}
