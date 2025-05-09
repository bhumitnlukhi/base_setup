import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/ads/contract/ads_repository.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/ad_content_response_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/ads_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/ads_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/assigned_store_list_for_destination_response_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/create_ad_response_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';

@LazySingleton(as: AdsRepository, env: Env.environments)
class AdsApiRepository implements AdsRepository{
  final DioClient apiClient;
  AdsApiRepository(this.apiClient);


  @override
  Future createAdApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.createAd, request);
      CreateAdResponseModel responseModel = createAdResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future addAdsContentApi({required FormData formData, required String adUuid,ProgressCallback? onSendProgress}) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.addAdsContent(adUuid), formData,onSendProgress: onSendProgress);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future adsDetailApi({required String adUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.adsDetail(adUuid));
      AdsDetailResponseModel responseModel = adsDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future archiveAd({required String adUuid}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.archiveAd(adUuid), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeStatusOfAd({required String adUuid, required String status}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeStatusOfAd(adUuid, status), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future changeStatusOfDefaultAd({required String adUuid}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeStatusOfDefaultAd(adUuid), null);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getAdsContentApi({required String request, required int pageNo}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getAdsContent(pageNo), request);
      AdContentResponseModel responseModel = adContentResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future adListApi({required String request, required int pageNo}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.adList(pageNo), request);
      AdsListResponseModel responseModel = adsListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future assignedStoreListForDestinationApi({required String destinationUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.assignedStoreListForDestination(destinationUuid));
      AssignedStoreListForDestinationResponseModel responseModel = assignedStoreListForDestinationResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
