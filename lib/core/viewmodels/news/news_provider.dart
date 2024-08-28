import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pemob_uas/core/models/api/api_result.dart';
import 'package:pemob_uas/core/models/currency_model.dart';
import 'package:pemob_uas/core/models/news_model.dart';
import 'package:provider/provider.dart';

class NewsProvider extends ChangeNotifier {
  final Dio _dio = Dio();

  ApiResult<CurrencyTimeSeries> _timeSeries = ApiResult.initial();
  ApiResult<CurrencyTimeSeries> get timeSeries => _timeSeries;

  ApiResult<List<Article>> _news = ApiResult.initial();
  ApiResult<List<Article>> get news => _news;

  static NewsProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);

  Future<void> fetchTimeSeries() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _timeSeries = ApiResult.loading();
    notifyListeners();

    var lastWeek = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 10)));
    var currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    var param = {'from': 'USD', 'to': 'IDR'};

    final response = await _dio.get(
        'https://api.frankfurter.app/$lastWeek..$currentDate',
        queryParameters: param);

    if (response.statusCode == 200) {
      var result = response.data;
      _timeSeries = ApiResult.success(CurrencyTimeSeries.fromJson(result));
      notifyListeners();
    } else {
      _timeSeries = ApiResult.error('Failed to load currency data');
      notifyListeners();
      throw Exception('Failed to load currency data');
    }
  }

  Future<void> fetchNews() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _news = ApiResult.loading();
    notifyListeners();

    var param = {
      'country': 'id',
      'category': 'business',
      'apiKey': '405b0604b62c47fa8cb76f5ccd207287'
    };

    try {
      final response = await _dio.get('https://newsapi.org/v2/top-headlines',
          queryParameters: param);

      if (response.statusCode == 200) {
        var result = response.data;
        print(result);
        var list = result['articles'] as List;
        var mList = list.map((e) => Article.fromJson(e)).toList();
        _news = ApiResult.success(mList);
      } else {
        _news = ApiResult.error('Failed to load news');
        notifyListeners();
      }
    } catch (e, s) {
      print(e);
      print(s);
      _news = ApiResult.error(e.toString());
    }

    notifyListeners();
  }
}
