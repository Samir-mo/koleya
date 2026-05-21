import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String appBarTitle;
  final Widget? leading;
  final VoidCallback? onLeadingPressed;

  const CustomAppBar({
    super.key,
    required this.appBarTitle,
    this.leading,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      width: double.infinity,
      color: const Color(0xFF002D6B),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (leading != null)
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: onLeadingPressed,
                child: leading,
              ),
            ),
          Text(
            appBarTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
