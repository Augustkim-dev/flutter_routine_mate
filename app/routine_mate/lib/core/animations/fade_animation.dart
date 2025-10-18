import 'package:flutter/material.dart';

/// 페이드 애니메이션 위젯
/// 위젯이 서서히 나타나거나 사라지는 애니메이션
class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool animate;
  final double beginOpacity;
  final double endOpacity;

  const FadeAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.curve = Curves.easeIn,
    this.animate = true,
    this.beginOpacity = 0.0,
    this.endOpacity = 1.0,
  });

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: widget.beginOpacity,
      end: widget.endOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.animate) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
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
        return Opacity(
          opacity: _fadeAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// 크로스 페이드 애니메이션
/// 두 위젯 간의 부드러운 전환
class CrossFadeAnimation extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final bool showFirst;
  final Duration duration;
  final Curve curve;

  const CrossFadeAnimation({
    required this.firstChild,
    required this.secondChild,
    required this.showFirst,
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<CrossFadeAnimation> createState() => _CrossFadeAnimationState();
}

class _CrossFadeAnimationState extends State<CrossFadeAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: widget.firstChild,
      secondChild: widget.secondChild,
      crossFadeState: widget.showFirst
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: widget.duration,
      firstCurve: widget.curve,
      secondCurve: widget.curve,
      sizeCurve: widget.curve,
    );
  }
}

/// 펄스 페이드 애니메이션 (반복)
class PulseFadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final bool animate;

  const PulseFadeAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(seconds: 1),
    this.minOpacity = 0.3,
    this.maxOpacity = 1.0,
    this.animate = true,
  });

  @override
  State<PulseFadeAnimation> createState() => _PulseFadeAnimationState();
}

class _PulseFadeAnimationState extends State<PulseFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseFadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
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
        return Opacity(
          opacity: _fadeAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// 페이드 스케일 애니메이션
/// 페이드와 스케일 효과를 동시에 적용
class FadeScaleAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool animate;
  final double beginScale;
  final double endScale;

  const FadeScaleAnimation({
    required this.child,
    super.key,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutBack,
    this.animate = true,
    this.beginScale = 0.8,
    this.endScale = 1.0,
  });

  @override
  State<FadeScaleAnimation> createState() => _FadeScaleAnimationState();
}

class _FadeScaleAnimationState extends State<FadeScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6),
    ));

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.animate) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(FadeScaleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
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
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}