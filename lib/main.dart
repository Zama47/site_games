import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'styles/app_styles.dart';
import 'providers/auth_provider.dart';
import 'providers/games_provider.dart';
import 'providers/notifications_provider.dart';
import 'screens/splash_screen_new.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GamesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return MaterialApp(
            title: 'Game Studio Catalog',
            debugShowCheckedModeBanner: false,
            theme: AppStyles.themeData,
            home: SplashScreenNew(
              isLoggedIn: auth.isLoggedIn,
              isAdmin: auth.isAdmin,
            ),
          );
        },
      ),
    );
  }
}
