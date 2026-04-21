import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../widgets/animated_app_logo.dart';
import 'login_screen.dart';
import 'games_list_screen.dart';

class SplashScreenNew extends StatefulWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  const SplashScreenNew({
    super.key,
    required this.isLoggedIn,
    required this.isAdmin,
  });

  @override
  State<SplashScreenNew> createState() => _SplashScreenNewState();
}

class _SplashScreenNewState extends State<SplashScreenNew>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return widget.isLoggedIn
                  ? const GamesListScreen()
                  : const LoginScreen();
            },
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated background circles
            ...List.generate(5, (index) {
              return AnimatedPositioned(
                duration: Duration(seconds: 3 + index),
                curve: Curves.easeInOut,
                top: index.isEven
                    ? 50 + index * 80.0
                    : MediaQuery.of(context).size.height - 200 - index * 60,
                left: index.isEven
                    ? 30 + index * 50.0
                    : MediaQuery.of(context).size.width - 150 - index * 40,
                child: AnimatedOpacity(
                  opacity: 0.1,
                  duration: const Duration(seconds: 2),
                  child: Container(
                    width: 100 + index * 30.0,
                    height: 100 + index * 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
              );
            }),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated spinning logo
                  const AnimatedAppLogo(
                    size: 140,
                    animate: true,
                    spin: true,
                    spinDuration: Duration(seconds: 3),
                  ),
                  const SizedBox(height: 40),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'GAME STUDIO',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'CATALOG',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        minHeight: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
