import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/task.dart';

class NotificationCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const NotificationCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textHint = isDark ? AppColors.darkTextSecondary : AppColors.textHint;

    final days = task.daysUntilDeadline;
    final urgency = _getUrgencyLevel(days);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? urgency.color.withOpacity(0.2)
                : urgency.color.withOpacity(0.3),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: urgency.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(urgency.icon, color: urgency.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.taskName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.subjectName,
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d MMM yyyy, HH:mm').format(task.deadline),
                    style: TextStyle(fontSize: 11, color: textHint),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: urgency.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                task.isOverdue
                    ? 'Terlambat'
                    : days == 0
                        ? 'Hari ini'
                        : '$days hari',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: urgency.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _UrgencyLevel _getUrgencyLevel(int days) {
    if (days < 0) return _UrgencyLevel(AppColors.urgent, Icons.error_outline_rounded);
    if (days == 0) return _UrgencyLevel(AppColors.urgent, Icons.warning_amber_rounded);
    if (days <= 1) return _UrgencyLevel(AppColors.urgent, Icons.alarm_rounded);
    if (days <= 3) return _UrgencyLevel(AppColors.warning, Icons.schedule_rounded);
    return _UrgencyLevel(AppColors.gold, Icons.notifications_outlined);
  }
}

class _UrgencyLevel {
  final Color color;
  final IconData icon;
  _UrgencyLevel(this.color, this.icon);
}