import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textHint = isDark ? AppColors.darkTextSecondary : AppColors.textHint;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Profil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile_picture.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.person_rounded,
                            size: 44,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Lil Gui',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'lilgui@binus.ac.id',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Teknik Informatika - 2024',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, 'NIM', '2210511001', Icons.badge_outlined)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(context, 'Semester', '6', Icons.school_outlined)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, 'IPK', '3.75', Icons.star_outline_rounded)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(context, 'SKS', '128', Icons.book_outlined)),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingsItem(context, Icons.notifications_outlined, 'Notifikasi', () {}),
              _buildSettingsItem(context, Icons.lock_outline_rounded, 'Keamanan Akun', () {}),
              _buildSettingsItem(context, Icons.help_outline_rounded, 'Bantuan & Dukungan', () {}),
              _buildSettingsItem(context, Icons.info_outline_rounded, 'Tentang Aplikasi', () {}),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    'Keluar',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.urgent.withOpacity(0.1),
                    foregroundColor: AppColors.urgent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (states) {
                        if (states.contains(WidgetState.pressed) ||
                            states.contains(WidgetState.hovered)) {
                          return AppColors.urgent;
                        }
                        return AppColors.urgent.withOpacity(0.1);
                      },
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>(
                      (states) {
                        if (states.contains(WidgetState.pressed) ||
                            states.contains(WidgetState.hovered)) {
                          return Colors.white;
                        }
                        return AppColors.urgent;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'PrioriTask v2.0.0 - MVP',
                  style: TextStyle(fontSize: 11, color: textHint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textHint = isDark ? AppColors.darkTextSecondary : AppColors.textHint;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dividerColor),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: textHint, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}