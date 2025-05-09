import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/wallet/contract/wallet_repository.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/response/vendor_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/response/wallet_amount_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';

@LazySingleton(as: WalletRepository, env: Env.environments)
class WalletApiRepository implements WalletRepository{
  final DioClient apiClient;
  WalletApiRepository(this.apiClient);

  @override
  Future addWalletAmountApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addWalletAmount, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getWalletHistoryApi(String request, int pageNo) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getWalletHistory(pageNo), request);
      WalletAmountListResponseModel responseModel = walletAmountListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getVendorDetailApi() async {
    try {
      Response? response;
      if(Session.getUserType() == UserType.VENDOR.name){
        response = await apiClient.getRequest(ApiEndPoints.vendorDetail(Session.getUuid()));
      } else{
        response = await apiClient.getRequest(ApiEndPoints.agencyDetail(Session.getUuid()));
      }
      VendorDetailResponseModel responseModel = vendorDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }








}
