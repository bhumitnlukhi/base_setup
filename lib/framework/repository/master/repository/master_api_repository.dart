import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/master/contract/master_repository.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/business_category_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/city_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/countrt_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/state_list_response_model.dart';

@LazySingleton(as: MasterRepository, env: Env.environments)
class MasterApiRepository implements MasterRepository{
  final DioClient apiClient;
  MasterApiRepository(this.apiClient);


  @override
  Future businessCategoryApi(BuildContext context, int pageNumber,String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.businessCategoryList(pageNumber),request);
      BusinessCategoryListResponseModel responseModel = businessCategoryListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future cityListApi(BuildContext context, int pageNumber,String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.cityList(pageNumber),request);
      CityListResponseModel responseModel = cityListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future countryListApi(BuildContext context, int pageNumber,String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.countryList(pageNumber),request);
      CountryListResponseModel responseModel = countryListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future stateListApi(BuildContext context, int pageNumber,String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.stateList(pageNumber),request);
      StateListResponseModel responseModel = stateListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
