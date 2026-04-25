import 'package:dio/dio.dart';
import '../error/failures.dart';

class NetworkClient {
  final Dio dio;

  NetworkClient(this.dio);

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<dynamic> post(String url, {dynamic data}) async {
    try {
      final response = await dio.post(url, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  void _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkFailure('No internet connection');
    } else if (e.response != null) {
      throw ServerFailure('Server error: ${e.response?.statusCode}');
    } else {
      throw ServerFailure('Unexpected error occurred');
    }
  }
}
