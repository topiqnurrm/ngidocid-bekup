import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mascan/init/utils.dart';
import 'package:mascan/init/widgets.dart';

class CropImageView extends StatefulWidget {
  const CropImageView({super.key});

  @override
  State<CropImageView> createState() => _CropImageViewState();
}

class _CropImageViewState extends State<CropImageView> {
  File? _originalImage;
  File? _editedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args?['imagePath'] != null) {
      _originalImage = File(args!['imagePath']);
      _editedImage = _originalImage;
    }
  }

  Future<void> _handleCrop() async {
    if (_originalImage == null) return;

    try {
      final cropped = await ImageCropper().cropImage(
        sourcePath: _originalImage!.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Pangkas Gambar',
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
            title: 'Pangkas Gambar',
            doneButtonTitle: 'Selesai',
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

      if (cropped != null && mounted) {
        setState(() {
          _editedImage = File(cropped.path);
        });
      }
    } catch (e) {
      showToast('Terjadi kesalahan saat memotong gambar: $e');
    }
  }

  void _restoreOriginal() {
    setState(() => _editedImage = _originalImage);
    showToast('Gambar dikembalikan ke versi asli.');
  }

  void _analyzeImage() {
    if (_editedImage == null) {
      showToast('Harap potong gambar terlebih dahulu.');
      return;
    }

    Navigator.of(context).pushReplacementNamed(
      '/inference-result',
      arguments: {'imagePath': _editedImage!.path},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: const Text('Pangkas Gambar'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _editedImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: Image.file(
                  _editedImage!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: const [
                        Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                        Text(
                          'Gagal memuat gambar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : const Center(child: Text('Belum ada gambar yang dipilih')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: PrimaryOutlinedButton(
                          label: 'Pangkas',
                          icon: Icons.crop,
                          onPressed: _handleCrop,
                        ),
                      ),
                      Expanded(
                        child: PrimaryOutlinedButton(
                          label: 'Kembalikan',
                          icon: Icons.refresh,
                          onPressed: _restoreOriginal,
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  PrimaryButton(
                    label: 'Analisis Gambar',
                    icon: HeroIcons.document_magnifying_glass,
                    onPressed: _analyzeImage,
                  ),
                  const Gap(24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
