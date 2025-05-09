import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/client_master/contract/client_master_repository.dart';
import 'package:odigo_vendor/framework/repository/client_master/model/response/client_add_response_model.dart';
import 'package:odigo_vendor/framework/repository/client_master/model/response/client_detail_response_model.dart';

@LazySingleton(as: ClientMasterRepository, env: Env.environments)
class ClientMasterApiRepository implements ClientMasterRepository{
  final DioClient apiClient;
  ClientMasterApiRepository(this.apiClient);

  ///demo Api
  @override
  Future addClientApi(String request,bool isEdit) async{
    try {
      Response? response = isEdit ?
      await apiClient.putRequest(ApiEndPoints.addClientApi, request):
      await apiClient.postRequest(ApiEndPoints.addClientApi, request);
      ClientAddResponseModel responseModel = clientAddResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future clientDetailsApi(String clientId) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.clientDetailsApi(clientId));
      ClientDetailResponseModel responseModel = clientDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

}
