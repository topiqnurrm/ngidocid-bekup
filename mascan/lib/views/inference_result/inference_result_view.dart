import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mascan/core/views.dart';
import 'package:mascan/core/widgets.dart';
import 'package:mascan/models.dart';
import 'package:mascan/viewmodels/modelsview.dart';
import 'package:mascan/viewmodels/states.dart';
import 'package:mascan/views/inference_result/widgets.dart';
import 'package:gap/gap.dart';

class InferenceResultView extends ConsumerStatefulWidget {
  const InferenceResultView({super.key});

  @override
  ConsumerState<InferenceResultView> createState() =>
      _InferenceResultViewState();
}

class _InferenceResultViewState extends ConsumerState<InferenceResultView> {
  String? imagePath;

  Future<void> _runImageInference() async {
    if (imagePath != null) {
      await ref
          .read(liteRtViewModelProvider.notifier)
          .runImageInference(imagePath!);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      imagePath = args?['imagePath'];
      _runImageInference();
    });
  }

  @override
  void dispose() {
    imagePath = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liteRtState = ref.watch(liteRtViewModelProvider);

    Widget body;

    if (liteRtState.isLoading) {
      body = LoadingView(message: 'Proses analisis gambar...');
    } else if (liteRtState.error != null) {
      body = ErrorView(error: liteRtState.error!, onRetry: _runImageInference);
    } else if (liteRtState.foods != null) {
      body = _buildContent(context, liteRtState);
    } else {
      body = LoadingView(message: 'Memuat model...');
    }

    return AppScaffold(title: Text('Hasil Inferensi'), body: body);
  }

  Widget _buildContent(BuildContext context, LiteRtViewModelState state) {
    return SafeArea(
      child: Column(
        children: [
          Gap(16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imagePath != null
                            ? Image.file(File(imagePath!), fit: BoxFit.cover)
                            : Container(),
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 24,
                    children: [
                      Center(
                        child: Text(
                          'Hasil Analisis',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (state.isLoading)
                        LoadingView()
                      else if (state.error != null)
                        ErrorView(
                          error: state.error!,
                          onRetry: _runImageInference,
                        )
                      else if (state.foods?.isNotEmpty == true)
                        _buildInferenceResultList(context, state.foods!)
                      else
                        NoResultView(
                          description:
                              'Kami tidak dapat mengenali gambar ini sebagai makanan. Silakan coba gambar lain.',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInferenceResultList(
    BuildContext context,
    List<FoodPrediction> foods,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        BestInferenceResultCard(food: foods.first),
        Text('3 Hasil Teratas', style: Theme.of(context).textTheme.titleMedium),
        ...foods.map(
          (food) => InferenceResultItem(
            prediction: food,
            index: foods.indexOf(food),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/food-recipe',
                arguments: {'foodLabel': food.label},
              );
            },
          ),
        ),
        if (foods.length < 3)
          Center(
            child: Text(
              'Tidak ada hasil lainnya yang tersedia.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ),
      ],
    );
  }
}
