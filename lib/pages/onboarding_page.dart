import 'package:flutter/material.dart';
import 'package:flutter_day3/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() {
                _currentPage = index;
              }),
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/Purchase_online.png"),
                      SizedBox(height: 20),
                      Text(
                        "Purshace Online !!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/Track_Order.png"),
                      SizedBox(height: 20),
                      Text(
                        "Track Order !!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/Get_your_order.png"),
                      SizedBox(height: 20),
                      Text(
                        "Get Your Order !!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.all(4),
                width: _currentPage == index ? 20 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.teal : Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton(
              onPressed: () {
                if (_currentPage < 2) {
                  _pageController.animateToPage(
                    _currentPage + 1,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: Size(double.infinity, 40),
              ),
              child: Text(
                _currentPage < 2 ? "Next" : "Get Started",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
