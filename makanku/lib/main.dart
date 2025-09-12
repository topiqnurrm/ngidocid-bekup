import 'package:makanku/data/source/local/database_service.dart';
import 'package:makanku/data/source/networks/api.dart';
import 'package:makanku/features/settings/presentation/providers/settings_provider.dart';
import 'package:makanku/features/settings/presentation/providers/theme_provider.dart';
import 'package:makanku/core/styles/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:makanku/features/restaurant/presentation/screens/home_screen.dart';
import 'package:makanku/core/constants/navigation_routes.dart';
import 'package:makanku/core/services/local_notification_service.dart';
import 'package:makanku/features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'package:makanku/features/restaurant/domain/usecases/restaurant_use_case.dart';
import 'package:makanku/features/restaurant/presentation/screens/detail_screen.dart';
import 'package:makanku/features/favorite/presentation/screens/favorite_screen.dart';
import 'package:makanku/features/search/presentation/screens/search_screen.dart';
import 'package:makanku/features/settings/presentation/screens/settings_screen.dart';
import 'package:makanku/features/restaurant/presentation/providers/restaurant_detail_provider.dart';
import 'package:makanku/features/favorite/presentation/providers/favorite_provider.dart';
import 'package:makanku/features/settings/presentation/providers/notification_provider.dart';
import 'package:makanku/features/restaurant/presentation/providers/restaurant_list_provider.dart';
import 'package:makanku/features/restaurant/presentation/providers/restaurant_search_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider<ApiImpl>(create: (_) => ApiImpl()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<LocalNotificationService>(create: (_) => LocalNotificationService()), // Tambahkan ini jika belum ada

        // Repository
        ProxyProvider2<ApiImpl, DatabaseService, RestaurantImpl>(
          update: (context, api, db, previous) =>
              RestaurantImpl(api: api, databaseService: db),
        ),

        // Use Case
        ProxyProvider<RestaurantImpl, RestaurantUseCase>(
          update: (_, repo, __) =>
              RestaurantUseCase(restaurantRepository: repo),
        ),

        // Providers
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(
            restaurantUseCase: Provider.of<RestaurantUseCase>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider<DetailProvider>(
          create: (context) => DetailProvider(
            restaurantUseCase: Provider.of<RestaurantUseCase>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider(
            restaurantUseCase: Provider.of<RestaurantUseCase>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider(
            restaurantUseCase: Provider.of<RestaurantUseCase>(
              context,
              listen: false,
            ),
          ),
        ),
        ChangeNotifierProvider<LocalNotificationProvider>(
          create: (context) => LocalNotificationProvider(
            Provider.of<LocalNotificationService>(context, listen: false),
          )..requestPermissions(),
        ),
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),

        // Tambahkan SettingsProvider
        ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk ThemeNotifier agar reactive terhadap perubahan theme
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Makanku',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode, // Menggunakan dari Consumer
          initialRoute: NavigationRoute.home.route,
          routes: {
            NavigationRoute.home.route: (context) => const HomeScreen(),
            NavigationRoute.detail.route: (context) => DetailScreen(
              id: ModalRoute.of(context)?.settings.arguments as String,
            ),
            NavigationRoute.search.route: (context) => SearchScreen(
              query: ModalRoute.of(context)?.settings.arguments as String,
            ),
            NavigationRoute.favorite.route: (context) => const FavoriteScreen(),
            NavigationRoute.settings.route: (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}