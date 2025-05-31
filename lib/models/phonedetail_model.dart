class PhoneDetail {
  final int id;
  final String name;
  final String brand;
  final int price;
  final String imgUrl;
  final String specification;
  final String creatAt;
  final String updateAt;

  PhoneDetail({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imgUrl,
    required this.specification,
    required this.creatAt,
    required this.updateAt,
  });

  factory PhoneDetail.fromJson(Map<String, dynamic> json) {
    return PhoneDetail(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'],
      imgUrl: json['img_url'],
      specification: json['specification'],
      creatAt: json['createAt'],
      updateAt: json['updateAt'],
    );
  }
}
