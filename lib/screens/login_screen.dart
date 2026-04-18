import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../styles/app_styles.dart';
import 'games_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GamesListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppStyles.primaryGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppStyles.paddingLarge),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppStyles.paddingLarge),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.games,
                            size: 80,
                            color: AppStyles.primaryColor,
                          ),
                          const SizedBox(height: AppStyles.paddingMedium),
                          Text(
                            'Game Studio Catalog',
                            style: AppStyles.headlineStyle.copyWith(
                              color: AppStyles.primaryColor,
                            ),
                          ),
                          const SizedBox(height: AppStyles.paddingSmall),
                          Text(
                            'Войдите в систему',
                            style: AppStyles.captionStyle,
                          ),
                          const SizedBox(height: AppStyles.paddingLarge),
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Логин',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введите логин';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppStyles.paddingMedium),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Пароль',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введите пароль';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppStyles.paddingMedium),
                          Consumer<AuthProvider>(
                            builder: (context, auth, child) {
                              if (auth.error != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppStyles.paddingMedium,
                                  ),
                                  child: Text(
                                    auth.error!,
                                    style: const TextStyle(
                                      color: AppStyles.errorColor,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Consumer<AuthProvider>(
                              builder: (context, auth, child) {
                                return ElevatedButton(
                                  onPressed: auth.isLoading ? null : _login,
                                  child: auth.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Войти'),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: AppStyles.paddingLarge),
                          Container(
                            padding: const EdgeInsets.all(AppStyles.paddingMedium),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(
                                AppStyles.radiusMedium,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Демо-аккаунты:',
                                  style: AppStyles.captionStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppStyles.paddingSmall),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildDemoAccount('gamer'),
                                    const SizedBox(width: AppStyles.paddingMedium),
                                    _buildDemoAccount('admin'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoAccount(String username) {
    return InkWell(
      onTap: () {
        _usernameController.text = username;
        _passwordController.text = 'pass';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppStyles.paddingMedium,
          vertical: AppStyles.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppStyles.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        ),
        child: Text(
          '$username / pass',
          style: AppStyles.captionStyle.copyWith(
            color: AppStyles.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
