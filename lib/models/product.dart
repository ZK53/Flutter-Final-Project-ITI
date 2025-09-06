class Product {
  String name;
  double price;
  String description;
  String image;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      name: data["name"] ?? "",
      description: data["description"] ?? "",
      price: (data["price"] ?? 0).toDouble(),
      image: data["image"] ?? "",
    );
  }
}
