import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/utilities/my_drawer.dart';
import 'package:flutter_day3/utilities/product_card.dart';
import 'package:flutter_day3/utilities/search_delegate.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();

  double minPrice = 0;
  double maxPrice = 5000;

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
            icon: Icon(Icons.search, size: 30),
          ),
        ],
        title: Text("Products"),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: minController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Min",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: maxController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Max",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      minPrice = double.tryParse(minController.text) ?? 0;
                      maxPrice = double.tryParse(maxController.text) ?? 5000;
                    });
                  },
                  child: Text("Filter"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final products = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .where((product) {
                        final price = (product['price'] as num).toDouble();
                        return price >= minPrice && price <= maxPrice;
                      })
                      .toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard.fromMap(products[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
