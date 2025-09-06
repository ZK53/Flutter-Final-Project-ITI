import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/models/product.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int counter = 1;
  bool _inWishlist = false;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _addToCart() async {
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid);
    final snapshot = await userDoc.get();
    final data = snapshot.data() as Map<String, dynamic>;
    final cart = List<Map<String, dynamic>>.from(data["cart"] ?? []);
    final index = cart.indexWhere(
      (item) => item["name"] == widget.product.name,
    );

    if (index >= 0) {
      cart[index]["quantity"] += counter;
    } else {
      cart.add({
        "name": widget.product.name,
        "image": widget.product.image, // already assets/...
        "price": widget.product.price,
        "quantity": counter,
      });
    }
    await userDoc.update({"cart": cart});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added ${widget.product.name} x $counter to cart"),
        ),
      );
    }
  }

  Future<void> _checkIfInWishlist() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    final data = userDoc.data() as Map<String, dynamic>;
    final wishlist = List<Map<String, dynamic>>.from(data["wishlist"] ?? []);
    final found = wishlist.any((item) => item["name"] == widget.product.name);

    setState(() => _inWishlist = found);
  }

  Future<void> _toggleWishlist() async {
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid);
    final Map<String, String> productMap = {
      "name": widget.product.name,
      "image": widget.product.image,
    };

    if (_inWishlist) {
      await userDoc.update({
        "wishlist": FieldValue.arrayRemove([productMap]),
      });
      setState(() => _inWishlist = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Removed ${widget.product.name} from wishlist"),
          ),
        );
      }
    } else {
      await userDoc.update({
        "wishlist": FieldValue.arrayUnion([productMap]),
      });
      setState(() => _inWishlist = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added ${widget.product.name} to wishlist")),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfInWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                widget.product.image,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "\$${widget.product.price.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, color: Colors.teal),
            ),
            SizedBox(height: 12),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.outlined(
                  onPressed: () {
                    if (counter > 1) {
                      setState(() {
                        counter--;
                      });
                    }
                  },
                  icon: Icon(Icons.remove_circle, size: 24),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    border: Border.all(color: Colors.grey.shade600),
                  ),
                  child: Text(
                    counter.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton.outlined(
                  onPressed: () {
                    setState(() {
                      counter++;
                    });
                  },
                  icon: Icon(Icons.add_circle, size: 24),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              spacing: 9,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _toggleWishlist,
                  icon: _inWishlist
                      ? Icon(Icons.favorite, color: Colors.red, size: 24)
                      : Icon(Icons.favorite_border, size: 24),
                  label: _inWishlist
                      ? Text(
                          "Remove from wishlist",
                          style: TextStyle(fontSize: 16),
                        )
                      : Text("Add to wishlist", style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton.icon(
                  onPressed: _addToCart,
                  icon: Icon(Icons.add_shopping_cart, size: 26),
                  label: Text("Add to cart", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
