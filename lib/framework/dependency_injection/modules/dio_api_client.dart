import 'package:flutter_base_setup/framework/provider/network/dio/dio_client.dart';
import 'package:flutter_base_setup/framework/provider/network/dio/dio_logger.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';


@module
abstract class NetworkModule {
  @LazySingleton(env: ['production'])
  DioClient getProductionDioClient(DioLogger dioLogger) {
    final dio = Dio(
      BaseOptions(
        baseUrl: '',
      ),
    );
    // dio.interceptors.add(dioLogger);
    final client = DioClient(dio);
    return client;
  }

  @LazySingleton(env: ['debug'])
  DioClient getDebugDioClient(DioLogger dioLogger) {
    final dio = Dio(
      BaseOptions(
        baseUrl: '',
      ),
    );
    dio.interceptors.add(dioLogger);
    final client = DioClient(dio);
    return client;
  }



}

