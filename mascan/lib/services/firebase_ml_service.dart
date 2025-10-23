import 'dart:io';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:mascan/core/configs/env.dart';

class FirebaseMlService {
  File? _cachedModel;

  Future<File> loadModel() async {
    
    if (_cachedModel != null) {
      return _cachedModel!;
    }

    final instance = FirebaseModelDownloader.instance;
    final model = await instance.getModel(
      Env.firebaseMlModel,
      FirebaseModelDownloadType.localModel,
      FirebaseModelDownloadConditions(
        iosAllowsCellularAccess: true,
        iosAllowsBackgroundDownloading: false,
        androidChargingRequired: false,
        androidWifiRequired: false,
        androidDeviceIdleRequired: false,
      ),
    );

    _cachedModel = model.file;
    return _cachedModel!;
  }

  void clearCache() {
    _cachedModel = null;
  }
}
