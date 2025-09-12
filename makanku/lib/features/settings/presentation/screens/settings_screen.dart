import 'package:flutter/material.dart';
import 'package:makanku/shared/widgets/app_bar_container.dart';
import 'package:makanku/shared/widgets/bottom_bar_container.dart';
import 'package:makanku/features/settings/presentation/providers/theme_provider.dart';
import 'package:makanku/features/settings/presentation/providers/settings_provider.dart';
import 'package:provider/provider.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    // Load settings ketika screen pertama kali dibuka
    Future.microtask(() {
      if (mounted) {
        context.read<SettingsProvider>().loadSettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Theme Selection menggunakan Consumer untuk ThemeNotifier
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                String selectedTheme = themeNotifier.themeMode.toString().split('.').last;

                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          themeNotifier.setTheme(ThemeMode.light);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedTheme == 'light'
                                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                                : Colors.grey[100],
                            border: Border.all(
                              color: selectedTheme == 'light'
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.light_mode,
                                size: 40,
                                color: selectedTheme == 'light'
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Light',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: selectedTheme == 'light'
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          themeNotifier.setTheme(ThemeMode.dark);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selectedTheme == 'dark'
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey[100],
                            border: Border.all(
                              color: selectedTheme == 'dark'
                                  ? Colors.white
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.dark_mode,
                                size: 40,
                                color: selectedTheme == 'dark'
                                    ? Colors.white
                                    : Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Dark',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: selectedTheme == 'dark'
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Spacing antara theme selector dan checkbox
            const SizedBox(height: 32),

            // Section untuk Penjadwalan Otomatis
            const Text(
              'Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Checkbox Container menggunakan Consumer untuk SettingsProvider
            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Automatic Schedule',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Enable automatic scheduling for daily notifications 11 AM',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Checkbox menggunakan Provider
                      Checkbox(
                        value: settingsProvider.isAutoSchedulingEnabled,
                        onChanged: (bool? value) {
                          settingsProvider.setAutoScheduling(value ?? false);
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBarContainer(),
    );
  }
}