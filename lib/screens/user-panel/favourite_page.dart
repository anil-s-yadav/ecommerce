import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the content vertically
        children: [
          Image.asset('assets/google.png'),
          const SizedBox(height: 16), // Adds spacing between image and text
          const Text(
            'Favourite Page',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold), // Optional styling
          ),
        ],
      ),
    );
  }
}
