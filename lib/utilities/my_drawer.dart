import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day3/pages/cart_page.dart';
import 'package:flutter_day3/pages/help_page.dart';
import 'package:flutter_day3/pages/home_page.dart';
import 'package:flutter_day3/pages/orders_page.dart';
import 'package:flutter_day3/pages/products_page.dart';
import 'package:flutter_day3/pages/profile_page.dart';
import 'package:flutter_day3/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.teal),
            accountName: Text(user!.displayName ?? "No Name"),
            accountEmail: Text(user!.email ?? "No Email"),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.home, size: 30, color: Colors.grey[900]),
                SizedBox(width: 20),
                Text(
                  "Home",
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProductsPage()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.shopping_bag, size: 30, color: Colors.grey[900]),
                SizedBox(width: 20),
                Text(
                  "Products",
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.shopping_cart, size: 30, color: Colors.grey[900]),
                SizedBox(width: 20),
                Text(
                  "Cart",
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OrdersPage()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.list_alt_rounded, size: 30, color: Colors.grey[900]),
                SizedBox(width: 20),
                Text(
                  "Orders",
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.person, size: 30, color: Colors.grey[900]),
                SizedBox(width: 20),
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
          Divider(),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.settings, size: 30, color: Colors.grey[900]),
                SizedBox(width: 20),
                Text(
                  "Settings",
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
            child: Row(
              children: [
                Icon(Icons.help, size: 30, color: Colors.grey[900]),
                SizedBox(width: 20),
                Text(
                  "Help & Support",
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Row(
              children: [
                Icon(Icons.logout, size: 30, color: Colors.grey[900]),
                SizedBox(width: 20),
                Text(
                  "Logout",
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
