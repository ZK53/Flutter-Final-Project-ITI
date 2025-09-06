import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/models/product.dart';
import 'package:flutter_day3/utilities/my_drawer.dart';
import 'package:flutter_day3/utilities/product_card.dart';
import 'package:flutter_day3/utilities/search_delegate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Widget buildBanner(String image) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        title: Text("Home Page"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
            icon: Icon(Icons.search, size: 30),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Welcome, ${(user!.displayName)?.split(" ").first ?? "Guest"}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: PageView(
                  controller: PageController(viewportFraction: 0.9),
                  children: [
                    buildBanner("images/welcome.jpg"),
                    buildBanner("images/mega_sales.png"),
                  ],
                ),
              ),
              Text(
                "Recently Featured",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .limit(3)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No products available"));
                  }

                  final docs = snapshot.data!.docs;
                  final featured = docs.map((doc) {
                    return Product.fromMap(doc.data());
                  }).toList();

                  return SizedBox(
                    height: 260,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 12);
                      },
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 200,
                          child: ProductCard(product: featured[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
