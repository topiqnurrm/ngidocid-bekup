
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/restaurant_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MakankuApp());
}

class MakankuApp extends StatelessWidget {
  const MakankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantProvider()..loadRestaurants()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          final baseLight = ThemeData.light().copyWith(
            colorScheme: ThemeData.light().colorScheme.copyWith(primary: Colors.deepOrange),
          );
          final baseDark = ThemeData.dark().copyWith(
            colorScheme: ThemeData.dark().colorScheme.copyWith(primary: Colors.deepOrangeAccent),
          );
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Makanku',
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: baseLight.copyWith(textTheme: GoogleFonts.poppinsTextTheme(baseLight.textTheme)),
            darkTheme: baseDark.copyWith(textTheme: GoogleFonts.poppinsTextTheme(baseDark.textTheme)),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
