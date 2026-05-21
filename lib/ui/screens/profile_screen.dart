import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gate_buddy/core/router/routes.dart';
import 'package:gate_buddy/data/storage/auth_storage.dart';
import 'package:gate_buddy/data/storage/current_user.dart';
import 'package:gate_buddy/ui/screens/settings_screen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _localImage;
  late final TextEditingController _nameController;

  static const Color _primaryBlue = Color(0xFF005B8F);
  static const Color _accentGold = Color(0xFFF3A623);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: CurrentUser.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _localImage = File(picked.path));
    }
  }

  Future<void> _confirmLogout() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تسجيل خروج'),
        content: const Text('هل أنت متأكد إنك عايز تسجل خروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'تسجيل خروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (sure != true) return;

    await AuthStorage.clearAuth();
    CurrentUser.clear();

    if (!mounted) return;

    // Important: Use pushNamedAndRemoveUntil to clear everything
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CurrentUser.listenable,
      builder: (context, _, __) {
        final currentName = CurrentUser.name ?? 'User name';

        // Sync controller if CurrentUser changes externally
        if (_nameController.text != (CurrentUser.name ?? '')) {
          _nameController.text = CurrentUser.name ?? '';
        }

        final email = CurrentUser.email ?? 'user@example.com';

        return Scaffold(
          backgroundColor: _primaryBlue,
          appBar: AppBar(
            backgroundColor: _primaryBlue,
            elevation: 0,
            // REMOVED the back button - very important for bottom nav tabs!
            // leading: IconButton(...),   ← Delete this
            centerTitle: true,
            title: const Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 375),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                          child: Column(
                            children: [
                              // Profile Picture
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 48,
                                      backgroundColor: Colors.grey.shade300,
                                      backgroundImage: _localImage != null
                                          ? FileImage(_localImage!)
                                          : (CurrentUser.image?.isNotEmpty ==
                                                true)
                                          ? NetworkImage(CurrentUser.image!)
                                                as ImageProvider
                                          : const AssetImage(
                                              'assets/images/6.png',
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: _accentGold,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),
                              Text(
                                currentName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: _primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _accentGold,
                                ),
                              ),

                              const SizedBox(height: 24),

                              _ProfileActionButton(
                                icon: Icons.flight_takeoff_outlined,
                                label: 'Tracked Flight',
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  Routes.trackedFlight,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _ProfileActionButton(
                                icon: Icons.local_parking_outlined,
                                label: 'Saved parking',
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  Routes.indoorMap,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _ProfileActionButton(
                                icon: Icons.settings_outlined,
                                label: 'Settings',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SettingsScreen(),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 32),

                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Account info',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _primaryBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Full name',
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              TextField(
                                readOnly: true,
                                controller: TextEditingController(text: email),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Save Changes Button
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    CurrentUser.setUser(
                                      id: CurrentUser.id,
                                      name: _nameController.text.trim(),
                                      email: CurrentUser.email,
                                      image: CurrentUser.image,
                                      token: CurrentUser.token,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Changes saved locally 😉',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _primaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Save changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Logout Button
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: ElevatedButton.icon(
                                  onPressed: _confirmLogout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Log out',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Keep your _ProfileActionButton as is (it's fine)
class _ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ProfileActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  static const Color _primaryBlue = Color(0xFF005B8F);
  static const Color _accentGold = Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, color: _accentGold, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            color: _accentGold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
