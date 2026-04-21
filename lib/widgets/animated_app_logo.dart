import 'package:flutter/material.dart';

class AnimatedAppLogo extends StatefulWidget {
  final double size;
  final bool animate;
  final bool spin;
  final Duration spinDuration;

  const AnimatedAppLogo({
    super.key,
    this.size = 140,
    this.animate = true,
    this.spin = false,
    this.spinDuration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedAppLogo> createState() => _AnimatedAppLogoState();
}

class _AnimatedAppLogoState extends State<AnimatedAppLogo>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Spin controller for continuous rotation
    _spinController = AnimationController(
      vsync: this,
      duration: widget.spinDuration,
    );

    // Pulse controller for breathing effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_spinController);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _spinController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    if (widget.animate) {
      _spinController.forward().then((_) {
        _pulseController.repeat(reverse: true);
      });
    }

    if (widget.spin) {
      _spinController.repeat();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget logo = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.size * 0.25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size * 0.25),
        child: Image.asset(
          'assets/images/app_icon.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icon if custom icon not found
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.size * 0.25),
              ),
              child: Icon(
                Icons.games,
                size: widget.size * 0.5,
                color: const Color(0xFF667eea),
              ),
            );
          },
        ),
      ),
    );

    if (!widget.animate && !widget.spin) {
      return logo;
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _spinController,
        _pulseController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.animate
              ? (_scaleAnimation.value == 1.0
                  ? _pulseAnimation.value
                  : _scaleAnimation.value)
              : 1.0,
          child: widget.spin
              ? RotationTransition(
                  turns: _spinController,
                  child: FadeTransition(
                    opacity: widget.animate ? _fadeAnimation : const AlwaysStoppedAnimation(1.0),
                    child: logo,
                  ),
                )
              : FadeTransition(
                  opacity: widget.animate ? _fadeAnimation : const AlwaysStoppedAnimation(1.0),
                  child: logo,
                ),
        );
      },
    );
  }
}
