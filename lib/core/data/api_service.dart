import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/web.dart';
import 'package:pemob_uas/core/models/product_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl =
      "https://hfidz-dev.my.id/pemob-uas/api";
  final Logger _logger = Logger();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 15);

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (object) => _logger.i(object.toString()),
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          _logger.e('DioError: ${e.message}',
              error: e, stackTrace: e.stackTrace);
          return handler.next(e);
        },
      ),
    );
  }

  Future<dynamic> _handleRequest<T>(
      Future<Response<T>> Function() requestFunction) async {
    try {
      final response = await requestFunction();
      if (response.data is String) {
        // If the response is a string, try to parse it as JSON
        return json.decode(response.data as String);
      }
      return response.data;
    } on DioException catch (e) {
      _logger.e('DioException', error: e, stackTrace: e.stackTrace);
      if (e.response != null) {
        _logger.e('Response data: ${e.response?.data}');
        _logger.e('Response headers: ${e.response?.headers}');
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out');
      } else if (e.type == DioExceptionType.badResponse) {
        // throw Exception('Server error: ${e.response?.statusCode}');
        // return e.response;

        if (!e.response!.statusCode.toString().startsWith('2')) {
          final errorData = json.decode(e.response?.data);
          if (errorData is Map<String, dynamic> &&
              errorData.containsKey('error')) {
            throw Exception(errorData['error']);
          }
        }
      } else {
        throw Exception('An error occurred: ${e.message}');
      }
    } catch (e, stackTrace) {
      _logger.e('Unexpected error', error: e, stackTrace: stackTrace);
      throw Exception('An unexpected error occurred');
    }
  }

  Future<Map<String, dynamic>> login(
      String email, String password, String fID) async {
    final response = await _handleRequest(() => _dio.post('/auth/login',
        data: {'email': email, 'password': password, 'fcm_token': fID}));

    return await response;
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password, String fID) async {
    var data = {
      'username': name,
      'email': email,
      'password': password,
      'fcm_token': fID
    };
    print('data:$data');
    final response =
        await _handleRequest(() => _dio.post('/auth/register', data: data));

    return response;
  }

  Future<List<dynamic>> getProducts(bool isAdmin) async {
    var path = '/products';
    if (isAdmin) path = '/admin/products';

    final response = await _handleRequest(
      () => _dio.get(path),
    );

    return response;
  }

  Future<Map<String, dynamic>> createProduct(ProductModel data) async {
    final param = {
      'name': data.productName,
      'description': data.productDesc,
      'price': data.productPrice,
      'stock': data.productStock,
      'is_publish': data.isPublish,
    };

    final response = await _handleRequest(
      () => _dio.post('/admin/products', data: param),
    );

    return response;
  }

  Future<Map<String, dynamic>> updateProduct(ProductModel data) async {
    final param = {
      'name': data.productName,
      'description': data.productDesc,
      'price': data.productPrice,
      'stock': data.productStock,
      'is_publish': data.isPublish,
    };

    final response = await _handleRequest(
      () => _dio.put('/admin/products/${data.productId}', data: param),
    );

    return response;
  }

  Future<Map<String, dynamic>> deleteProduct(id) async {
    final response = await _handleRequest(
      () => _dio.delete(
        '/admin/products/$id',
      ),
    );

    return response;
  }

  Future<List<dynamic>> getCart(int id) async {
    final response = await _handleRequest(() => _dio.get('/cart/$id'));

    if (response == null) {
      return [];
    }

    if (response.containsKey('items')) {
      return json.decode(response['items']);
    }

    return response;
  }

  Future<Map<String, dynamic>> addToCart(Map<String, dynamic> data) async {
    final response =
        await _handleRequest(() => _dio.post('/cart/items', data: data));

    return response;
  }

  Future<Map<String, dynamic>> removeCartItem(Map<String, dynamic> data) async {
    final response =
        await _handleRequest(() => _dio.delete('/cart/items', data: data));

    return response;
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response =
        await _handleRequest(() => _dio.post('/orders', data: data));

    return response;
  }

  Future<List<dynamic>> getOrders(int userId) async {
    final response = await _handleRequest(() => _dio.get('/orders/$userId'));

    return response ?? [];
  }

  Future<List<dynamic>> getAllOrders() async {
    final response = await _handleRequest(() => _dio.get('/admin/orders'));

    return response ?? [];
  }

  Future<Map<String, dynamic>> updateStatus(id, status) async {
    final response = await _handleRequest(
        () => _dio.put('/admin/orders/$id/status', data: {'status': status}));

    return response;
  }
}
