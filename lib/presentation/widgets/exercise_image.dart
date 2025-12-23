import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workout_app/cache/exercise_image_cache.dart';

/// Widget to display cached exercise images (SVG or PNG)
class ExerciseImageWidget extends StatelessWidget {
  final String exerciseId;
  final String? exerciseName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String format;

  const ExerciseImageWidget({
    super.key,
    required this.exerciseId,
    this.exerciseName,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.format = 'svg',
  });

  @override
  Widget build(BuildContext context) {
    final imageCache = ExerciseImageCache();

    return FutureBuilder<File?>(
      future: imageCache.getCachedImage(exerciseId, format: format),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder(context, isLoading: true);
        }

        if (snapshot.hasError || snapshot.data == null) {
          return _buildPlaceholder(context, isLoading: false);
        }

        final imageFile = snapshot.data!;

        // Display SVG or PNG based on format
        if (format == 'svg') {
          return SvgPicture.file(
            imageFile,
            width: width,
            height: height,
            fit: fit,
            placeholderBuilder: (context) =>
                _buildPlaceholder(context, isLoading: true),
          );
        } else {
          return Image.file(
            imageFile,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholder(context, isLoading: false),
          );
        }
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context, {required bool isLoading}) {
    final theme = Theme.of(context);
    final size = width ?? height ?? 150.0;

    return Container(
      width: width ?? size,
      height: height ?? size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const CircularProgressIndicator()
          else
            Icon(
              Icons.fitness_center,
              size: size * 0.3,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          if (exerciseName != null && !isLoading) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                exerciseName!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact exercise card with image and details
class ExerciseCard extends StatelessWidget {
  final String exerciseId;
  final String exerciseName;
  final String? primaryMuscle;
  final String? category;
  final VoidCallback? onTap;

  const ExerciseCard({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
    this.primaryMuscle,
    this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Exercise image thumbnail
              ExerciseImageWidget(
                exerciseId: exerciseId,
                width: 80,
                height: 80,
              ),
              const SizedBox(width: 16),

              // Exercise details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseName,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (primaryMuscle != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 14,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            primaryMuscle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (category != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        category!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen exercise detail with large image
class ExerciseDetailView extends StatelessWidget {
  final String exerciseId;
  final String exerciseName;
  final String? description;
  final List<String>? primaryMuscles;
  final List<String>? secondaryMuscles;
  final String? category;

  const ExerciseDetailView({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
    this.description,
    this.primaryMuscles,
    this.secondaryMuscles,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large exercise image
            Container(
              width: double.infinity,
              height: 300,
              color: theme.colorScheme.surfaceVariant,
              child: ExerciseImageWidget(
                exerciseId: exerciseId,
                exerciseName: exerciseName,
                height: 300,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise name
                  Text(exerciseName, style: theme.textTheme.headlineMedium),

                  if (category != null) ...[
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(category!),
                      backgroundColor: theme.colorScheme.secondaryContainer,
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Primary muscles
                  if (primaryMuscles != null && primaryMuscles!.isNotEmpty) ...[
                    Text('Primary Muscles', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: primaryMuscles!
                          .map((muscle) => Chip(label: Text(muscle)))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Secondary muscles
                  if (secondaryMuscles != null &&
                      secondaryMuscles!.isNotEmpty) ...[
                    Text(
                      'Secondary Muscles',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: secondaryMuscles!
                          .map((muscle) => Chip(label: Text(muscle)))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Description
                  if (description != null && description!.isNotEmpty) ...[
                    Text('Description', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(description!, style: theme.textTheme.bodyLarge),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
