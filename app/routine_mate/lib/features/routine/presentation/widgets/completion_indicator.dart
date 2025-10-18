import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 완료율 표시 인디케이터
class CompletionIndicator extends StatelessWidget {
  final double percentage;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final TextStyle? percentageStyle;

  const CompletionIndicator({
    required this.percentage,
    super.key,
    this.size = 60,
    this.strokeWidth = 4,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = true,
    this.percentageStyle,
  }) : assert(percentage >= 0 && percentage <= 100);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.gray800 : AppColors.gray200);
    final progressClr = progressColor ?? AppColors.primaryIndigo;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // 배경 원
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: 1.0,
              strokeWidth: strokeWidth,
              color: bgColor,
            ),
          ),
          // 진행률 원
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: percentage / 100,
              strokeWidth: strokeWidth,
              color: progressClr,
            ),
          ),
          // 퍼센트 텍스트
          if (showPercentage)
            Center(
              child: Text(
                '${percentage.toInt()}%',
                style: percentageStyle ??
                    AppTextStyles.percentage.copyWith(
                      color: progressClr,
                      fontSize: size * 0.2,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 원형 프로그레스 페인터
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 시작 위치는 위쪽 (-π/2)
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color;
  }
}

/// 선형 진행률 표시기
class LinearCompletionIndicator extends StatelessWidget {
  final double percentage;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadius? borderRadius;
  final bool showLabel;
  final String? label;

  const LinearCompletionIndicator({
    required this.percentage,
    super.key,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
    this.showLabel = false,
    this.label,
  }) : assert(percentage >= 0 && percentage <= 100);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.gray800 : AppColors.gray200);
    final progressClr = progressColor ?? AppColors.primaryIndigo;
    final radius = borderRadius ?? BorderRadius.circular(height / 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '${percentage.toInt()}%',
                style: AppTextStyles.labelMedium.copyWith(
                  color: progressClr,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * (percentage / 100),
                    height: height,
                    decoration: BoxDecoration(
                      color: progressClr,
                      borderRadius: radius,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 완료 개수 표시기
class CompletionCountIndicator extends StatelessWidget {
  final int completed;
  final int total;
  final double iconSize;
  final Color? completedColor;
  final Color? remainingColor;
  final bool showNumbers;

  const CompletionCountIndicator({
    required this.completed,
    required this.total,
    super.key,
    this.iconSize = 24,
    this.completedColor,
    this.remainingColor,
    this.showNumbers = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final completedClr = completedColor ?? AppColors.primaryIndigo;
    final remainingClr = remainingColor ??
        (isDark ? AppColors.gray700 : AppColors.gray300);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 아이콘들
        for (int i = 0; i < total; i++)
          Padding(
            padding: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            child: Icon(
              i < completed ? Icons.check_circle : Icons.circle_outlined,
              size: iconSize,
              color: i < completed ? completedClr : remainingClr,
            ),
          ),
        // 숫자 표시
        if (showNumbers) ...[
          const SizedBox(width: 8),
          Text(
            '$completed/$total',
            style: AppTextStyles.labelMedium.copyWith(
              color: isDark
                  ? AppColors.onSurfaceVariantDark
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// 애니메이션 완료 인디케이터
class AnimatedCompletionIndicator extends StatefulWidget {
  final double percentage;
  final double size;
  final Duration duration;
  final VoidCallback? onAnimationComplete;

  const AnimatedCompletionIndicator({
    required this.percentage,
    super.key,
    this.size = 100,
    this.duration = const Duration(milliseconds: 1500),
    this.onAnimationComplete,
  });

  @override
  State<AnimatedCompletionIndicator> createState() =>
      _AnimatedCompletionIndicatorState();
}

class _AnimatedCompletionIndicatorState
    extends State<AnimatedCompletionIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedCompletionIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.percentage,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CompletionIndicator(
          percentage: _animation.value,
          size: widget.size,
        );
      },
    );
  }
}