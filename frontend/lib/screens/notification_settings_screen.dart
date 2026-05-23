import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _deadlineReminder = true;
  bool _newTaskNotif = true;
  bool _dailyReminder = false;
  String _reminderTime = '3 jam sebelum';
  TimeOfDay _dailyTime = const TimeOfDay(hour: 8, minute: 0);

  final List<String> _reminderOptions = [
    '30 menit sebelum',
    '1 jam sebelum',
    '3 jam sebelum',
    '1 hari sebelum',
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
        title: Text('Notifikasi',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: textPrimary)),
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Pengingat Deadline', textPrimary),
            const SizedBox(height: 8),
            _buildToggleTile(
              context: context,
              cardColor: cardColor,
              dividerColor: dividerColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              icon: Icons.alarm_rounded,
              title: 'Pengingat Deadline',
              subtitle: 'Ingatkan sebelum tugas jatuh tempo',
              value: _deadlineReminder,
              onChanged: (val) => setState(() => _deadlineReminder = val),
            ),
            if (_deadlineReminder) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text('Waktu pengingat',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textPrimary)),
                    ),
                    ..._reminderOptions.map((opt) => RadioListTile<String>(
                          value: opt,
                          groupValue: _reminderTime,
                          onChanged: (val) =>
                              setState(() => _reminderTime = val!),
                          activeColor: AppColors.gold,
                          title: Text(opt,
                              style: TextStyle(
                                  fontSize: 13, color: textPrimary)),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        )),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            _buildSectionLabel('Lainnya', textPrimary),
            const SizedBox(height: 8),
            _buildToggleTile(
              context: context,
              cardColor: cardColor,
              dividerColor: dividerColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              icon: Icons.add_task_rounded,
              title: 'Tugas Baru',
              subtitle: 'Notifikasi saat tugas berhasil ditambahkan',
              value: _newTaskNotif,
              onChanged: (val) => setState(() => _newTaskNotif = val),
            ),
            const SizedBox(height: 8),
            _buildToggleTile(
              context: context,
              cardColor: cardColor,
              dividerColor: dividerColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              icon: Icons.wb_sunny_rounded,
              title: 'Reminder Harian',
              subtitle: 'Ingatkan daftar tugas setiap hari',
              value: _dailyReminder,
              onChanged: (val) => setState(() => _dailyReminder = val),
            ),
            if (_dailyReminder) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _dailyTime,
                  );
                  if (picked != null) setState(() => _dailyTime = picked);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Text('Jam pengingat',
                          style: TextStyle(
                              fontSize: 14, color: textPrimary)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _dailyTime.format(context),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pengaturan notifikasi disimpan'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Simpan Pengaturan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildToggleTile({
    required BuildContext context,
    required Color cardColor,
    required Color dividerColor,
    required Color textPrimary,
    required Color textSecondary,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dividerColor),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textPrimary)),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 12, color: textSecondary)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.gold,
        activeTrackColor: AppColors.gold.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}