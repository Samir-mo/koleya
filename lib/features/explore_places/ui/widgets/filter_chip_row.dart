import 'package:flutter/material.dart';

class FilterChipRow extends StatefulWidget {
  const FilterChipRow({super.key});

  @override
  State<FilterChipRow> createState() => _FilterChipRowState();
}

class _FilterChipRowState extends State<FilterChipRow> {
  final List<String> _options = ['ALL', 'Restaurants', 'Shops'];
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(_options.length, (index) {
        final bool isSelected = _selectedIndex == index;
        return InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          child: Container(
            margin: const EdgeInsets.only(right: 25),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFEDB046)
                    : Colors.grey.shade300,
              ),
            ),
            child: Text(
              _options[index],
              style: TextStyle(
                color: isSelected
                    ? Color(0xFF002D6B)
                    : Colors.black87,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }),
    );
  }
}
