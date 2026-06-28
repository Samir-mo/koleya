import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/features/flights/logic/cubit/flights_cubit.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  const SearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      style: AppTextStyles.font14Regular.copyWith(color: AppColors.grey700),
      decoration: InputDecoration(
        hintText: 'Search by flight number, airline...',
        hintStyle: AppTextStyles.font14Regular.copyWith(
          color: AppColors.grey400,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.grey400,
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (q) => context.read<FlightsCubit>().searchFlights(q),
      textInputAction: TextInputAction.search,
    );
  }
}
