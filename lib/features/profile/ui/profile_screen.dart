import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/core/settings/cubit/app_settings_cubit.dart';
import 'package:gate_buddy/core/settings/cubit/app_settings_state.dart';
import 'package:gate_buddy/core/themes/app_colors.dart';
import 'package:gate_buddy/core/themes/app_text_styles.dart';
import 'package:gate_buddy/core/utils/extensions/context_ext.dart';
import 'package:gate_buddy/core/utils/spacing.dart';
import 'package:gate_buddy/core/widgets/ui/dialogs/app_dialogs.dart';
import 'package:gate_buddy/features/auth/data/models/user_model.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_cubit.dart';
import 'package:gate_buddy/features/auth/logic/cubit/auth_state.dart';
import 'package:gate_buddy/features/profile/ui/widgets/edit_profile_sheet.dart';
import 'package:gate_buddy/features/profile/ui/widgets/profile_avatar.dart';
import 'package:gate_buddy/features/profile/ui/widgets/profile_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        if (!authState.isAuthenticated || user == null) {
          return _UnauthenticatedView();
        }

        return _ProfileView(user: user);
      },
    );
  }
}

// ── Unauthenticated ───────────────────────────────────────────────────────────

class _UnauthenticatedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          _ProfileAppBar(
              title: 'profile.title'.tr(), top: top, showEdit: false),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: rw(80),
                    height: rh(80),
                    decoration: const BoxDecoration(
                      color: AppColors.primary50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_off_outlined,
                        color: AppColors.primary200, size: 40),
                  ),
                  verticalSpacing(20),
                  Text('profile.unauthenticated_title'.tr(),
                      style: AppTextStyles.font18Bold.copyWith(
                          color: AppColors.primary200)),
                  verticalSpacing(8),
                  Text('profile.unauthenticated_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font14Regular.copyWith(
                          color: colors.textSecondary)),
                  verticalSpacing(32),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: rw(40)),
                    child: SizedBox(
                      width: double.infinity,
                      height: rh(52),
                      child: ElevatedButton(
                        onPressed: () =>
                            context.pushNamed(Routes.login),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary200,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(rr(14))),
                        ),
                        child: Text('profile.login_button'.tr(),
                            style: AppTextStyles.font16SemiBold.copyWith(
                                color: AppColors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Authenticated ─────────────────────────────────────────────────────────────

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

  void _showLogoutDialog(BuildContext context) {
    AppDialogs.showConfirm(
      context,
      title: 'profile.logout_title'.tr(),
      message: 'profile.logout_message'.tr(),
      confirmText: 'common.yes'.tr(),
      cancelText: 'common.no'.tr(),
      onConfirm: () => context.read<AuthCubit>().logout(),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    AppDialogs.showWarning(
      context,
      message: 'profile.delete_account_message'.tr(),
      onPressed: () => context.read<AuthCubit>().deleteAccount(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _ProfileAppBar(
              title: 'My Profile',
              top: top,
              showEdit: true,
              onEdit: () => _showEditSheet(context),
            ),
          ),

          // ── Header Card ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _HeaderCard(user: user, onEdit: () => _showEditSheet(context)),
          ),

          // ── Sections ─────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Account
                ProfileSection(
                  title: 'Account',
                  children: [
                    ProfileTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Edit Name',
                      value: user.name,
                      iconColor: AppColors.primary200,
                      onTap: () => _showEditSheet(context),
                    ),
                    ProfileTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user.email,
                      iconColor: AppColors.blue200,
                    ),
                    ProfileTile(
                      icon: Icons.lock_outline_rounded,
                      label: 'Change Password',
                      iconColor: AppColors.amber200,
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.forgetPassword),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Preferences
                _PreferencesSection(),
                const SizedBox(height: 20),

                // Tracked Flights shortcut
                ProfileSection(
                  title: 'Activity',
                  children: [
                    ProfileTile(
                      icon: Icons.bookmark_outline_rounded,
                      label: 'Tracked Flights',
                      iconColor: AppColors.secondary200,
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.trackedFlight),
                    ),
                    ProfileTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      iconColor: AppColors.green200,
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.notifications),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Support
                ProfileSection(
                  title: 'Support',
                  children: [
                    ProfileTile(
                      icon: Icons.info_outline_rounded,
                      label: 'About GateBuddy',
                      iconColor: AppColors.primary200,
                      onTap: () => _showAboutDialog(context),
                    ),
                    ProfileTile(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      iconColor: AppColors.grey400,
                    ),
                    ProfileTile(
                      icon: Icons.description_outlined,
                      label: 'Terms of Service',
                      iconColor: AppColors.grey400,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Actions
                _LogoutButton(onTap: () => _showLogoutDialog(context)),
                const SizedBox(height: 12),
                _DeleteButton(onTap: () => _showDeleteDialog(context)),
                const SizedBox(height: 32),
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

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _ProfileAppBar extends StatelessWidget {
  final String title;
  final double top;
  final bool showEdit;
  final VoidCallback? onEdit;

  const _ProfileAppBar({
    required this.title,
    required this.top,
    required this.showEdit,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary200,
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 14),
      child: Row(
        children: [
          Text(title,
              style: AppTextStyles.font20Bold.copyWith(
                  color: AppColors.white)),
          const Spacer(),
          if (showEdit)
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit_outlined,
                        size: 14, color: AppColors.secondary200),
                    const SizedBox(width: 4),
                    Text('Edit',
                        style: AppTextStyles.font12Medium.copyWith(
                            color: AppColors.secondary200)),
                  ],
                ),
              ),
            ),
        ],
      ),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary200, AppColors.primary300],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        children: [
          Stack(
            children: [
              ProfileAvatar(
                photoUrl: user.photo,
                name: user.name,
                radius: 48,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded,
                        size: 14, color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            user.name,
            style:
                AppTextStyles.font20Bold.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: AppTextStyles.font14Regular.copyWith(
                color: AppColors.primary50),
          ),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary300,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(label: 'Tracked', value: '—', icon: Icons.bookmark_rounded),
          _VerticalDivider(),
          _StatItem(label: 'Flights', value: '—', icon: Icons.flight_rounded),
          _VerticalDivider(),
          _StatItem(label: 'Alerts', value: '—',
              icon: Icons.notifications_rounded),
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
        Icon(icon, color: AppColors.secondary200, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.font16Bold.copyWith(
                color: AppColors.white)),
        Text(label,
            style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.primary50)),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.primary200);
  }
}

class _PreferencesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settings) {
        final cubit = context.read<AppSettingsCubit>();
        final isDark = settings.themeMode == ThemeMode.dark;

        return ProfileSection(
          title: 'Preferences',
          children: [
            ProfileTile(
              icon: isDark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              label: 'Dark Mode',
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
              label: 'Language',
              value: settings.isArabic ? 'Arabic' : 'English',
              iconColor: AppColors.blue200,
              trailing: _LanguageToggle(
                isArabic: settings.isArabic,
                onToggle: () => cubit.toggleLocale(context),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onToggle;

  const _LanguageToggle({required this.isArabic, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isArabic ? 'AR → EN' : 'EN → AR',
          style: AppTextStyles.font12Medium.copyWith(
              color: AppColors.primary200),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary200,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        icon: const Icon(Icons.logout_rounded,
            color: AppColors.white, size: 18),
        label: Text('Log Out',
            style: AppTextStyles.font16SemiBold.copyWith(
                color: AppColors.white)),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DeleteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red200,
          side: const BorderSide(color: AppColors.red200),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.delete_outline_rounded, size: 18),
        label: Text('Delete Account',
            style: AppTextStyles.font16SemiBold.copyWith(
                color: AppColors.red200)),
      ),
    );
  }
}
