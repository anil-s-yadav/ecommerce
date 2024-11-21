import 'package:ecommerce_app/screens/user-panel/cart_page.dart';
import 'package:flutter/material.dart';
import '../../utils/app-constant.dart';
import '../../widgets/banner-widget.dart';
import '../../widgets/category-widget.dart';
import '../../widgets/all-products-widget.dart';
import 'favourite_page.dart';
import 'search-page.dart';
import 'user_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const MainScreenContent(),
    const FavouritePage(),
    const CartScreen(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(AppConstant.appMainName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchItemPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppConstant.appMainColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}

class MainScreenContent extends StatelessWidget {
  const MainScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(10.0), // Adds margin of 10 around the widget
      child: SingleChildScrollView(
        // Enables scrolling when content exceeds screen height
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align all items to the start
          children: [
            const BannerWidget(), // Banner widget at the top
            const SizedBox(
                height: 20), // Adds spacing between the banner and heading
            const Text(
              'Categories', // Categories heading
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
                height: 10), // Adds space between heading and categories widget
            const CategoriesWidget(), // Categories widget
            const SizedBox(
                height: 20), // Adds space between categories and products

            const Text(
              'All Products', // All Products heading
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
                height: 10), // Adds space between heading and products widget
            const AllProductsWidget(), // All products widget
          ],
        ),
      ),
    );
  }
}
