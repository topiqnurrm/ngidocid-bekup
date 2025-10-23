import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mascan/core/theme.dart';
import 'package:mascan/core/theme.dart';
import 'package:mascan/firebase_options.dart';
import 'package:mascan/injector.dart';
import 'package:mascan/views/camera_view.dart';
import 'package:mascan/views/crop_image_view.dart';
import 'package:mascan/views/food_recipe/food_recipe_view.dart';
import 'package:mascan/views/home/home_view.dart';
import 'package:mascan/views/inference_result/inference_result_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupInjector();

  runApp(const ProviderScope(child: FoodRecognizerApp()));
}

class FoodRecognizerApp extends StatelessWidget {
  const FoodRecognizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.defaultTheme(isIOS: context.isIOS),
        routes: {
          '/camera': (context) => CameraView(),
          '/crop-image': (context) => CropImageView(),
          '/inference-result': (context) => InferenceResultView(),
          '/food-recipe': (context) => FoodRecipeView(),
        },
        home: HomeView(),
      ),
    );
  }
}
