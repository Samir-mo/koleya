import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFD4A843),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by name or category...',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              // margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(11),
              decoration: const BoxDecoration(
                color: Color(0xFFC47E3A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
