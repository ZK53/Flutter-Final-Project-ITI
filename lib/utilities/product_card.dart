import 'package:flutter/material.dart';
import 'package:flutter_day3/models/product.dart';
import 'package:flutter_day3/pages/product_details_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  factory ProductCard.fromMap(Map<String, dynamic> data) {
    return ProductCard(product: Product.fromMap(data));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(1, 1),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 450,
        width: 200,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
              child: Image.asset(product.image, height: 100, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: TextStyle(color: Colors.teal),
                ),
                Text(
                  product.description,
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
