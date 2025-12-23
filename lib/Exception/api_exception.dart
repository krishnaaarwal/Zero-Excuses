class ExerciseApiException implements Exception {
  final int statusCode;
  final String message;
  final String userFriendlyMessage;

  ExerciseApiException({
    required this.message,
    this.statusCode = 0, // Default to 0 for network/unknown errors
    this.userFriendlyMessage =
        'An unexpected error occurred. Please try again.',
  });

  factory ExerciseApiException.fromResponse(
    int statusCode,
    String errorMessage,
  ) {
    String userFriendlyMessage;

    switch (statusCode) {
      case 400:
        userFriendlyMessage =
            'Invalid request. Please check your filter selections and try again.';
        break;
      case 401:
        userFriendlyMessage =
            'Authentication failed. Please restart the app or contact support.';
        break;
      case 403:
        userFriendlyMessage =
            'Access denied. Please upgrade your plan or contact support.';
        break;
      case 429:
        userFriendlyMessage =
            'Too many requests. Please wait a moment and try again.';
        break;
      case 500:
        userFriendlyMessage =
            'Server is experiencing issues. Please try again later.';
        break;
      default:
        userFriendlyMessage = 'Something went wrong. Please try again.';
    }

    return ExerciseApiException(
      statusCode: statusCode,
      message: errorMessage,
      userFriendlyMessage: userFriendlyMessage,
    );
  }

  factory ExerciseApiException.networkError(String message) {
    return ExerciseApiException(
      message: message,
      statusCode: 0,
      userFriendlyMessage:
          'No internet connection. Please check your network and try again.',
    );
  }

  @override
  String toString() => 'ExerciseApiException: $statusCode - $message';
}
