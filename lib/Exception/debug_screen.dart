import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:workout_app/Api/exercise_api_service.dart';
import 'package:workout_app/repository/exercise_cache_repository.dart';

class ApiDebugScreen extends StatefulWidget {
  const ApiDebugScreen({super.key});

  @override
  State<ApiDebugScreen> createState() => _ApiDebugScreenState();
}

class _ApiDebugScreenState extends State<ApiDebugScreen> {
  final List<String> _logs = [];
  bool _isLoading = false;

  static const String exerciseCacheBoxName = 'exercise_cache_box';

  void _log(String msg) {
    setState(() {
      _logs.add('[${DateTime.now().toString().substring(11, 19)}] $msg');
    });
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _logs.clear();
      _isLoading = true;
    });

    _log('🧪 Starting Exercise Cache Diagnostics');

    try {
      // Open cache
      final box = await Hive.openBox(exerciseCacheBoxName);
      final api = ExerciseApiService();
      final repo = ExerciseCacheRepository(api, box);

      _log('✓ Hive box opened');

      // Step 1: Cache status
      final info = repo.getCacheInfo();
      _log('📦 Cache valid: ${info['is_valid']}');
      _log('📊 Cached exercises: ${info['exercise_count']}');
      _log('🕒 Last fetch: ${info['last_fetch'] ?? 'Never'}');

      // Step 2: Load from cache if exists
      final cached = await repo.getAllExercisesFromCache();
      if (cached != null && cached.isNotEmpty) {
        _log('✅ Loaded ${cached.length} exercises from cache');
        _log('Sample: ${cached.first.name}');
      } else {
        _log('⚠️ No cached exercises found');
      }

      // Step 3: Force refresh from API
      _log('');
      _log('🌐 Forcing API refresh...');
      final fetched = await repo.fetchAndCacheAllExercises(forceRefresh: true);
      _log('✅ API fetch success: ${fetched.length} exercises');

      if (fetched.isNotEmpty) {
        _log('Sample from API: ${fetched.first.name}');
      }

      // Step 4: Re-read cache after refresh
      final afterRefresh = await repo.getAllExercisesFromCache();
      if (afterRefresh != null && afterRefresh.isNotEmpty) {
        _log('✅ Cache updated successfully');
        _log('Cached count now: ${afterRefresh.length}');
      } else {
        _log('❌ Cache empty after refresh (BUG)');
      }

      _log('');
      _log('🎉 Diagnostics completed successfully');
    } catch (e) {
      _log('❌ ERROR: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _copyLogs() {
    Clipboard.setData(ClipboardData(text: _logs.join('\n')));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logs copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Exercise Cache Debug'),
        actions: [
          if (_logs.isNotEmpty)
            IconButton(icon: const Icon(Icons.copy), onPressed: _copyLogs),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Run Diagnostics'),
                  onPressed: _runDiagnostics,
                ),
              ),
            ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _logs.isEmpty
                  ? const Center(
                      child: Text(
                        'Run diagnostics to see logs',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        Color color = Colors.white;

                        if (log.contains('✅')) color = Colors.greenAccent;
                        if (log.contains('❌')) color = Colors.redAccent;
                        if (log.contains('⚠️')) color = Colors.orangeAccent;
                        if (log.contains('🌐')) color = Colors.blueAccent;

                        return Text(
                          log,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: color,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
