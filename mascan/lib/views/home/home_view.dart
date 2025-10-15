import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mascan/core/utils/show_dialog.dart';
import 'package:mascan/core/widgets/app_scaffold.dart';
import 'package:mascan/views/home/widgets/faded_image_carousel.dart';
import 'package:mascan/views/home/widgets/method_card.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _appVersion = '';
  String? imagePath;

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${packageInfo.version}';
    });
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  void _setImageFromGallery(XFile? value) {
    setState(() {
      imagePath = value?.path;

      if (imagePath != null) {
        Navigator.of(
          context,
        ).pushNamed('/crop-image', arguments: {'imagePath': imagePath});
      }
    });
  }

  void _openGallery() async {
    final picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _setImageFromGallery(pickedFile);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      automaticallyImplyLeading: false,
      title: Row(
        spacing: 4,
        children: [
          Gap(4),
          Icon(
            IonIcons.fast_food,
            color: Theme.of(context).colorScheme.primary,
          ),
          Text("mascan"),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.info_outline,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            showInfoDialog(
              context: context,
              title: 'About',
              content:
                  'This app is designed to recognize different types of food with descriptions, recipe, and nutrition facts.',
              buttonText: 'Dismiss',
            );
          },
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Gap(12),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Recognize different types of food.',
              style: Theme.of(context).textTheme.bodyMedium!,
            ),

            Gap(4),
            FadedImageCarousel(),
            Gap(4),

            Text(
              'What method would you like to use?',
              style: Theme.of(context).textTheme.bodyMedium!,
            ),

            MethodCard(
              assetPath: 'assets/images/take_picture.svg',
              title: 'Camera',
              description: 'Use your camera to take a picture of the food.',
              onTap: () => Navigator.of(context).pushNamed('/camera'),
            ),

            MethodCard(
              assetPath: 'assets/images/pick_image.svg',
              title: 'Gallery',
              description: 'Select an image from your gallery.',
              onTap: _openGallery,
            ),

            Gap(32),
            Center(
              child: Column(
                spacing: 2,
                children: [
                  Text(
                    'Mascan $_appVersion',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '© 2025 mascan',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
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
