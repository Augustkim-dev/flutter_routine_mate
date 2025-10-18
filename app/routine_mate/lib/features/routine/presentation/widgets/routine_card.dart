import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 루틴 카드 위젯
class RoutineCard extends StatefulWidget {
  final String id;
  final String name;
  final int iconIndex;
  final int colorIndex;
  final bool isCompleted;
  final int streak;
  final String? scheduleDescription;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;
  final bool isEnabled;

  const RoutineCard({
    required this.id,
    required this.name,
    required this.iconIndex,
    required this.colorIndex,
    required this.isCompleted,
    super.key,
    this.streak = 0,
    this.scheduleDescription,
    this.onTap,
    this.onLongPress,
    this.onDelete,
    this.isEnabled = true,
  });

  @override
  State<RoutineCard> createState() => _RoutineCardState();
}

class _RoutineCardState extends State<RoutineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final routineColor = AppColors.getRoutineColor(widget.colorIndex);

    Widget card = GestureDetector(
      onTapDown: widget.isEnabled ? _handleTapDown : null,
      onTapUp: widget.isEnabled ? _handleTapUp : null,
      onTapCancel: widget.isEnabled ? _handleTapCancel : null,
      onTap: widget.isEnabled
          ? () {
              HapticFeedback.lightImpact();
              widget.onTap?.call();
            }
          : null,
      onLongPress: widget.isEnabled
          ? () {
              HapticFeedback.mediumImpact();
              widget.onLongPress?.call();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isCompleted
                    ? routineColor.withValues(alpha: isDark ? 0.2 : 0.15)
                    : isDark
                        ? AppColors.surfaceDark
                        : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isCompleted
                      ? routineColor.withValues(alpha: 0.3)
                      : isDark
                          ? AppColors.gray800
                          : AppColors.gray200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 아이콘
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: routineColor.withValues(alpha: widget.isCompleted ? 1 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.getRoutineIcon(widget.iconIndex),
                      color: widget.isCompleted
                          ? Colors.white
                          : routineColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 루틴 이름, 요일 정보 및 스트릭
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: AppTextStyles.routineName.copyWith(
                            color: widget.isEnabled
                                ? (isDark
                                    ? AppColors.onSurfaceDark
                                    : AppColors.onSurface)
                                : AppColors.gray400,
                            decoration: widget.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (widget.scheduleDescription != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.scheduleDescription!,
                            style: AppTextStyles.caption.copyWith(
                              color: isDark
                                  ? AppColors.gray500
                                  : AppColors.gray600,
                            ),
                          ),
                        ],
                        if (widget.streak > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 16,
                                color: widget.streak >= 7
                                    ? Colors.orange
                                    : AppColors.gray400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.streak}일 연속',
                                style: AppTextStyles.streak.copyWith(
                                  color: widget.streak >= 7
                                      ? Colors.orange
                                      : AppColors.gray400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // 체크 표시
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isCompleted
                            ? routineColor
                            : AppColors.gray300,
                        width: 2,
                      ),
                      color: widget.isCompleted
                          ? routineColor
                          : Colors.transparent,
                    ),
                    child: widget.isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    // Slidable 적용
    if (widget.onDelete != null) {
      card = Slidable(
        key: ValueKey(widget.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {
              HapticFeedback.mediumImpact();
              widget.onDelete?.call();
            },
          ),
          children: [
            SlidableAction(
              onPressed: (_) {
                HapticFeedback.mediumImpact();
                widget.onDelete?.call();
              },
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '삭제',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ],
        ),
        child: card,
      );
    }

    return card;
  }
}