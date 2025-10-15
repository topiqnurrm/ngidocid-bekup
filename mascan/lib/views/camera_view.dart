import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mascan/core/theme/theme_extensions.dart';
import 'package:mascan/core/utils/toast.dart';
import 'package:mascan/core/widgets/app_scaffold.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/utils/permission_handler.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  bool _isCameraInitialized = false;
  List<CameraDescription> _cameras = [];
  bool _isBackCamera = true;
  CameraController? controller;

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
      fps: 60,
      imageFormatGroup: !context.isIOS
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await previousCameraController?.dispose();

    cameraController
        .initialize()
        .then((value) {
          if (mounted) {
            setState(() {
              controller = cameraController;
              _isCameraInitialized = controller!.value.isInitialized;
            });
          }
        })
        .catchError((e) {
          PermissionHandler.handlePermissionDenied(Permission.camera).then((
            granted,
          ) {
            if (!granted && mounted) {
              Navigator.pop(context);
            }
          });
          showToast('Camera permission denied or not available.');
        });
  }

  void _initCamera() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    await _onNewCameraSelected(_cameras.first);
  }

  void _onCaptureImage() async {
    await controller?.pausePreview();
    try {
      final image = await controller?.takePicture();

      if (image != null && mounted) {
        await Navigator.pushNamed(
          context,
          '/crop-image',
          arguments: {'imagePath': image.path},
        );
      }
    } catch (e) {
      showToast('Error capturing image: $e');
    } finally {
      controller?.resumePreview();
    }
  }

  void _onCameraSwitch() {
    if (_cameras.length == 1) return;

    setState(() {
      _isCameraInitialized = false;
    });

    _onNewCameraSelected(_cameras[_isBackCamera ? 0 : 1]);

    setState(() {
      _isBackCamera = !_isBackCamera;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.pausePreview();
    } else if (state == AppLifecycleState.resumed) {
      if (!cameraController.value.isInitialized) {
        _onNewCameraSelected(cameraController.description);
      }
      cameraController.resumePreview();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _isCameraInitialized
          ? Stack(
              children: [
                Align(
                  alignment: Alignment(0, -1),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Capture Food Image",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 80.0),
                  child: CameraPreview(controller!),
                ),
                Align(
                  alignment: Alignment(0, 0.7),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Tap to capture. Make sure the food\nis in focus and well lit.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.9, 0.9),
                  child: FloatingActionButton(
                    onPressed: () => _onCameraSwitch(),
                    heroTag: 'switch-camera',
                    child: Icon(Icons.cameraswitch),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.9),
                  child: FloatingActionButton(
                    onPressed: () => _onCaptureImage(),
                    heroTag: 'capture',
                    child: Icon(IonIcons.camera),
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
                    size: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  Text(
                    'Searching for camera...',
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
