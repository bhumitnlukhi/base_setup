import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/language_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';

abstract class AuthRepository {
  ///Login Api
  Future loginApi(String request);

  ///SignUp Api
  Future signUpApi(String request);

  ///Forgot Password Api
  Future forgotPasswordApi(String request);

  ///Verify OTP Api
  Future verifyOtpApi(String request);

  ///Reset Password Api
  Future resetPasswordApi(String request);

  ///Resend OTP Api
  Future resendOtpApi(String request);

  ///Send Otp Api
  Future sendOtpApi(String request);

  ///Verify OTP Api
  Future verifyOtpForSignUpApi(String request);

  ///CMS Api
  Future cmsAPI(String type);

  ///CMS Api
  Future addContactUsAPI(String request);

  /// Logout API
  Future logoutApi(String uniqueDeviceId);

  /// Language Api
  Future<ApiResult<LanguageListResponseModel>> languageApi();

  /// Change Language Api
  Future<ApiResult<CommonResponseModel>> changeLanguageApi(String languageUuid);
}
