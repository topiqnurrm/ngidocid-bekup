import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/favorite_provider.dart';
// import 'providers/settings_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MakankuApp());
}

class MakankuApp extends StatelessWidget {
  const MakankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Makanku',
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData.light().copyWith(
              colorScheme: ThemeData.light().colorScheme.copyWith(primary: Colors.deepOrange),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ThemeData.dark().colorScheme.copyWith(primary: Colors.deepOrangeAccent),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
