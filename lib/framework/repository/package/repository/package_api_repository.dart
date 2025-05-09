import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/contract/package_repository.dart';
import 'package:odigo_vendor/framework/repository/package/model/client_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/package_limit_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/package_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/package_wallet_history_response_model.dart';

@LazySingleton(as: PackageRepository, env: Env.environments)
class PackageApiRepository implements PackageRepository{
  final DioClient apiClient;
  PackageApiRepository(this.apiClient);

  ///package list Api
  @override
  Future packageListApi({required String request, required int pageNumber}) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.packageList(pageNumber), request);
      PackageListResponseModel responseModel = packageListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// purchase package api
  @override
  Future purchasePackageApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.purchasePackage, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future destinationDetailApi({required String destinationUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.destinationDetail(destinationUuid));
      DestinationDetailsResponseModel responseModel = destinationDetailsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future destinationListApi({required String request, required int pageNumber, bool? forVendor = false, int? dataSize}) async {
    try {
      Response? response;
      if(forVendor==true){
        response = await apiClient.postRequest(ApiEndPoints.destinationListForVendor, request);
      } else{
        response = await apiClient.postRequest(ApiEndPoints.destinationList(pageNumber, pageSize: dataSize), request);
      }

      DestinationListResponseModel responseModel = destinationListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future clientListApi({required String request, required int pageNumber}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.clientList(pageNumber), request);
      ClientListResponseModel responseModel = clientListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future clientStatusUpdateApi(String request, String clientId, bool status) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.clientStatusUpdate(clientId, status),request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future packageWalletHistoryApi({required String request,required  String packageUuid,required  int pageNo}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.packageWalletHistoryApi(packageUuid, pageNo), request);
      PackageWalletHistoryResponseModel responseModel = packageWalletHistoryResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future packageLimitApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.purchaseLimit, request);
      PackageLimitResponseModel responseModel = packageLimitResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}