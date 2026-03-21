class VehicleInfoModel {
  final String? carCompany;
  final String? carModel;
  final List<int>? carColor;
  final String? plateNumber;
  final String? vinNumber;
  final double? odo;

  VehicleInfoModel({
    this.carCompany,
    this.carModel,
    this.carColor,
    this.plateNumber,
    this.vinNumber,
    this.odo,
  });

  factory VehicleInfoModel.fromJson(Map<String, dynamic> json) =>
      VehicleInfoModel(
        carCompany: json['carCompany'],
        carModel: json['carModel'],
        carColor: json['carColor'] is List
            ? (json['carColor'] as List<dynamic>).map((e) => e as int).toList()
            : null,
        plateNumber: json['plateNumber'],
        vinNumber: json['vinNumber'],
        odo: json['odo'],
      );

  Map<String, dynamic> toJson() => {
    'carCompany': carCompany,
    'carModel': carModel,
    'carColor': carColor,
    'plateNumber': plateNumber,
    'vinNumber': vinNumber,
    'odo': odo,
  };
}
