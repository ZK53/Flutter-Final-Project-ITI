import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/utilities/my_drawer.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.teal),
      drawer: MyDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data["name"] ?? "";
          final email = data["email"] ?? "";
          final phone = data["phone"] ?? "";
          final totalSpent = data["total_spent"] ?? 0.0;
          final wishlist = List<Map<String, dynamic>>.from(
            data["wishlist"] ?? [],
          );
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: Icon(Icons.person, size: 40, color: Colors.teal),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.email),
                      title: Text(email, style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(phone, style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text(
                        "Total Spent",
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Text(
                        "\$${totalSpent.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Card(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(user!.uid)
                          .collection("orders")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return ListTile(
                            title: Text("Orders"),
                            trailing: Text("No orders yet"),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            title: Text("Orders"),
                            trailing: CircularProgressIndicator(),
                          );
                        }

                        final ordersCount = snapshot.data!.docs.length;

                        return ListTile(
                          leading: Icon(Icons.delivery_dining),
                          title: Text(
                            "Orders",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Text(
                            ordersCount.toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (wishlist.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Card(
                      child: ExpansionTile(
                        title: Text(
                          "Wishlist",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Icon(Icons.favorite, color: Colors.red),
                        children: wishlist.isNotEmpty
                            ? wishlist.map((item) {
                                return ListTile(
                                  leading: Image.asset(
                                    item["image"],
                                    width: 40,
                                    height: 40,
                                  ),
                                  title: Text(item["name"]),
                                );
                              }).toList()
                            : [
                                ListTile(
                                  title: Text(
                                    "No items in wishlist",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
