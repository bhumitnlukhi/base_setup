import 'package:flutter_base_setup/framework/provider/network/dio/dio_logger.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DioLoggerModule {
  @LazySingleton(env: ['debug','production'])
  DioLogger getDioLogger() {
    final dioLogger = DioLogger();
    return dioLogger;
  }
}

