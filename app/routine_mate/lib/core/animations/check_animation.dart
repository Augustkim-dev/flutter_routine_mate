import 'package:flutter/material.dart';

/// 체크 애니메이션 위젯
/// 루틴 완료 시 체크 마크가 나타나는 애니메이션
class CheckAnimation extends StatefulWidget {
  final bool isChecked;
  final Color color;
  final double size;
  final Duration duration;
  final VoidCallback? onAnimationComplete;

  const CheckAnimation({
    required this.isChecked,
    required this.color,
    super.key,
    this.size = 24,
    this.duration = const Duration(milliseconds: 400),
    this.onAnimationComplete,
  });

  @override
  State<CheckAnimation> createState() => _CheckAnimationState();
}

class _CheckAnimationState extends State<CheckAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5),
    ));

    if (widget.isChecked) {
      _controller.forward();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(CheckAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked) {
      if (widget.isChecked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
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
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Icon(
              Icons.check_circle,
              color: widget.color,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}

/// 체크 박스 애니메이션
class AnimatedCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final double size;

  const AnimatedCheckBox({
    required this.value,
    super.key,
    this.onChanged,
    this.activeColor,
    this.checkColor,
    this.size = 24,
  });

  @override
  State<AnimatedCheckBox> createState() => _AnimatedCheckBoxState();
}

class _AnimatedCheckBoxState extends State<AnimatedCheckBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.primaryColor;
    final checkColor = widget.checkColor ?? Colors.white;

    return GestureDetector(
      onTap: widget.onChanged != null ? _handleTap : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotateAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: widget.value ? activeColor : Colors.grey.shade400,
                    width: widget.value ? 0 : 2,
                  ),
                  color: widget.value ? activeColor : Colors.transparent,
                ),
                child: widget.value
                    ? Icon(
                        Icons.check,
                        color: checkColor,
                        size: widget.size * 0.7,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}