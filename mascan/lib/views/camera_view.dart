import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mascan/init/theme.dart';
import 'package:mascan/init/utils.dart';
import 'package:mascan/init/widgets.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameraList = [];
  bool _isReady = false;
  bool _useBackCam = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      _cameraList = await availableCameras();
      if (_cameraList.isEmpty) {
        showToast('Kamera tidak ditemukan pada perangkat.');
        return;
      }
      await _initializeCamera(_cameraList.first);
    } catch (e) {
      showToast('Gagal mengakses kamera: $e');
    }
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    final oldController = _controller;
    final newController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
      fps: 60,
      imageFormatGroup: context.isIOS
          ? ImageFormatGroup.bgra8888
          : ImageFormatGroup.nv21,
    );

    await oldController?.dispose();

    try {
      await newController.initialize();
      if (!mounted) return;
      setState(() {
        _controller = newController;
        _isReady = _controller!.value.isInitialized;
      });
    } catch (e) {
      await PermissionHandler.handlePermissionDenied(Permission.camera)
          .then((granted) {
        if (!granted && mounted) Navigator.pop(context);
      });
      showToast('Izin kamera ditolak atau kamera tidak dapat digunakan.');
    }
  }

  void _toggleCamera() {
    if (_cameraList.length <= 1) return;

    setState(() => _isReady = false);

    final nextCamera =
    _useBackCam ? _cameraList[1] : _cameraList[0];
    _initializeCamera(nextCamera);

    setState(() => _useBackCam = !_useBackCam);
  }

  Future<void> _capturePhoto() async {
    await _controller?.pausePreview();
    try {
      final picture = await _controller?.takePicture();
      if (picture != null && mounted) {
        await Navigator.pushNamed(
          context,
          '/crop-image',
          arguments: {'imagePath': picture.path},
        );
      }
    } catch (e) {
      showToast('Terjadi kesalahan saat mengambil foto: $e');
    } finally {
      _controller?.resumePreview();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller?.pausePreview();
    } else if (state == AppLifecycleState.resumed) {
      if (!_controller!.value.isInitialized) {
        _initializeCamera(_controller!.description);
      }
      _controller?.resumePreview();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _isReady
          ? Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Ambil Gambar Makanan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: CameraPreview(_controller!),
          ),
          Align(
            alignment: const Alignment(0, 0.7),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Ketuk untuk memotret.\nPastikan makanan terlihat jelas dan cukup terang.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.9, 0.9),
            child: FloatingActionButton(
              onPressed: _toggleCamera,
              heroTag: 'switch_camera',
              child: const Icon(Icons.cameraswitch),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: FloatingActionButton(
              onPressed: _capturePhoto,
              heroTag: 'capture_photo',
              child: const Icon(IonIcons.camera),
            ),
          ),
        ],
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Icon(
              IonIcons.camera,
              size: 26,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Text(
              'Membuka kamera...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
