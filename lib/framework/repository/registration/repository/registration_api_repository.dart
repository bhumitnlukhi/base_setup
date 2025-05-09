import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/agnecy_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/contract/registration_repository.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/city_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/country_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/state_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';

@LazySingleton(as: RegistrationRepository, env: Env.environments)
class RegistrationApiRepository extends RegistrationRepository {
  final DioClient apiClient;

  RegistrationApiRepository(this.apiClient);

  ///Get Store List
  @override
  Future storeListApi({required String destinationUuid}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getStoreList(destinationUuid), isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      AssignStoreListResponseModel responseModel = storeListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Destination list Api
  @override
  Future destinationListApi({required String request, bool? forVendor = false}) async {
    try {
      Response? response;
      if (forVendor == true) {
        response = await apiClient.postRequest(ApiEndPoints.destinationListForVendor, request, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      } else {
        response = await apiClient.postRequest(ApiEndPoints.getDestinationList, request, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      }

      DestinationListResponseModel responseModel = destinationListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Upload Vendor Documents Api
  @override
  Future uploadVendorDocumentsApi(FormData formData, String uuid) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.uploadVendorDocuments(uuid), formData, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Upload Odigo Store Api
  @override
  Future uploadOdigoStoreApi({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.uploadOdigoStore, request, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Country list
  @override
  Future countryList(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getCountryList, request, isTokenRequiredInHeader: false);
      CountryListResponseModel responseModel = countryListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// State list
  @override
  Future stateList(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getStateList, request, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      StateListResponseModel responseModel = stateListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// City list
  @override
  Future cityList(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getCityList, request, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CityListResponseModel responseModel = cityListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Upload Agency Documents Api
  @override
  Future uploadAgencyDocumentsApi(FormData formData, String uuid) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.uploadAgencyDocuments(uuid), formData, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Agency Registration Api
  @override
  Future agencyRegistrationApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.agencyRegistration, request, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Get Agency Details Api
  @override
  Future getAgencyDetailsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getAgencyDetailByUuid(uuid));
      GetAgencyDetailResponseModel responseModel = getAgencyDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Delete Agency Document Api
  @override
  Future deleteAgencyDocumentApi({required String request}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.deleteAgencyDocuments, request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Update Agency Name Api
  @override
  Future updateAgencyNameAPI(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.updateAgencyName, request, isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
