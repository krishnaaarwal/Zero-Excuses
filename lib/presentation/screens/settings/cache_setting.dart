import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:workout_app/Api/exercise_api_service.dart';
import 'package:workout_app/cache/exercise_image_cache.dart';
import 'package:workout_app/presentation/screens/initialize/app_initializer.dart';
import 'package:workout_app/repository/exercise_cache_repository.dart';

/// Settings screen for managing cache and data
class CacheSettingsScreen extends StatefulWidget {
  const CacheSettingsScreen({super.key});

  @override
  State<CacheSettingsScreen> createState() => _CacheSettingsScreenState();
}

class _CacheSettingsScreenState extends State<CacheSettingsScreen> {
  late AppInitializer _initializer;
  late ExerciseCacheRepository _cacheRepo;
  late ExerciseImageCache _imageCache;

  Map<String, dynamic>? _status;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final exerciseCacheBox = await Hive.openBox('exercise_cache_box');
    final initBox = await Hive.openBox('app_init_box');

    _cacheRepo = ExerciseCacheRepository(
      ExerciseApiService(),
      exerciseCacheBox,
    );
    _imageCache = ExerciseImageCache();
    _initializer = AppInitializer(_cacheRepo, _imageCache, initBox);

    await _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() => _isLoading = true);

    final status = await _initializer.getStatus();

    setState(() {
      _status = status;
      _isLoading = false;
    });
  }

  Future<void> _clearExerciseCache() async {
    final confirm = await _showConfirmDialog(
      'Clear Exercise Cache',
      'This will delete all cached exercises. They will be re-downloaded next time you use the app.',
    );

    if (confirm == true) {
      await _cacheRepo.clearCache();
      await _loadStatus();
      _showSnackBar('Exercise cache cleared');
    }
  }

  Future<void> _clearImageCache() async {
    final confirm = await _showConfirmDialog(
      'Clear Image Cache',
      'This will delete all exercise images. They will be re-downloaded next time you view exercises.',
    );

    if (confirm == true) {
      await _imageCache.clearCache();
      await _loadStatus();
      _showSnackBar('Image cache cleared');
    }
  }

  Future<void> _resetAndRedownload() async {
    final confirm = await _showConfirmDialog(
      'Reset & Re-download',
      'This will clear all cached data and re-download everything. This may take a few minutes.',
    );

    if (confirm == true) {
      setState(() => _isLoading = true);

      await _initializer.resetInitialization();

      // Trigger re-initialization
      await _initializer.initialize(
        onProgress: (progress) {
          // You could show a progress dialog here
        },
      );

      await _loadStatus();
      _showSnackBar('Re-download complete');
    }
  }

  Future<bool?> _showConfirmDialog(String title, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cache & Data')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cache Status', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 16),
                        _buildStatusRow(
                          'Initialized',
                          _status?['initialized'] == true ? 'Yes' : 'No',
                          _status?['initialized'] == true
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const Divider(),
                        _buildStatusRow(
                          'Exercise Cache',
                          _status?['exercise_cache']?['has_exercises'] == true
                              ? 'Valid'
                              : 'Empty',
                          _status?['exercise_cache']?['is_valid'] == true
                              ? Colors.green
                              : Colors.red,
                        ),
                        if (_status?['exercise_cache']?['last_fetch'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              'Last fetch: ${_status?['exercise_cache']?['last_fetch']}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        const Divider(),
                        _buildStatusRow(
                          'Image Cache',
                          '${_status?['image_cache']?['count'] ?? 0} images',
                          Colors.blue,
                        ),
                        if (_status?['image_cache']?['size_mb'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(
                              'Size: ${_status?['image_cache']?['size_mb']} MB',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Actions
                Text('Actions', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),

                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh Status'),
                  subtitle: const Text('Reload cache information'),
                  onTap: _loadStatus,
                ),

                ListTile(
                  leading: Icon(Icons.clear, color: theme.colorScheme.error),
                  title: const Text('Clear Exercise Cache'),
                  subtitle: const Text('Delete cached exercise data'),
                  onTap: _clearExerciseCache,
                ),

                ListTile(
                  leading: Icon(
                    Icons.image_not_supported,
                    color: theme.colorScheme.error,
                  ),
                  title: const Text('Clear Image Cache'),
                  subtitle: const Text('Delete exercise images'),
                  onTap: _clearImageCache,
                ),

                ListTile(
                  leading: Icon(Icons.sync, color: theme.colorScheme.primary),
                  title: const Text('Reset & Re-download'),
                  subtitle: const Text('Clear all and download fresh data'),
                  onTap: _resetAndRedownload,
                ),

                const SizedBox(height: 24),

                // Info Card
                Card(
                  color: theme.colorScheme.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'About Cache',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Exercise data is cached for 30 days to improve performance '
                          'and reduce network usage. Images are stored locally for '
                          'offline access.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ],
    );
  }
}
