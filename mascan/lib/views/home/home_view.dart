import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mascan/core/utils.dart';
import 'package:mascan/core/widgets.dart';
import 'package:mascan/views/home/widgets.dart';
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
            Icons.food_bank,
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
              title: 'Tentang',
              content:
                  'Aplikasi ini adalah alat pintar untuk mengenali berbagai jenis makanan. Setelah mengenali makanan, aplikasi akan memberikan deskripsi lengkap, resep masakan, dan informasi nutrisi.',
              buttonText: 'Kembali',
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
              'Selamat Datang !',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Silahkan foto makanan anda',
              style: Theme.of(context).textTheme.bodyMedium!,
            ),

            Gap(4),

            MethodCard(
              assetPath: 'assets/images/take_picture.svg',
              title: 'Kamera',
              description: 'Ambil gambar dengan kamera',
              onTap: () => Navigator.of(context).pushNamed('/camera'),
            ),

            MethodCard(
              assetPath: 'assets/images/pick_image.svg',
              title: 'Galeri',
              description: 'Pilih gambar dari galeri',
              onTap: _openGallery,
            ),

            Gap(420),
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
