class ServerException implements Exception {
  final String message;
  final int? code;

  ServerException({required this.message, this.code});

  @override
  String toString() {
    return 'ServerException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}
