// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i409;
import 'package:flutter_base_setup/framework/dependency_injection/modules/dio_api_client.dart'
    as _i561;
import 'package:flutter_base_setup/framework/dependency_injection/modules/dio_looger_module.dart'
    as _i514;
import 'package:flutter_base_setup/framework/provider/network/dio/dio_client.dart'
    as _i1063;
import 'package:flutter_base_setup/framework/provider/network/dio/dio_logger.dart'
    as _i742;
import 'package:flutter_base_setup/ui/routing/delegate.dart' as _i813;
import 'package:flutter_base_setup/ui/routing/navigation_stack_item.dart'
    as _i939;
import 'package:flutter_base_setup/ui/routing/parser.dart' as _i10;
import 'package:flutter_base_setup/ui/routing/stack.dart' as _i940;
import 'package:flutter_riverpod/flutter_riverpod.dart' as _i729;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

const String _debug = 'debug';
const String _production = 'production';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioLoggerModule = _$DioLoggerModule();
    final networkModule = _$NetworkModule();
    gh.factoryParam<_i813.MainRouterDelegate, _i940.NavigationStack, dynamic>((
      stack,
      _,
    ) =>
        _i813.MainRouterDelegate(stack));
    gh.lazySingleton<_i742.DioLogger>(
      () => dioLoggerModule.getDioLogger(),
      registerFor: {
        _debug,
        _production,
      },
    );
    gh.factoryParam<_i10.MainRouterInformationParser, _i729.WidgetRef,
        _i409.BuildContext>((
      ref,
      context,
    ) =>
        _i10.MainRouterInformationParser(
          ref,
          context,
        ));
    gh.lazySingleton<_i1063.DioClient>(
      () => networkModule.getProductionDioClient(gh<_i742.DioLogger>()),
      registerFor: {_production},
    );
    gh.factoryParam<_i940.NavigationStack, List<_i939.NavigationStackItem>,
        dynamic>((
      items,
      _,
    ) =>
        _i940.NavigationStack(items));
    gh.lazySingleton<_i1063.DioClient>(
      () => networkModule.getDebugDioClient(gh<_i742.DioLogger>()),
      registerFor: {_debug},
    );
    return this;
  }
}

class _$DioLoggerModule extends _i514.DioLoggerModule {}

class _$NetworkModule extends _i561.NetworkModule {}
