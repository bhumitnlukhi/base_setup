import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/home/contract/home_repository.dart';
import 'package:odigo_vendor/framework/repository/home/model/reponse_model/vendor_dashboard_reponse_model.dart';

@LazySingleton(as: HomeRepository, env: Env.environments)
class HomeApiRepository extends HomeRepository{
  final DioClient apiClient;
  HomeApiRepository(this.apiClient);

  /// Vendor Dashboard Api
  @override
  Future vendorDashboardApi(int date) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.vendorDashboard(date));
      VendorDashboardResponseModel responseModel = vendorDashboardResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
  @override
  Future registerDeviceApi(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.registerDevice,request);
      CommonResponseModel responseModel =  commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
  @override
  Future deleteDeviceTokenApi(String deviceId) async{
    try {
      Response? response = await apiClient.deleteRequest(ApiEndPoints.deleteDeviceToken(deviceId),'');
      CommonResponseModel responseModel =  commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}