import 'package:flutter/material.dart';

/// 슬라이드 애니메이션 위젯
/// 위젯이 특정 방향에서 슬라이드되며 나타나는 애니메이션
class SlideAnimation extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool animate;

  const SlideAnimation({
    required this.child,
    super.key,
    this.direction = SlideDirection.bottom,
    this.duration = const Duration(milliseconds: 400),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.animate = true,
  });

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    final begin = _getBeginOffset();
    _slideAnimation = Tween<Offset>(
      begin: begin,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    if (widget.animate) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  Offset _getBeginOffset() {
    switch (widget.direction) {
      case SlideDirection.top:
        return const Offset(0, -1);
      case SlideDirection.bottom:
        return const Offset(0, 1);
      case SlideDirection.left:
        return const Offset(-1, 0);
      case SlideDirection.right:
        return const Offset(1, 0);
    }
  }

  @override
  void didUpdateWidget(SlideAnimation oldWidget) {
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
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// 슬라이드 방향
enum SlideDirection { top, bottom, left, right }

/// 리스트 아이템 슬라이드 애니메이션
class ListSlideAnimation extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration itemDelay;
  final Duration duration;
  final Curve curve;

  const ListSlideAnimation({
    required this.child,
    required this.index,
    super.key,
    this.itemDelay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ListSlideAnimation> createState() => _ListSlideAnimationState();
}

class _ListSlideAnimationState extends State<ListSlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6),
    ));

    // 인덱스에 따라 딜레이를 주어 순차적으로 나타나게 함
    Future.delayed(widget.itemDelay * widget.index, () {
      if (mounted) {
        _controller.forward();
      }
    });
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
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// 페이지 전환 슬라이드 애니메이션
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SlideDirection direction;
  final Duration duration;

  SlidePageRoute({
    required this.page,
    this.direction = SlideDirection.right,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = _getBeginOffset(direction);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            final tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );

  static Offset _getBeginOffset(SlideDirection direction) {
    switch (direction) {
      case SlideDirection.top:
        return const Offset(0, -1);
      case SlideDirection.bottom:
        return const Offset(0, 1);
      case SlideDirection.left:
        return const Offset(-1, 0);
      case SlideDirection.right:
        return const Offset(1, 0);
    }
  }
}