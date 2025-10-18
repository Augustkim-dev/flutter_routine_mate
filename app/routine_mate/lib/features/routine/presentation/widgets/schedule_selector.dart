import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/animations/fade_animation.dart';

/// 루틴 일정 유형
enum ScheduleType {
  daily('매일', '매일 반복', Icons.calendar_today),
  weekdays('평일', '월-금 반복', Icons.work),
  weekend('주말', '토-일 반복', Icons.weekend),
  custom('사용자 지정', '요일 선택', Icons.tune);

  final String label;
  final String description;
  final IconData icon;

  const ScheduleType(this.label, this.description, this.icon);
}

/// 일정 선택 위젯
class ScheduleSelector extends StatelessWidget {
  final ScheduleType selectedType;
  final ValueChanged<ScheduleType> onScheduleSelected;
  final List<int>? selectedDays; // 0=일, 1=월, ..., 6=토
  final ValueChanged<List<int>>? onDaysSelected;
  final bool showAnimation;

  const ScheduleSelector({
    required this.selectedType,
    required this.onScheduleSelected,
    super.key,
    this.selectedDays,
    this.onDaysSelected,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 일정 타입 선택
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray900 : AppColors.gray50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: ScheduleType.values.map((type) {
              final isSelected = selectedType == type;
              final index = ScheduleType.values.indexOf(type);

              Widget scheduleItem = GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onScheduleSelected(type);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  margin: EdgeInsets.only(
                    bottom: index < ScheduleType.values.length - 1 ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryIndigo.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryIndigo
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        type.icon,
                        size: 24,
                        color: isSelected
                            ? AppColors.primaryIndigo
                            : (isDark
                                ? AppColors.onSurfaceVariantDark
                                : AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type.label,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: isSelected
                                    ? AppColors.primaryIndigo
                                    : (isDark
                                        ? AppColors.onSurfaceDark
                                        : AppColors.onSurface),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              type.description,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.onSurfaceVariantDark
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          size: 20,
                          color: AppColors.primaryIndigo,
                        ),
                    ],
                  ),
                ),
              );

              if (showAnimation) {
                return FadeAnimation(
                  delay: Duration(milliseconds: index * 100),
                  child: scheduleItem,
                );
              }

              return scheduleItem;
            }).toList(),
          ),
        ),

        // 사용자 지정 요일 선택 (custom 선택 시에만 표시)
        if (selectedType == ScheduleType.custom) ...[
          const SizedBox(height: 16),
          _DaySelector(
            selectedDays: selectedDays ?? [],
            onDaysSelected: onDaysSelected,
            showAnimation: showAnimation,
          ),
        ],
      ],
    );
  }
}

/// 요일 선택 위젯
class _DaySelector extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>>? onDaysSelected;
  final bool showAnimation;

  const _DaySelector({
    required this.selectedDays,
    this.onDaysSelected,
    this.showAnimation = true,
  });

  static const List<String> _dayLabels = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              '반복할 요일을 선택하세요',
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark
                    ? AppColors.onSurfaceVariantDark
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final isSelected = selectedDays.contains(index);
              final isWeekend = index == 0 || index == 6;

              Widget dayItem = GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  final newDays = List<int>.from(selectedDays);
                  if (isSelected) {
                    newDays.remove(index);
                  } else {
                    newDays.add(index);
                  }
                  newDays.sort();
                  onDaysSelected?.call(newDays);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryIndigo
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryIndigo
                          : (isDark ? AppColors.gray700 : AppColors.gray300),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _dayLabels[index],
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? Colors.white
                            : (isWeekend
                                ? (index == 0
                                    ? AppColors.error.withValues(alpha: isDark ? 0.8 : 1.0)
                                    : AppColors.primaryIndigo.withValues(alpha: isDark ? 0.8 : 1.0))
                                : (isDark
                                    ? AppColors.onSurfaceDark
                                    : AppColors.onSurface)),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );

              if (showAnimation) {
                return FadeScaleAnimation(
                  delay: Duration(milliseconds: index * 50),
                  duration: const Duration(milliseconds: 300),
                  beginScale: 0.5,
                  child: dayItem,
                );
              }

              return dayItem;
            }),
          ),
        ],
      ),
    );
  }
}

/// 일정 요약 표시 위젯
class ScheduleSummary extends StatelessWidget {
  final ScheduleType scheduleType;
  final List<int>? selectedDays;
  final bool compact;

  const ScheduleSummary({
    required this.scheduleType,
    super.key,
    this.selectedDays,
    this.compact = false,
  });

  static const List<String> _dayLabels = ['일', '월', '화', '수', '목', '금', '토'];

  String _getScheduleText() {
    switch (scheduleType) {
      case ScheduleType.daily:
        return '매일';
      case ScheduleType.weekdays:
        return '평일 (월-금)';
      case ScheduleType.weekend:
        return '주말 (토-일)';
      case ScheduleType.custom:
        if (selectedDays == null || selectedDays!.isEmpty) {
          return '요일 미선택';
        }
        if (selectedDays!.length == 7) {
          return '매일';
        }
        if (selectedDays!.length == 5 &&
            selectedDays!.every((d) => d >= 1 && d <= 5)) {
          return '평일';
        }
        if (selectedDays!.length == 2 &&
            selectedDays!.contains(0) &&
            selectedDays!.contains(6)) {
          return '주말';
        }
        return selectedDays!.map((d) => _dayLabels[d]).join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = _getScheduleText();

    if (compact) {
      return Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: isDark
              ? AppColors.onSurfaceVariantDark
              : AppColors.onSurfaceVariant,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryIndigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            scheduleType.icon,
            size: 16,
            color: AppColors.primaryIndigo,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primaryIndigo,
            ),
          ),
        ],
      ),
    );
  }
}