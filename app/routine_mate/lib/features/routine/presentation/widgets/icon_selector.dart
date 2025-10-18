import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/animations/fade_animation.dart';
import '../../../../core/animations/check_animation.dart';

/// 아이콘 선택 위젯
class IconSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIconSelected;
  final int crossAxisCount;
  final double iconSize;
  final EdgeInsets padding;
  final bool showAnimation;

  const IconSelector({
    required this.selectedIndex,
    required this.onIconSelected,
    super.key,
    this.crossAxisCount = 6,
    this.iconSize = 24,
    this.padding = const EdgeInsets.all(12),
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: AppIcons.routineIcons.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          Widget iconItem = GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onIconSelected(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    AppIcons.getRoutineIcon(index),
                    size: iconSize,
                    color: isSelected
                        ? AppColors.primaryIndigo
                        : (isDark
                            ? AppColors.onSurfaceDark.withValues(alpha: 0.7)
                            : AppColors.onSurface.withValues(alpha: 0.7)),
                  ),
                  if (isSelected)
                    const Positioned(
                      top: 4,
                      right: 4,
                      child: CheckAnimation(
                        isChecked: true,
                        color: AppColors.primaryIndigo,
                        size: 12,
                      ),
                    ),
                ],
              ),
            ),
          );

          if (showAnimation) {
            return FadeScaleAnimation(
              delay: Duration(milliseconds: index * 20),
              duration: const Duration(milliseconds: 300),
              child: iconItem,
            );
          }

          return iconItem;
        },
      ),
    );
  }
}

/// 아이콘 선택 바텀시트
class IconSelectorBottomSheet extends StatefulWidget {
  final int initialIndex;
  final String title;

  const IconSelectorBottomSheet({
    required this.initialIndex,
    super.key,
    this.title = '아이콘 선택',
  });

  @override
  State<IconSelectorBottomSheet> createState() => _IconSelectorBottomSheetState();
}

class _IconSelectorBottomSheetState extends State<IconSelectorBottomSheet> {
  late int _selectedIndex;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 핸들 바
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray700 : AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 타이틀
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.headline4.copyWith(
                    color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(_selectedIndex);
                  },
                  child: Text(
                    '선택',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primaryIndigo,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 아이콘 그리드
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 카테고리별로 그룹화 (예시)
                  _buildIconCategory('운동', 0, 6),
                  const SizedBox(height: 24),
                  _buildIconCategory('건강', 6, 6),
                  const SizedBox(height: 24),
                  _buildIconCategory('학습', 12, 6),
                  const SizedBox(height: 24),
                  _buildIconCategory('기타', 18, AppIcons.routineIcons.length - 18),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconCategory(String title, int startIndex, int count) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            color: isDark
                ? AppColors.onSurfaceVariantDark
                : AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: count.clamp(0, AppIcons.routineIcons.length - startIndex),
          itemBuilder: (context, index) {
            final iconIndex = startIndex + index;
            if (iconIndex >= AppIcons.routineIcons.length) {
              return const SizedBox();
            }

            final isSelected = _selectedIndex == iconIndex;

            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedIndex = iconIndex;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryIndigo.withValues(alpha: 0.15)
                      : (isDark ? AppColors.gray800 : AppColors.gray100),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryIndigo
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Icon(
                  AppIcons.getRoutineIcon(iconIndex),
                  size: 28,
                  color: isSelected
                      ? AppColors.primaryIndigo
                      : (isDark
                          ? AppColors.onSurfaceDark
                          : AppColors.onSurface),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}