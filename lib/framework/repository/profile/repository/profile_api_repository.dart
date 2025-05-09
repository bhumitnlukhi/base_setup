import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/provider/network/api_result.dart';
import 'package:odigo_vendor/framework/provider/network/dio/dio_client.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/contract/profile_repository.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/change_password_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/get_agency_document_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/get_vendor_document_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/profile_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/update_email.response_model.dart';

@LazySingleton(as: ProfileRepository, env: Env.environments)
class ProfileApiRepository extends ProfileRepository{
  final DioClient apiClient;
  ProfileApiRepository(this.apiClient);

  @override
  Future getProfileDetail() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.profileDetail);
      ProfileDetailResponseModel responseModel = profileDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  @override
  Future changePassword(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changePassword,request);
      ChangePasswordResponseModel responseModel = changePasswordResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Update the mobile no and the email
  @override
  Future updateEmailMobile(String request,bool isEmail) async{
    try {
      Response? response = await apiClient.putRequest(isEmail?ApiEndPoints.updateEmail:ApiEndPoints.updateContact,request);
      UpdateEmailResponseModel responseModel = updateEmailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Check Password API
  @override
  Future checkPassword(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.checkPassword,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Send Otp Api
  @override
  Future sendOtpApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.resendOTP,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  ///Get Vendor Documents Api
  @override
  Future getVendorDocumentsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getVendorDocuments(uuid));
      GetVendorDocumentResponseModel responseModel = getVendorDocumentResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


  ///Get Agency Documents Api
  @override
  Future getAgencyDocumentsApi(String uuid) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getAgencyDocuments(uuid));
      GetAgencyDocumentResponseModel responseModel = getAgencyDocumentResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Update Vendor Api
  @override
  Future updateVendorApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.signUpVendor,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Upload Vendor Documents Api
  @override
  Future uploadVendorDocumentsApi(FormData formData, String uuid) async {
    try {
      Response? response = await apiClient.postRequestFormData(ApiEndPoints.uploadVendorDocuments(uuid),formData);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Delete Vendor Document Api
  @override
  Future deleteVendorDocumentApi({required String request}) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.deleteVendorDocuments,request);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }


}