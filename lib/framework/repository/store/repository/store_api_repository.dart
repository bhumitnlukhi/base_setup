import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/contract/store_repository.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_details_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_language_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';

@LazySingleton(as: StoreRepository, env: Env.environments)
class StoreApiRepository implements StoreRepository {
  final DioClient apiClient;

  StoreApiRepository(this.apiClient);

  ///store list Api
  @override
  Future<ApiResult<StoreListResponseModel>> storeListApi({required String request, required String uuid, required int pageNumber, required int dataSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.storeList(uuid, pageNumber,dataSize ), request);
      StoreListResponseModel responseModel = storeListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///all odigo list Api
  @override
  Future<ApiResult<StoreListResponseModel>> odigoStoreListApi({required String request, required int pageNumber, int? pageSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.odigoStoreList(pageNumber, pageSize: pageSize), request,isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      StoreListResponseModel responseModel = storeListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///store list Api
  @override
  Future<ApiResult<StoreDetailsResponseModel>> storeDetailApi({required String storeUuid, required bool forOdigoStore}) async {
    try {
      Response? response;
      if(forOdigoStore == true) {
        response = await apiClient.getRequest(ApiEndPoints.odigoStoreDetails(storeUuid));
      } else {
        response = await apiClient.getRequest(ApiEndPoints.vendorStoreDetails(storeUuid));

      }
      StoreDetailsResponseModel responseModel = storeDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///store list Api
  @override
  Future<ApiResult<CommonResponseModel>> updateStoreStatusApi({required String storeUuid, required String status}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateStoreStatus(storeUuid, status), jsonEncode({}), isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<DestinationListResponseModel>> destinationListApi({required String request, required int pageNumber, int? pageSize}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.destinationList(pageNumber, pageSize: pageSize), request);
      DestinationListResponseModel responseModel = destinationListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<CommonResponseModel>> assignStoreApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.assignOdigoStore, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<StoreLanguageDetailResponseModel>> storeDetailLanguageApi({required String storeUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.storeDetail(storeUuid));

      StoreLanguageDetailResponseModel responseModel = storeLanguageDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
