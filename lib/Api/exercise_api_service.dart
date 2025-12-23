import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workout_app/Api/key.dart';
import 'package:workout_app/Exception/api_exception.dart';
import 'package:workout_app/Exception/logger.dart';
import 'package:workout_app/models/api_exercise.dart';
import 'package:workout_app/models/api_meta.dart';

class ExerciseApiService {
  static const String baseUrl = 'https://api.workoutapi.com/v1';
  final String apiKey = API_KEY;

  /// Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Accept-Language': 'en-US',
    'x-api-key': apiKey,
  };

  /// Fetch ALL exercises from the API (called during app initialization)
  /// API Endpoint: GET /v1/exercises
  Future<List<ApiExercise>> getAllExercises() async {
    try {
      AppLogger.info('📥 Fetching all exercises from API...', tag: 'API');

      final response = await http.get(
        Uri.parse('$baseUrl/exercises'),
        headers: _headers,
      );

      AppLogger.debug('Response Status: ${response.statusCode}', tag: 'API');

      if (response.statusCode == 200) {
        try {
          final List data = jsonDecode(response.body);
          AppLogger.info(
            '✅ Successfully fetched ${data.length} exercises',
            tag: 'API',
          );

          // Log sample exercise for debugging
          if (data.isNotEmpty) {
            AppLogger.debug('Sample exercise: ${data[0]}', tag: 'API');
          }

          return data.map((e) => ApiExercise.fromJson(e)).toList();
        } catch (e) {
          AppLogger.error('JSON parsing error', tag: 'API', error: e);
          throw ExerciseApiException(
            message: 'Failed to parse exercise data',
            statusCode: response.statusCode,
            userFriendlyMessage:
                'We received unexpected data from the server. Please try again.',
          );
        }
      } else {
        final error = _parseErrorResponse(response.body);
        AppLogger.error(
          '❌ API Error ${response.statusCode}: $error',
          tag: 'API',
        );
        throw ExerciseApiException.fromResponse(response.statusCode, error);
      }
    } on http.ClientException catch (e) {
      AppLogger.error('Network error', tag: 'API', error: e);
      throw ExerciseApiException.networkError(e.message);
    } on ExerciseApiException {
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in getAllExercises',
        tag: 'API',
        error: e,
        stackTrace: stackTrace,
      );
      throw ExerciseApiException(
        message: 'Unexpected error: ${e.toString()}',
        userFriendlyMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Fetch all muscle groups
  /// API Endpoint: GET /v1/muscles
  Future<List<ApiMeta>> fetchMuscles() async {
    try {
      AppLogger.debug('Fetching muscles metadata', tag: 'API');

      final response = await http.get(
        Uri.parse('$baseUrl/muscles'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        AppLogger.info('✅ Fetched ${data.length} muscle groups', tag: 'API');
        return data.map((e) => ApiMeta.fromJson(e)).toList();
      } else {
        final error = _parseErrorResponse(response.body);
        AppLogger.error('❌ Fetch muscles failed: $error', tag: 'API');
        throw ExerciseApiException.fromResponse(response.statusCode, error);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching muscles',
        tag: 'API',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Fetch all categories
  /// API Endpoint: GET /v1/categories
  Future<List<ApiMeta>> fetchCategories() async {
    try {
      AppLogger.debug('Fetching categories metadata', tag: 'API');

      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        AppLogger.info('✅ Fetched ${data.length} categories', tag: 'API');
        return data.map((e) => ApiMeta.fromJson(e)).toList();
      } else {
        final error = _parseErrorResponse(response.body);
        AppLogger.error('❌ Fetch categories failed: $error', tag: 'API');
        throw ExerciseApiException.fromResponse(response.statusCode, error);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching categories',
        tag: 'API',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Fetch all types
  /// API Endpoint: GET /v1/types
  Future<List<ApiMeta>> fetchTypes() async {
    try {
      AppLogger.debug('Fetching types metadata', tag: 'API');

      final response = await http.get(
        Uri.parse('$baseUrl/types'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        AppLogger.info('✅ Fetched ${data.length} types', tag: 'API');
        return data.map((e) => ApiMeta.fromJson(e)).toList();
      } else {
        final error = _parseErrorResponse(response.body);
        AppLogger.error('❌ Fetch types failed: $error', tag: 'API');
        throw ExerciseApiException.fromResponse(response.statusCode, error);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error fetching types',
        tag: 'API',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Helper method to parse error response
  String _parseErrorResponse(String body) {
    try {
      if (body.isEmpty) return 'Empty error response';
      final json = jsonDecode(body);
      return json['error']?.toString() ??
          json['message']?.toString() ??
          'No error message provided';
    } catch (e) {
      return 'Could not parse error response: ${body.length > 100 ? '${body.substring(0, 100)}...' : body}';
    }
  }
}
