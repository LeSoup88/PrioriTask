import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/task_provider.dart';
import '../models/task.dart';
import '../widgets/priority_task_card.dart';
import '../widgets/notification_card.dart';
import 'task_detail_screen.dart';
import '../services/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, provider, _) {
            final urgentTask = provider.mostUrgentTask;
            final notifications = provider.urgentNotifications;

            return RefreshIndicator(
              onRefresh: () => provider.loadTasks(),
              color: AppColors.primary,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                      child: _buildSectionTitle(context, 'Tugas Prioritas Utama'),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: provider.isLoading
                          ? _buildLoadingCard(context)
                          : urgentTask != null
                              ? PriorityTaskCard(
                                  task: urgentTask,
                                  onTap: () => _openDetail(context, urgentTask),
                                )
                              : _buildEmptyPriority(context),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: _buildSectionTitle(context, 'Notifikasi Deadline'),
                    ),
                  ),
                  if (notifications.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildEmptyNotifications(context),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: NotificationCard(
                            task: notifications[index],
                            onTap: () => _openDetail(context, notifications[index]),
                          ),
                        ),
                        childCount: notifications.length,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final now = DateTime.now();
    final greeting = _getGreeting();
    final dateStr = DateFormat('EEE, d MMM').format(now);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Lil Gui',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  final isDark = themeProvider.isDarkMode;
                  return GestureDetector(
                    onTap: () => themeProvider.toggleTheme(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 44,
                      height: 24,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.gold.withOpacity(0.25)
                            : Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: isDark
                              ? AppColors.gold.withOpacity(0.5)
                              : AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        alignment: isDark
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.gold : AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildEmptyPriority(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline,
              size: 56, color: AppColors.success.withOpacity(0.7)),
          const SizedBox(height: 12),
          Text(
            'Tidak ada tugas aktif',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tambahkan tugas baru dengan tombol +',
            style: TextStyle(fontSize: 13, color: textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyNotifications(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final textHint = isDark ? AppColors.darkTextSecondary : AppColors.textHint;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_none_rounded, color: textHint, size: 24),
          const SizedBox(width: 12),
          Text(
            'Tidak ada notifikasi deadline mendekat',
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  void _openDetail(BuildContext context, Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
    );
  }
}