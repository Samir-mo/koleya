import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const Color _primaryBlue = Color(0xFF005B8F);
  static const Color _accentGold = Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBlue,
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 375),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _SettingsButton(
                    label: "Dark mode  🌙",
                    icon: Icons.dark_mode_outlined,
                  ),
                  SizedBox(height: 16),
                  _SettingsButton(
                    label: "Language  🌐",
                    icon: Icons.language_outlined,
                  ),
                  SizedBox(height: 16),
                  _SettingsButton(
                    label: "Help & Support  🎧",
                    icon: Icons.headset_mic_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SettingsButton({
    required this.label,
    required this.icon,
  });

  static const Color _primaryBlue = Color(0xFF005B8F);
  static const Color _accentGold = Color(0xFFF3A623);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: () {
          // TODO: هنا تحط الأكشن بتاع كل زرار بعدين
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: _accentGold),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: _accentGold,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
