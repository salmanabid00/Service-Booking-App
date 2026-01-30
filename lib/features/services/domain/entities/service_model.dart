class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationInMinutes;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationInMinutes,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map, String id) {
    return ServiceModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      durationInMinutes: map['durationInMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'durationInMinutes': durationInMinutes,
    };
  }
}
