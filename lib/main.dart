import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_day3/pages/cart_page.dart';
import 'package:flutter_day3/pages/help_page.dart';
import 'package:flutter_day3/pages/home_page.dart';
import 'package:flutter_day3/pages/login_page.dart';
import 'package:flutter_day3/pages/onboarding_page.dart';
import 'package:flutter_day3/pages/orders_page.dart';
import 'package:flutter_day3/pages/products_page.dart';
import 'package:flutter_day3/pages/profile_page.dart';
import 'package:flutter_day3/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/cart': (context) => CartPage(),
        '/help': (context) => HelpPage(),
        '/onboarding': (context) => OnboardingPage(),
        '/orders': (context) => OrdersPage(),
        '/products': (context) => ProductsPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}

// StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Scaffold(body: Center(child: CircularProgressIndicator()));
//           }
//           if (snapshot.hasError) {
//             return Scaffold(
//               body: Center(child: Text("Error: ${snapshot.error}")),
//             );
//           }
//           if (snapshot.hasData) {
//             return HomePage();
//           }
//           return LoginPage();
//         },
//       ),
