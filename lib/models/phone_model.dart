class Phone {
  final int id;
  final String name;
  final String brand;
  final int price;
  final String imgUrl;
  final String specification;
  final String createdAt;
  final String updatedAt;

  Phone({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imgUrl,
    required this.specification,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id'] ?? 0,
      name: json['name'] ?? "noData",
      brand: json['brand'] ?? "noData",
      price: json['price'] ?? 0,
      imgUrl: json['img_url'] ?? "noData",
      specification: json['specification'] ?? "noData",
      createdAt: json['created_at'] ?? "noData",
      updatedAt: json['updated_at'] ?? "noData",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'imgUrl': imgUrl,
    };
  }
}
