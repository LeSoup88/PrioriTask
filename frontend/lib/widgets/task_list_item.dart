import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../theme/app_theme.dart';
import '../models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textHint = isDark ? AppColors.darkTextSecondary : AppColors.textHint;
    final dividerColor = isDark ? const Color(0xFF263550) : AppColors.divider;
    final diffColor = _difficultyColor(task.difficulty);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.urgent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: AppColors.urgent, size: 26),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: task.isCompleted
                ? cardColor.withOpacity(0.7)
                : cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: task.isOverdue
                  ? AppColors.urgent.withOpacity(0.3)
                  : dividerColor,
            ),
            boxShadow: [
              if (!task.isCompleted && !isDark)
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 70,
                decoration: BoxDecoration(
                  color: task.isCompleted ? AppColors.success : diffColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            task.subjectName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: task.isCompleted
                                  ? textHint
                                  : AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (task.isCompleted)
                          const Icon(Icons.check_circle_rounded,
                              size: 18, color: AppColors.success)
                        else if (task.isOverdue)
                          const Icon(Icons.error_outline_rounded,
                              size: 18, color: AppColors.urgent),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.taskName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: task.isCompleted
                            ? textSecondary
                            : textPrimary,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 12, color: textHint),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('d MMM yyyy').format(task.deadline),
                          style: TextStyle(
                            fontSize: 11,
                            color: task.isOverdue && !task.isCompleted
                                ? AppColors.urgent
                                : textHint,
                            fontWeight: task.isOverdue && !task.isCompleted
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        if (!task.isCompleted) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: diffColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _difficultyLabel(task.difficulty),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: diffColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (!task.isCompleted) ...[
                      const SizedBox(height: 10),
                      LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        lineHeight: 5,
                        percent: task.progressPercent / 100,
                        backgroundColor: isDark ? const Color(0xFF2A3F60) : AppColors.divider,
                        progressColor: task.isOverdue
                            ? AppColors.urgent
                            : AppColors.primary,
                        barRadius: const Radius.circular(4),
                        animation: true,
                      ),
                    ],
                  ],
                ),
              ),
              if (!task.isCompleted && task.priorityScore != null) ...[
                const SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.priorityScore!.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'skor',
                      style: TextStyle(fontSize: 9, color: textHint),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _difficultyColor(String d) {
    switch (d) {
      case 'easy': return AppColors.easy;
      case 'hard': return AppColors.hard;
      default: return AppColors.medium;
    }
  }

  String _difficultyLabel(String d) {
    switch (d) {
      case 'easy': return 'Mudah';
      case 'hard': return 'Sulit';
      default: return 'Sedang';
    }
  }
}