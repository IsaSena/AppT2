class Vehicle {
  final String id;
  final String model;
  final String brand;
  final int year;

  Vehicle({
    required this.id,
    required this.model,
    required this.brand,
    required this.year,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      model: json['model'] as String,
      brand: json['brand'] as String,
      year: json['year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'brand': brand,
      'year': year,
    };
  }
}
