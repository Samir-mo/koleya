import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/utils/validators.dart';
import 'package:gate_buddy/core/widgets/custom_text_button.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';
import 'package:gate_buddy/features/auth/ui/widgets/auth_text_field.dart';

class EditProfileSheet extends StatefulWidget {
  final String currentName;

  const EditProfileSheet({super.key, required this.currentName});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().updateMe({'name': _nameController.text.trim()});
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pop(context);
          context.showSuccessSnackBar('profile.update_success'.tr());
        } else if (state.status == AuthStatus.error && state.error != null) {
          context.showErrorSnackBar(state.error!);
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(rw(24), rh(24), rw(24), bottom + rh(24)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('profile.edit_title'.tr(),
                      style: AppTextStyles.font18Bold.copyWith(
                          color: AppColors.primary200)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded,
                        color: AppColors.grey400),
                  ),
                ],
              ),
              verticalSpacing(24),
              AuthTextField(
                controller: _nameController,
                label: 'auth.signup.full_name'.tr(),
                prefixIcon: Icons.person_outline_rounded,
                validator: (v) => Validators.minLength(v, 3,
                    fieldName: 'auth.signup.full_name'.tr()),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onSave(),
              ),
              verticalSpacing(24),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) => CustomTextButton(
                  text: 'profile.save_changes'.tr(),
                  onPressed: state.isLoading ? null : _onSave,
                  isLoading: state.isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
