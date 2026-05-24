import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'Bagaimana cara menambahkan tugas baru?',
      'a':
          'Tekan tombol + (plus) yang ada di pojok kanan bawah halaman Home atau Tasks. Isi mata kuliah, nama tugas, tingkat kesulitan, dan deadline, lalu tekan "Tambahkan Tugas".',
    },
    {
      'q': 'Bagaimana cara mengupdate progress tugas?',
      'a':
          'Buka detail tugas dengan mengetuk kartu tugas, lalu geser slider di bagian "Update Progress" sesuai persentase yang sudah diselesaikan. Kamu juga bisa menambahkan catatan progress sebelum menyimpan.',
    },
    {
      'q': 'Apa itu Skor Prioritas?',
      'a':
          'Skor Prioritas dihitung otomatis berdasarkan tingkat kesulitan tugas dan sisa waktu menuju deadline. Semakin tinggi skornya, semakin mendesak tugas tersebut untuk dikerjakan.',
    },
    {
      'q': 'Bagaimana cara menghapus tugas?',
      'a':
          'Geser kartu tugas ke kiri (swipe left) di halaman Tasks atau Calendar untuk memunculkan tombol hapus.',
    },
    {
      'q': 'Kenapa tugas saya muncul di Notifikasi Deadline?',
      'a':
          'Tugas yang mendekati deadline (3 hari atau kurang) akan otomatis muncul di bagian Notifikasi Deadline di halaman Home sebagai pengingat.',
    },
    {
      'q': 'Bagaimana cara mengganti tampilan gelap/terang?',
      'a':
          'Masuk ke halaman Account → Pengaturan → Tampilan, lalu aktifkan atau nonaktifkan toggle Mode Gelap sesuai preferensi kamu.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.background;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? const Color(0xFF263550) : AppColors.divider;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkNavBar : bgColor,
        title: Text('Bantuan & Dukungan',
            style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary)),
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQ section
            Text('FAQ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: dividerColor),
              ),
              child: Column(
                children: _faqs.asMap().entries.map((entry) {
                  final isLast = entry.key == _faqs.length - 1;
                  final faq = entry.value;
                  return Column(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          childrenPadding: const EdgeInsets.fromLTRB(
                              16, 0, 16, 14),
                          leading: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.help_outline_rounded,
                                color: AppColors.primary, size: 16),
                          ),
                          title: Text(
                            faq['q']!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          iconColor: AppColors.primary,
                          collapsedIconColor: textSecondary,
                          children: [
                            Text(
                              faq['a']!,
                              style: TextStyle(
                                fontSize: 13,
                                color: textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast) Divider(color: dividerColor, height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Contact section
            Text('Hubungi Kami',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary)),
            const SizedBox(height: 12),
            _buildContactItem(
              context: context,
              cardColor: cardColor,
              dividerColor: dividerColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              icon: Icons.email_outlined,
              title: 'Email Developer',
              subtitle: 'lilgui@binus.ac.id',
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            _buildContactItem(
              context: context,
              cardColor: cardColor,
              dividerColor: dividerColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              icon: Icons.bug_report_outlined,
              title: 'Laporkan Bug',
              subtitle: 'Temukan masalah? Beritahu kami',
              color: AppColors.urgent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terima kasih atas laporanmu!'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required BuildContext context,
    required Color cardColor,
    required Color dividerColor,
    required Color textPrimary,
    required Color textSecondary,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dividerColor),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(fontSize: 12, color: textSecondary)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: textSecondary),
          ],
        ),
      ),
    );
  }
}