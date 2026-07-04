import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/router/routes.dart';
import '../../../core/settings/cubit/app_settings_cubit.dart';
import '../../../core/settings/cubit/app_settings_state.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../core/utils/spacing.dart';
import '../../../core/widgets/ui/dialogs/app_dialogs.dart';
import '../../auth/data/models/user_model.dart';
import '../../auth/logic/cubit/auth_cubit.dart';
import '../../auth/logic/cubit/auth_state.dart';
import '../../on_boarding/ui/onboarding_screen.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/profile_app_bar.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        // While the cubit is resolving the stored token, show nothing to avoid
        // flashing the unauthenticated view momentarily.
        if (authState.status == AuthStatus.loading ||
            authState.status == AuthStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!authState.isAuthenticated || user == null) {
          return OnboardingScreen();
        }

        return _ProfileView(user: user);
      },
    );
  }
}

class _ProfileView extends StatelessWidget {
  final UserModel user;
  const _ProfileView({required this.user});

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.customColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: EditProfileSheet(currentName: user.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileAppBar(
              title: 'profile.title'.tr(),
              showEdit: true,
              onEdit: () => _showEditSheet(context),
            ),
          ),

          // ── Header Card ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _HeaderCard(
              user: user,
              onEdit: () => _showEditSheet(context),
            ),
          ),

          // ── Sections ─────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(rw(16), 0, rw(16), rh(24)),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                verticalSpacing(20),
                // Account
                ProfileSection(
                  title: 'profile.account'.tr(),
                  children: [
                    ProfileTile(
                      icon: Icons.person_outline_rounded,
                      label: 'profile.edit_name'.tr(),
                      value: user.name,
                      iconColor: AppColors.primary200,
                      onTap: () => _showEditSheet(context),
                    ),
                    ProfileTile(
                      icon: Icons.email_outlined,
                      label: 'profile.email'.tr(),
                      value: user.email,
                      iconColor: AppColors.blue200,
                    ),
                    ProfileTile(
                      icon: Icons.lock_outline_rounded,
                      label: 'profile.change_password'.tr(),
                      iconColor: AppColors.amber200,
                      onTap: () => context.pushNamed(Routes.forgetPassword),
                    ),
                  ],
                ),
                verticalSpacing(20),

                // Preferences
                _PreferencesSection(),
                verticalSpacing(20),

                // Support
                ProfileSection(
                  title: 'profile.support'.tr(),
                  children: [
                    ProfileTile(
                      icon: Icons.info_outline_rounded,
                      label: 'profile.about'.tr(),
                      iconColor: AppColors.primary200,
                      onTap: () => _showAboutDialog(context),
                    ),
                    ProfileTile(
                      icon: Icons.privacy_tip_outlined,
                      label: 'profile.privacy_policy'.tr(),
                      iconColor: AppColors.grey400,
                    ),
                    ProfileTile(
                      icon: Icons.description_outlined,
                      label: 'profile.terms_of_service'.tr(),
                      iconColor: AppColors.grey400,
                    ),
                  ],
                ),
                verticalSpacing(20),

                // ── Account actions ───────────────────────────────────────
                _AccountActionsSection(context: context),
                verticalSpacing(16),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    AppDialogs.showInfo(
      context,
      title: 'profile.about_title'.tr(),
      message: 'profile.about_message'.tr(),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;

  const _HeaderCard({required this.user, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary200, AppColors.primary300],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(rr(32)),
          bottomRight: Radius.circular(rr(32)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(rw(24), rh(8), rw(24), rh(32)),
      child: Column(
        children: [
          Stack(
            children: [
              ProfileAvatar(photoUrl: user.photo, name: user.name, radius: 48),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: rw(30),
                    height: rw(30),
                    decoration: const BoxDecoration(
                      color: AppColors.secondary200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: rr(14),
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          verticalSpacing(14),
          Text(
            user.name,
            style: AppTextStyles.font20Bold.copyWith(color: AppColors.white),
          ),
          verticalSpacing(4),
          Text(
            user.email,
            style: AppTextStyles.font14Regular.copyWith(
              color: AppColors.primary50,
            ),
          ),
          verticalSpacing(16),
          _StatsRow(),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(20), vertical: rh(12)),
      decoration: BoxDecoration(
        color: AppColors.primary300,
        borderRadius: BorderRadius.circular(rr(14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            label: 'profile.stat_tracked'.tr(),
            value: '—',
            icon: Icons.bookmark_rounded,
          ),
          _VerticalDivider(),
          _StatItem(
            label: 'profile.stat_flights'.tr(),
            value: '—',
            icon: Icons.flight_rounded,
          ),
          _VerticalDivider(),
          _StatItem(
            label: 'profile.stat_alerts'.tr(),
            value: '—',
            icon: Icons.notifications_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.secondary200, size: rr(18)),
        verticalSpacing(4),
        Text(
          value,
          style: AppTextStyles.font16Bold.copyWith(color: AppColors.white),
        ),
        Text(
          label,
          style: AppTextStyles.font12Regular.copyWith(
            color: AppColors.primary50,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: rh(40), color: AppColors.primary200);
  }
}

class _PreferencesSection extends StatelessWidget {
  String _getLanguageName(String languageCode) {
    return switch (languageCode) {
      'en' => 'profile.language_english'.tr(),
      'ar' => 'profile.language_arabic'.tr(),
      'es' => 'Español',
      'ru' => 'Русский',
      _ => 'profile.language_english'.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settings) {
        final cubit = context.read<AppSettingsCubit>();
        final isDark = settings.themeMode == ThemeMode.dark;

        return ProfileSection(
          title: 'profile.preferences'.tr(),
          children: [
            ProfileTile(
              icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              label: 'profile.dark_mode'.tr(),
              iconColor: isDark ? AppColors.grey700 : AppColors.amber200,
              trailing: Switch(
                value: isDark,
                onChanged: (_) => cubit.toggleTheme(),
                activeThumbColor: AppColors.primary200,
                activeTrackColor: AppColors.primary100,
              ),
            ),
            ProfileTile(
              icon: Icons.language_rounded,
              label: 'profile.language'.tr(),
              value: _getLanguageName(settings.locale.languageCode),
              iconColor: AppColors.blue200,
              trailing: _LanguageSelector(
                currentLocale: settings.locale,
                onLanguageSelected: (locale) =>
                    cubit.updateLocale(context, locale),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final Function(Locale) onLanguageSelected;

  const _LanguageSelector({
    required this.currentLocale,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLanguageModal(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(5)),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(rr(8)),
        ),
        child: Text(
          currentLocale.languageCode.toUpperCase(),
          style: AppTextStyles.font12Medium.copyWith(
            color: AppColors.primary200,
          ),
        ),
      ),
    );
  }

  void _showLanguageModal(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'ar', 'name': 'العربية'},
      {'code': 'es', 'name': 'Español'},
      {'code': 'ru', 'name': 'Русский'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: context.customColors.surface,
      builder: (context) {
        final colors = context.customColors;
        return Padding(
          padding: EdgeInsets.all(rw(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'profile.language'.tr(),
                style: AppTextStyles.font16Bold.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              verticalSpacing(16),
              ...languages.map((lang) {
                final isSelected = currentLocale.languageCode == lang['code'];
                return GestureDetector(
                  onTap: () {
                    onLanguageSelected(Locale(lang['code']!));
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: rw(16),
                      vertical: rh(14),
                    ),
                    margin: EdgeInsets.only(bottom: rh(8)),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary200.withValues(alpha: 0.1)
                          : colors.surface,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary200
                            : colors.border,
                      ),
                      borderRadius: BorderRadius.circular(rr(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang['name']!,
                          style: AppTextStyles.font14SemiBold.copyWith(
                            color: isSelected
                                ? AppColors.primary200
                                : colors.textPrimary,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_rounded,
                            color: AppColors.primary200,
                            size: rw(20),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              verticalSpacing(8),
            ],
          ),
        );
      },
    );
  }
}

// ── Account Actions Section ───────────────────────────────────────────────────

class _AccountActionsSection extends StatelessWidget {
  final BuildContext context;
  const _AccountActionsSection({required this.context});

  @override
  Widget build(BuildContext ctx) {
    final colors = ctx.customColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(rr(16)),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.logout_rounded,
            label: 'profile.logout'.tr(),
            color: AppColors.amber200,
            onTap: () => AppDialogs.showConfirm(
              context,
              title: 'profile.logout_confirmation_title'.tr(),
              message: 'profile.logout_confirmation_message'.tr(),
              confirmText: 'profile.logout'.tr(),
              onConfirm: () => context.read<AuthCubit>().logout(),
            ),
          ),
          Divider(height: 1, color: colors.border),
          _ActionTile(
            icon: Icons.delete_forever_rounded,
            label: 'profile.delete_account'.tr(),
            color: AppColors.red200,
            onTap: () => AppDialogs.showConfirm(
              context,
              title: 'profile.delete_account_confirmation_title'.tr(),
              message: 'profile.delete_account_confirmation_message'.tr(),
              confirmText: 'profile.delete_account'.tr(),
              onConfirm: () => context.read<AuthCubit>().deleteAccount(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(rr(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(16)),
          child: Row(
            children: [
              Container(
                width: rw(38),
                height: rw(38),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(rr(10)),
                ),
                child: Icon(icon, color: color, size: rr(18)),
              ),
              horizontalSpacing(14),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.font14SemiBold.copyWith(color: color),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: rr(14),
                color: color.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
