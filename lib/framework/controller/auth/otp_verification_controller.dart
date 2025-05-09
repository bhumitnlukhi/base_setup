import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/resend_otp_request_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/send_otp_request_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/verify_otp_for_sign_up_request_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/verify_otp_request_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/verify_otp_for_sign_up_response_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';

final otpVerificationController = ChangeNotifierProvider(
      (ref) => getIt<OtpVerificationController>(),
);

@injectable
class OtpVerificationController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10),(){
      formKey.currentState?.reset();
    });
    isAllFieldsValid = false;
    otpController.clear();
    counter?.cancel();
    startCounter();
    counterSeconds = 30;
    sendOtpState.success = null;
    sendOtpState.isLoading = false;
    resendOtpState.success = null;
    resendOtpState.isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  ///Check Validity of all fields
  bool isAllFieldsValid = false;

  ///Update the value of is all fields valid
  void checkIfAllFieldsValid() {
    isAllFieldsValid = (validateOtp(otpController.text) == null);
    notifyListeners();
  }

  ///For Counter
  int counterSeconds = 30;
  Timer? counter;

  ///Start Counter
  void startCounter() {
    counterSeconds = 30;
    const oneSec = Duration(seconds: 1);
    counter = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (counterSeconds == 0) {
          timer.cancel();
        } else {
          counterSeconds = counterSeconds - 1;
        }
        notifyListeners();
      },
    );
  }

  ///Set Counter Seconds
  String getCounterSeconds() {
    int minutes = (counterSeconds ~/ 60);
    int seconds = counterSeconds - (minutes * 60);
    if (seconds < 10) {
      return '0$minutes:0$seconds';
    }
    return '0$minutes:$seconds';
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  AuthRepository authRepository;
  OtpVerificationController(this.authRepository);

  var verifyOtpState = UIState<CommonResponseModel>();


  /// Verify Otp API
  Future<void> verifyOtpApi(BuildContext context, String email) async {
    verifyOtpState.isLoading = true;
    verifyOtpState.success = null;
    notifyListeners();

    VerifyOtpRequestModel requestModel = VerifyOtpRequestModel(email: email.trimSpace, userType: Session.getUserType(), type: 'EMAIL', sendingType: 'OTP', otp: otpController.text.trimSpace);
    String request = verifyOtpRequestModelToJson(requestModel);

    final result = await authRepository.verifyOtpApi(request);

    result.when(success: (data) async {
      verifyOtpState.success = data;
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    verifyOtpState.isLoading = false;
    notifyListeners();
  }

  var resendOtpState = UIState<CommonResponseModel>();

  /// Resend Otp API
  Future<void> resendOtpApi(BuildContext context, {String? email,String? mobileNo}) async {
    resendOtpState.isLoading = true;
    resendOtpState.success = null;
    notifyListeners();


    ResendOtpRequestModel requestModel = ResendOtpRequestModel(email: email?.trimSpace, userType: Session.getUserType(), type: 'EMAIL', sendingType: 'OTP', verifyBeforeGenerate: false);
    String request = resendOtpRequestModelToJson(requestModel);

    final result = await authRepository.resendOtpApi(request);

    result.when(success: (data) async {
      resendOtpState.success = data;
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    resendOtpState.isLoading = false;
    notifyListeners();
  }

  var sendOtpState = UIState<CommonResponseModel>();

  /// Send Otp API
  Future<void> sendOtpApi(BuildContext context, {String? email, String? mobileNo,String? userUuid}) async {
    sendOtpState.isLoading = true;
    sendOtpState.success = null;
    notifyListeners();

    String type = (email != null) ? 'EMAIL' : 'SMS';
    SendOtpRequestModel requestModel = SendOtpRequestModel(
        uuid: userUuid ?? '', email: email?.trimSpace ?? '', contactNumber: mobileNo?.trimSpace ?? '', userType: (Session.getUserType().toString()==UserType.VENDOR.name)?UserType.VENDOR.name:UserType.AGENCY.name, type: type, sendingType: 'OTP', verifyBeforeGenerate: false);
    String request = sendOtpRequestModelToJson(requestModel);

    final result = await authRepository.sendOtpApi(request);

    result.when(success: (data) async {
      sendOtpState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    sendOtpState.isLoading = false;
    notifyListeners();
  }

  var verifyOtpForSignUpState = UIState<VerifyOtpResponseModel>();


  /// Verify Otp API
  Future<void> verifyOtpForSignUpApi(BuildContext context, String password,{bool? isSignUp=false,String? uuid,String? email}) async {
    verifyOtpForSignUpState.isLoading = true;
    verifyOtpForSignUpState.success = null;
    notifyListeners();

    VerifyOtpForSignUpRequestModel requestModel = VerifyOtpForSignUpRequestModel(password: password.trimSpace, userType: Session.getUserType(), type: 'EMAIL', sendingType: 'OTP', otp: otpController.text.trimSpace,uuid: uuid);
    String request = verifyOtpForSignUpRequestModelToJson(requestModel);

    final result = await authRepository.verifyOtpForSignUpApi(request);

    result.when(success: (data) async {
      verifyOtpForSignUpState.success = data;
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    verifyOtpForSignUpState.isLoading = false;
    notifyListeners();
  }
}
