import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/models/product.dart';
import 'package:flutter_day3/utilities/product_card.dart';

class ProductSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => "Search products";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Stream<List<Product>> _searchStream(String query) {
    final lowerQuery = query.toLowerCase();
    return FirebaseFirestore.instance.collection("products").snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .where(
            (product) =>
                product.name.toLowerCase().contains(lowerQuery) ||
                product.description.toLowerCase().contains(lowerQuery),
          )
          .toList();
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return Center(child: Text("Type something to search"));

    return StreamBuilder<List<Product>>(
      stream: _searchStream(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No products found"));
        }

        final results = snapshot.data!;
        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index];
            return ProductCard(product: product);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
