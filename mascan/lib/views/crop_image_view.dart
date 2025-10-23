import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mascan/core/utils/toast.dart';
import 'package:mascan/core/widgets/app_scaffold.dart';
import 'package:mascan/core/widgets/primary_outlined_button.dart';
import 'package:mascan/core/widgets/primary_button.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';

class CropImageView extends StatefulWidget {
  const CropImageView({super.key});

  @override
  State<CropImageView> createState() => _CropImageViewState();
}

class _CropImageViewState extends State<CropImageView> {
  File? imageFile;
  File? _croppedImageFile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    imageFile = File(args?['imagePath']);
    _croppedImageFile = imageFile;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _cropImage() async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            showCropGrid: true,
            hideBottomControls: false,
            cropGridRowCount: 3,
            cropGridColumnCount: 3,
            statusBarColor: Colors.black,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Batal',
            minimumAspectRatio: 1.0,
            aspectRatioLockEnabled: false,
            resetAspectRatioEnabled: true,
            rotateButtonsHidden: false,
            resetButtonHidden: false,
            aspectRatioPickerButtonHidden: false,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _croppedImageFile = File(croppedFile.path);
        });
      }
    } catch (e) {
      showToast('Gagal memotong gambar: $e');
    }
  }

  void _resetToOriginal() {
    setState(() {
      _croppedImageFile = imageFile;
    });

    showToast('Gambar direset ke versi asli.');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text('Potong Gambar'),
      body: SafeArea(
        child: Column(
          children: [
            _croppedImageFile != null
                ? Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: Image.file(
                        _croppedImageFile!,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                Text(
                                  'Gagal memuat gambar',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Center(child: Text('Belum ada gambar yang dipilih')),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: PrimaryOutlinedButton(
                          label: 'Potong',
                          icon: Icons.crop,
                          onPressed: _cropImage,
                        ),
                      ),
                      Expanded(
                        child: PrimaryOutlinedButton(
                          label: 'Kembalikan',
                          icon: Icons.refresh,
                          onPressed: _resetToOriginal,
                        ),
                      ),
                    ],
                  ),
                  Gap(4),
                  PrimaryButton(
                    label: 'Analisis Gambar',
                    icon: HeroIcons.document_magnifying_glass,
                    onPressed: () {
                      if (_croppedImageFile != null) {
                        Navigator.of(context).pushReplacementNamed(
                          '/inference-result',
                          arguments: {'imagePath': _croppedImageFile!.path},
                        );
                      } else {
                        showToast('Mohon pangkas gambar terlebih dahulu.');
                      }
                    },
                  ),
                  Gap(24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
