import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import 'login_screen.dart';
import 'games_list_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  const SplashScreen({
    super.key,
    required this.isLoggedIn,
    required this.isAdmin,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => widget.isLoggedIn
                ? const GamesListScreen()
                : const LoginScreen(),
          ),
        );
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
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: _rotateAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppStyles.radiusXLarge,
                          ),
                          boxShadow: AppStyles.elevatedShadow,
                        ),
                        child: const Icon(
                          Icons.games,
                          size: 60,
                          color: AppStyles.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppStyles.paddingLarge * 2),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Game Studio',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: AppStyles.paddingSmall),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Catalog',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
