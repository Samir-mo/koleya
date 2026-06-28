import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary200,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(rr(30)),
        color: colors.surface,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'explore_places.search_placeholder'.tr(),
          hintStyle: TextStyle(
            color: colors.textHint,
            fontSize: 14,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(rw(6)),
            child: Container(
              padding: EdgeInsets.all(rw(11)),
              decoration: const BoxDecoration(
                color: AppColors.primary200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: rw(20),
            vertical: rh(14),
          ),
        ),
      ),
    );
  }
}
