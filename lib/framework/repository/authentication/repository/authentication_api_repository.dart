import 'package:flutter_base_setup/framework/provider/network/dio/dio_client.dart';
import 'package:flutter_base_setup/framework/repository/authentication/contract/authentication_repository.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationApiRepository implements AuthenticationRepository {
  final DioClient apiClient;

  AuthenticationApiRepository(this.apiClient);

  @override
  Future loginApi(BuildContext context, Map<String, dynamic> request) async {
    // try {
    //   Response apiResponse = await apiClient.postData(ApiEndPoints.login, request);
    //
    //   BaseResponseModel baseResponse = baseResponseModelFromJson(json.encode(apiResponse.data));
    //
    //   if (baseResponse.status != ApiEndPoints.apiStatus_200) {
    //     return ApiResult.failure(
    //         error: NetworkExceptions.defaultError(baseResponse.message!));
    //   } else {
    //     return ApiResult.success(data: baseResponse.data);
    //   }
    // } catch (err) {
    //   return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    // }
  }

}
