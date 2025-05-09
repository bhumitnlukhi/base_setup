import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/language_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/login_response_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/sign_up_response_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/verify_otp_for_sign_up_response_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/cms_response_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';

@LazySingleton(as: AuthRepository, env: Env.environments)
class AuthApiRepository extends AuthRepository{
  final DioClient apiClient;
  AuthApiRepository(this.apiClient);

  /// Login Api
  @override
  Future loginApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.login,request,isTokenRequiredInHeader: false);
      LoginResponseModel responseModel = loginResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// SignUp Api
  @override
  Future signUpApi(String request) async {
    try {
      Response? response = await apiClient.postRequest((Session.getUserType().toString()==UserType.VENDOR.name)?ApiEndPoints.signUpVendor:ApiEndPoints.signUpAgency,request,isTokenRequiredInHeader: false);
      SignUpResponseModel responseModel = signUpResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Forgot Password Api
  @override
  Future forgotPasswordApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.forgotPassword,request,isTokenRequiredInHeader: false);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Verify Otp Api
  @override
  Future verifyOtpApi(String request) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.verifyOTPForgotPassword,request, isTokenRequiredInHeader: false);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Verify Otp Api
  @override
  Future verifyOtpForSignUpApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.verifyOTP,request, isTokenRequiredInHeader: false);
      VerifyOtpResponseModel responseModel = verifyOtpResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Reset Password Api
  @override
  Future resetPasswordApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.resetPassword,request,isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
  /// Resend Otp Api
  @override
  Future resendOtpApi(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.resendOTP,request, isTokenRequiredInHeader: false);
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
      Response? response = await apiClient.postRequest(ApiEndPoints.resendOTP,request, isTokenRequiredInHeader: false);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  ///Agency Registration Api
  @override
  Future cmsAPI(String cmsType) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.cms(cmsType),  isTokenRequiredInHeader: Session.getUserAccessToken() != '');
      CmsResponseModel responseModel = cmsResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  /// Add Contact Us Api
  @override
  Future addContactUsAPI(String request) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.contactUs,request, isTokenRequiredInHeader: false);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future logoutApi(String uniqueDeviceId) async {
    try {
      Response? response = await apiClient.deleteRequest(ApiEndPoints.logout(uniqueDeviceId), '{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<LanguageListResponseModel>> languageApi() async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.language, isTokenRequiredInHeader: false);
      LanguageListResponseModel responseModel = languageListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future<ApiResult<CommonResponseModel>> changeLanguageApi(String languageUuid) async {
    try {
      Response? response = await apiClient.putRequest(ApiEndPoints.changeLanguage(languageUuid), '{}');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);

    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}