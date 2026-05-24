import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.background;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? const Color(0xFF263550) : AppColors.divider;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textHint = isDark ? AppColors.darkTextSecondary : AppColors.textHint;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkNavBar : bgColor,
        title: Text('Tentang Aplikasi',
            style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary)),
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // App logo & name
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.2), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.task_alt_rounded,
                    color: AppColors.primary,
                    size: 44,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('PrioriTask',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textPrimary)),
            const SizedBox(height: 4),
            Text('Versi 2.0.0 — MVP Release',
                style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Text('Student Task Manager',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gold)),
            ),
            const SizedBox(height: 32),
            // Info cards
            _buildInfoCard(
              context: context,
              cardColor: cardColor,
              dividerColor: dividerColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              title: 'Developer',
              items: [
                _InfoItem(Icons.person_rounded, 'Nama', '---'),
                _InfoItem(Icons.school_rounded, 'Institusi', 'Binus University'),
                _InfoItem(Icons.badge_rounded, 'NIM', '---'),
                _InfoItem(Icons.class_rounded, '---',
                    '---'),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context: context,
              cardColor: cardColor,
              dividerColor: dividerColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              title: 'Teknologi',
              items: [
                _InfoItem(Icons.phone_android_rounded, 'Frontend', 'Flutter'),
                _InfoItem(Icons.dns_rounded, 'Backend', 'Node.js'),
                _InfoItem(Icons.storage_rounded, 'Database', 'MySQL'),
                _InfoItem(Icons.architecture_rounded, 'Arsitektur',
                    'MVC + Provider'),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context: context,
              cardColor: cardColor,
              dividerColor: dividerColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              title: 'Fitur Utama',
              items: [
                _InfoItem(Icons.priority_high_rounded, 'Priority Scoring',
                    'Algoritma prioritas otomatis'),
                _InfoItem(Icons.track_changes_rounded, 'Progress Tracking',
                    'Lacak kemajuan per tugas'),
                _InfoItem(Icons.calendar_month_rounded, 'Calendar View',
                    'Lihat deadline di kalender'),
                _InfoItem(Icons.dark_mode_rounded, 'Dark Mode',
                    'Navy dark theme premium'),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '© 2026 PrioriTask — Dibuat dengan ❤️ untuk tugas akhir\nSoftware Architecture · Binus University',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: textHint, height: 1.6),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required Color cardColor,
    required Color dividerColor,
    required Color textPrimary,
    required Color textSecondary,
    required String title,
    required List<_InfoItem> items,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
          Divider(color: dividerColor, height: 1),
          ...items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(item.icon, color: AppColors.primary, size: 18),
                      const SizedBox(width: 12),
                      Text(item.label,
                          style: TextStyle(
                              fontSize: 13, color: textSecondary)),
                      const Spacer(),
                      Text(item.value,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textPrimary)),
                    ],
                  ),
                ),
                if (!isLast) Divider(color: dividerColor, height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem(this.icon, this.label, this.value);
}