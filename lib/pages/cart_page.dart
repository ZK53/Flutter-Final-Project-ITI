import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/utilities/my_drawer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _confirm() async {
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid);
    final snapshot = await userDoc.get();
    final data = snapshot.data() as Map<String, dynamic>;
    final cart = List<Map<String, dynamic>>.from(data["cart"] ?? []);

    final total = cart.fold(
      0.0,
      (sum, item) => sum += (item["price"] * item["quantity"]),
    );

    final newOrder = {
      "createdAt": FieldValue.serverTimestamp(),
      "products": cart,
      "total": total,
    };

    await userDoc.collection("orders").add(newOrder);
    await userDoc.update({
      "cart": [],
      "total_spent": FieldValue.increment(total),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Order confirmed. Total \$${total.toStringAsFixed(2)}"),
        ),
      );
    }
  }

  Future<void> _delete(int index) async {
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid);
    final snapshot = await userDoc.get();
    final data = snapshot.data() as Map<String, dynamic>;
    final cart = List<Map<String, dynamic>>.from(data["cart"] ?? []);
    if (index >= 0 && index < cart.length) {
      final item = cart[index];
      cart.removeAt(index);
      await userDoc.update({"cart": cart});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${item["name"]} removed from cart")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal[200]),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final cart = List<Map<String, dynamic>>.from(
                  data["cart"] ?? [],
                );

                if (cart.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        "Your cart is empty",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final item = cart[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: ListTile(
                              leading: Image.asset(
                                item["image"],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item["name"]),
                              subtitle: Text(
                                "\$${item["price"]} x ${item["quantity"]}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "\$${(item['price'] * item["quantity"]).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _delete(index),
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _confirm,
                        child: Text(
                          "Confirm Order",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
