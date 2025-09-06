import 'package:flutter_day3/models/Product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, {this.quantity = 1});
}
