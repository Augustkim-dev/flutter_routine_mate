import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/animations/fade_animation.dart';

/// 연속 달성 배지
class StreakBadge extends StatelessWidget {
  final int streak;
  final StreakBadgeSize size;
  final bool showFlame;
  final bool animated;

  const StreakBadge({
    required this.streak,
    super.key,
    this.size = StreakBadgeSize.medium,
    this.showFlame = true,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    if (streak <= 0) {
      return const SizedBox.shrink();
    }

    final color = _getStreakColor(streak);

    Widget badge = Container(
      padding: size.padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size.borderRadius),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showFlame)
            Icon(
              _getStreakIcon(streak),
              size: size.iconSize,
              color: Colors.white,
            ),
          if (showFlame) SizedBox(width: size.spacing),
          Text(
            _getStreakText(streak),
            style: size.textStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    if (animated && streak > 0) {
      return PulseFadeAnimation(
        minOpacity: 0.8,
        maxOpacity: 1.0,
        duration: const Duration(seconds: 2),
        child: badge,
      );
    }

    return badge;
  }

  Color _getStreakColor(int streak) {
    if (streak >= 30) {
      return const Color(0xFFFFD700); // Gold
    } else if (streak >= 14) {
      return const Color(0xFFC0C0C0); // Silver
    } else if (streak >= 7) {
      return const Color(0xFFCD7F32); // Bronze
    } else if (streak >= 3) {
      return AppColors.primaryIndigo;
    } else {
      return AppColors.success;
    }
  }

  IconData _getStreakIcon(int streak) {
    if (streak >= 30) {
      return Icons.local_fire_department; // 불꽃
    } else if (streak >= 14) {
      return Icons.star; // 별
    } else if (streak >= 7) {
      return Icons.emoji_events; // 트로피
    } else if (streak >= 3) {
      return Icons.trending_up; // 상승 화살표
    } else {
      return Icons.check_circle; // 체크
    }
  }

  String _getStreakText(int streak) {
    if (streak >= 100) {
      return '$streak일 🔥';
    } else if (streak >= 30) {
      return '$streak일 연속!';
    } else {
      return '$streak일';
    }
  }
}

/// 연속 달성 배지 크기
enum StreakBadgeSize {
  small(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    borderRadius: 4,
    iconSize: 12,
    spacing: 2,
    textStyle: AppTextStyles.captionSmall,
  ),
  medium(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    borderRadius: 6,
    iconSize: 14,
    spacing: 4,
    textStyle: AppTextStyles.captionMedium,
  ),
  large(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    borderRadius: 8,
    iconSize: 18,
    spacing: 6,
    textStyle: AppTextStyles.bodySmall,
  );

  final EdgeInsets padding;
  final double borderRadius;
  final double iconSize;
  final double spacing;
  final TextStyle textStyle;

  const StreakBadgeSize({
    required this.padding,
    required this.borderRadius,
    required this.iconSize,
    required this.spacing,
    required this.textStyle,
  });
}

/// 확장된 연속 달성 표시
class StreakDisplay extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastCompleted;

  const StreakDisplay({
    required this.currentStreak,
    required this.bestStreak,
    super.key,
    this.lastCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StreakStat(
                icon: Icons.local_fire_department,
                label: '현재 연속',
                value: currentStreak.toString(),
                color: _getColor(currentStreak),
              ),
              Container(
                width: 1,
                height: 40,
                color: isDark ? AppColors.gray700 : AppColors.gray200,
              ),
              _StreakStat(
                icon: Icons.emoji_events,
                label: '최고 기록',
                value: bestStreak.toString(),
                color: AppColors.gold,
              ),
            ],
          ),
          if (lastCompleted != null) ...[
            const SizedBox(height: 12),
            Divider(
              color: isDark ? AppColors.gray700 : AppColors.gray200,
            ),
            const SizedBox(height: 8),
            Text(
              '마지막 완료: ${_formatDate(lastCompleted!)}',
              style: AppTextStyles.captionMedium.copyWith(
                color: isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getColor(int streak) {
    if (streak >= 30) return AppColors.gold;
    if (streak >= 14) return AppColors.silver;
    if (streak >= 7) return AppColors.bronze;
    if (streak >= 3) return AppColors.primaryIndigo;
    return AppColors.success;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '오늘';
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${date.month}월 ${date.day}일';
    }
  }
}

/// 연속 달성 통계 아이템
class _StreakStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StreakStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headline4.copyWith(
            color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.captionMedium.copyWith(
            color: isDark
                ? AppColors.onSurfaceVariantDark
                : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// 연속 달성 마일스톤 배지
class StreakMilestone extends StatelessWidget {
  final int milestone;
  final bool achieved;
  final VoidCallback? onTap;

  const StreakMilestone({
    required this.milestone,
    required this.achieved,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _getMilestoneColor();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: achieved
              ? color.withValues(alpha: 0.1)
              : (isDark ? AppColors.gray900 : AppColors.gray50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: achieved
                ? color
                : (isDark ? AppColors.gray700 : AppColors.gray300),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getMilestoneIcon(),
              size: 32,
              color: achieved
                  ? color
                  : (isDark ? AppColors.gray600 : AppColors.gray400),
            ),
            const SizedBox(height: 8),
            Text(
              '$milestone일',
              style: AppTextStyles.labelLarge.copyWith(
                color: achieved
                    ? color
                    : (isDark
                        ? AppColors.onSurfaceVariantDark
                        : AppColors.onSurfaceVariant),
                fontWeight: achieved ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMilestoneColor() {
    if (milestone >= 100) return AppColors.diamond;
    if (milestone >= 30) return AppColors.gold;
    if (milestone >= 14) return AppColors.silver;
    if (milestone >= 7) return AppColors.bronze;
    return AppColors.primaryIndigo;
  }

  IconData _getMilestoneIcon() {
    if (milestone >= 100) return Icons.diamond;
    if (milestone >= 30) return Icons.military_tech;
    if (milestone >= 14) return Icons.star;
    if (milestone >= 7) return Icons.emoji_events;
    return Icons.check_circle;
  }
}