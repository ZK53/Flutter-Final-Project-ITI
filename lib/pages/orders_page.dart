import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/utilities/my_drawer.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        title: Text("Orders"),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("orders")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!.docs;
          if (orders.isEmpty) {
            return Center(
              child: Text(
                "No orders found",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              final total = orderData["total"] ?? 0.0;
              final products = List<Map<String, dynamic>>.from(
                orderData["products"] ?? [],
              );
              final createdAt = (orderData["createdAt"] as Timestamp?)
                  ?.toDate();

              return Card(
                margin: EdgeInsets.all(10),
                child: ExpansionTile(
                  title: Text("Order ${index + 1}"),
                  subtitle: Text(
                    "Total \$${total.toStringAsFixed(2)} - ${products.length} items",
                  ),
                  children: [
                    if (createdAt != null)
                      Padding(
                        padding: EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          "Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(createdAt)}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ...products.map((product) {
                      return ListTile(
                        leading: Image.asset(
                          product["image"],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product["name"]),
                        subtitle: Text(
                          "\$${product["price"]} x ${product["quantity"]}",
                        ),
                        trailing: Text(
                          "\$${(product["price"] * product["quantity"]).toStringAsFixed(2)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
