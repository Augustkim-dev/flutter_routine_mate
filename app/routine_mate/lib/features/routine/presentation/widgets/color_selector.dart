import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/animations/fade_animation.dart';

/// 색상 선택 위젯
class ColorSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;
  final double itemSize;
  final EdgeInsets padding;
  final bool showAnimation;

  const ColorSelector({
    required this.selectedIndex,
    required this.onColorSelected,
    super.key,
    this.itemSize = 36,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(AppColors.routineColors.length, (index) {
          final color = AppColors.getRoutineColor(index);
          final isSelected = selectedIndex == index;

          Widget colorItem = GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onColorSelected(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: itemSize,
              height: itemSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryIndigo
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          );

          if (showAnimation) {
            return FadeScaleAnimation(
              delay: Duration(milliseconds: index * 50),
              duration: const Duration(milliseconds: 300),
              beginScale: 0.5,
              child: colorItem,
            );
          }

          return colorItem;
        }),
      ),
    );
  }
}

/// 확장된 색상 선택 위젯 (더 많은 색상 옵션)
class ExtendedColorSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;
  final List<Color> colors;
  final double itemSize;
  final int crossAxisCount;
  final EdgeInsets padding;

  const ExtendedColorSelector({
    required this.selectedIndex,
    required this.onColorSelected,
    required this.colors,
    super.key,
    this.itemSize = 48,
    this.crossAxisCount = 5,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.gray50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onColorSelected(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? isDark
                          ? Colors.white
                          : Colors.black
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      color: color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      size: 24,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

/// 색상 선택 바텀시트
class ColorSelectorBottomSheet extends StatefulWidget {
  final int initialIndex;
  final String title;
  final bool showExtended;

  const ColorSelectorBottomSheet({
    required this.initialIndex,
    super.key,
    this.title = '색상 선택',
    this.showExtended = false,
  });

  @override
  State<ColorSelectorBottomSheet> createState() => _ColorSelectorBottomSheetState();
}

class _ColorSelectorBottomSheetState extends State<ColorSelectorBottomSheet> {
  late int _selectedIndex;
  late List<Color> _allColors;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    // 확장 모드일 경우 더 많은 색상 제공
    if (widget.showExtended) {
      _allColors = [
        ...AppColors.routineColors,
        // 추가 색상들
        const Color(0xFFEC4899), // Pink
        const Color(0xFFF59E0B), // Amber
        const Color(0xFF84CC16), // Lime
        const Color(0xFF06B6D4), // Cyan
        const Color(0xFF8B5CF6), // Violet
        const Color(0xFFF43F5E), // Rose
        const Color(0xFF0EA5E9), // Sky
        const Color(0xFFA855F7), // Purple
        const Color(0xFFEAB308), // Yellow
        const Color(0xFF14B8A6), // Teal
        const Color(0xFF64748B), // Slate
        const Color(0xFF71717A), // Zinc
      ];
    } else {
      _allColors = AppColors.routineColors;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: widget.showExtended
          ? MediaQuery.of(context).size.height * 0.5
          : MediaQuery.of(context).size.height * 0.3,
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

          // 색상 선택
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: widget.showExtended
                  ? ExtendedColorSelector(
                      selectedIndex: _selectedIndex,
                      onColorSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      colors: _allColors,
                    )
                  : ColorSelector(
                      selectedIndex: _selectedIndex,
                      onColorSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 색상 프리뷰 위젯
class ColorPreview extends StatelessWidget {
  final Color color;
  final double size;
  final bool showBorder;

  const ColorPreview({
    required this.color,
    super.key,
    this.size = 24,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: isDark
                    ? AppColors.gray700
                    : AppColors.gray300,
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}