import 'package:flutter_day3/models/cart_item.dart';

class Order {
  final List<CartItem> items;
  final double totalPrice;

  Order(this.items, this.totalPrice);
}
