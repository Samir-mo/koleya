import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/utils/extensions/context_ext.dart';
import '../../../../core/utils/spacing.dart';
import '../../logic/cubit/flights_cubit.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  const SearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return TextField(
      controller: controller,
      autofocus: true,
      style: AppTextStyles.font14Regular.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: 'flights.search_placeholder'.tr(),
        hintStyle: AppTextStyles.font14Regular.copyWith(color: colors.textHint),
        prefixIcon: Icon(Icons.search, color: colors.textHint, size: 20),
        filled: true,
        fillColor: colors.surface,
        contentPadding: EdgeInsets.symmetric(vertical: rh(10)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rr(12)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rr(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(rr(12)),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (q) => context.read<FlightsCubit>().searchFlights(q),
      textInputAction: TextInputAction.search,
    );
  }
}
