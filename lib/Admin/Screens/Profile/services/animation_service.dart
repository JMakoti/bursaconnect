import 'package:flutter/material.dart';

class AnimationService {
  // Standard animation durations
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);

  // Standard animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve slideCurve = Curves.easeOutCubic;

  // Hero Animation Tags
  static const String profileAvatarHero = 'profile-avatar';
  static const String settingsIconHero = 'settings-icon';

  // Page Route Animations
  static Route<T> slideRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    SlideDirection direction = SlideDirection.right,
    Duration duration = normalDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (direction) {
          case SlideDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
          case SlideDirection.left:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.right:
            begin = const Offset(1.0, 0.0);
            break;
        }

        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(
          tween.chain(CurveTween(curve: slideCurve)),
        );

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static Route<T> fadeRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = normalDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: defaultCurve)),
          child: child,
        );
      },
    );
  }

  static Route<T> scaleRoute<T extends Object?>(
    Widget page, {
    RouteSettings? settings,
    Duration duration = normalDuration,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: bounceCurve)),
          ),
          child: child,
        );
      },
    );
  }

  // Animated Widgets
  static Widget animatedContainer({
    required Widget child,
    required Duration duration,
    Curve curve = defaultCurve,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxDecoration? decoration,
    double? width,
    double? height,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      color: color,
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }

  static Widget fadeInUp({
    required Widget child,
    Duration delay = Duration.zero,
    Duration duration = normalDuration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + delay,
      curve: defaultCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  static Widget slideInFromLeft({
    required Widget child,
    Duration delay = Duration.zero,
    Duration duration = normalDuration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + delay,
      curve: slideCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-100 * (1 - value), 0),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget bounceIn({
    required Widget child,
    Duration delay = Duration.zero,
    Duration duration = slowDuration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration + delay,
      curve: bounceCurve,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: child,
    );
  }

  // Loading Animations
  static Widget pulsingDot({
    Color color = Colors.blue,
    double size = 8.0,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: value),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  static Widget shimmerLoading({
    required Widget child,
    Color baseColor = const Color(0xFFE0E0E0),
    Color highlightColor = const Color(0xFFF5F5F5),
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -1.0, end: 2.0),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (value - 1.0).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 1.0).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  // Interactive Animations
  static Widget animatedButton({
    required Widget child,
    required VoidCallback onPressed,
    Duration duration = const Duration(milliseconds: 150),
    double scaleDown = 0.95,
  }) {
    return _AnimatedButtonState(
      onPressed: onPressed,
      duration: duration,
      scaleDown: scaleDown,
      child: child,
    );
  }

  // Staggered Animations
  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Duration itemDuration = normalDuration,
  }) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;

      return fadeInUp(
        delay: staggerDelay * index,
        duration: itemDuration,
        child: child,
      );
    }).toList();
  }

  // Navigation Helpers
  static Future<T?> navigateWithSlide<T extends Object?>(
    BuildContext context,
    Widget page, {
    SlideDirection direction = SlideDirection.right,
    Duration duration = normalDuration,
  }) {
    return Navigator.of(
      context,
    ).push<T>(slideRoute<T>(page, direction: direction, duration: duration));
  }

  static Future<T?> navigateWithFade<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration duration = normalDuration,
  }) {
    return Navigator.of(
      context,
    ).push<T>(fadeRoute<T>(page, duration: duration));
  }

  static Future<T?> navigateWithScale<T extends Object?>(
    BuildContext context,
    Widget page, {
    Duration duration = normalDuration,
  }) {
    return Navigator.of(
      context,
    ).push<T>(scaleRoute<T>(page, duration: duration));
  }
}

// Animated Button State
class _AnimatedButtonState extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;
  final double scaleDown;

  const _AnimatedButtonState({
    required this.child,
    required this.onPressed,
    required this.duration,
    required this.scaleDown,
  });

  @override
  State<_AnimatedButtonState> createState() => __AnimatedButtonStateState();
}

class __AnimatedButtonStateState extends State<_AnimatedButtonState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

// Enums
enum SlideDirection { up, down, left, right }

// Custom Animated Widgets
class AnimatedCounter extends StatelessWidget {
  final int value;
  final Duration duration;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = AnimationService.normalDuration,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Text(value.toString(), style: style);
      },
    );
  }
}

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Duration duration;
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.duration = AnimationService.normalDuration,
    this.backgroundColor,
    this.progressColor,
    this.height = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade300,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
        duration: duration,
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor ?? Colors.blue,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
