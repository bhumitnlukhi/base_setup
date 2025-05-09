import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/send_otp_request_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/contract/profile_repository.dart';
import 'package:odigo_vendor/framework/repository/profile/model/request_model/change_password_request_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/request_model/check_password_request_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/request_model/update_email._request_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/request_model/update_mobile_number_request_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/change_password_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/get_agency_document_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/get_vendor_document_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/profile_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/update_email.response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:url_launcher/url_launcher.dart';

final profileController = ChangeNotifierProvider(
  (ref) => getIt<ProfileController>(),
);

@injectable
class ProfileController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    profileDetailState.success = null;
    profileDetailState.isLoading = true;
    counter?.cancel();
    isLoading = false;
    getVendorDocumentsState.isLoading = false;
    getVendorDocumentsState.success = null;
    getAgencyDocumentsState.isLoading = false;
    getAgencyDocumentsState.success = null;
    startCounter();
    counterSeconds = 30;
    if (isNotify) {
      notifyListeners();
    }
  }

  void disposeKeys() {
    Future.delayed(const Duration(milliseconds: 100), () {
      changePasswordKey.currentState?.reset();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      changeEmailKey.currentState?.reset();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      emailVerifyOtpKey.currentState?.reset();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      changeMobileKey.currentState?.reset();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      mobileVerifyOtpKey.currentState?.reset();
    });
  }

  GlobalKey sendOtpDialogKey = GlobalKey();
  GlobalKey changeEmailDialogKey = GlobalKey();
  GlobalKey successDialogKey = GlobalKey();

  /// Change Email Form Key
  final GlobalKey<FormState> changeEmailKey = GlobalKey<FormState>();

  /// Change Email Verify Otp Form Key
  final GlobalKey<FormState> emailVerifyOtpKey = GlobalKey<FormState>();

  /// Change Password Form Key
  final GlobalKey<FormState> changePasswordKey = GlobalKey<FormState>();

  final GlobalKey<FormState> mobileVerifyOtpKey = GlobalKey<FormState>();

  /// Change Phone Form Key
  final GlobalKey<FormState> changeMobileKey = GlobalKey<FormState>();

  /// Old Email Text Field Controller
  TextEditingController oldEmailController = TextEditingController();

  /// New Email Text Field Controller
  TextEditingController newEmailController = TextEditingController();

/*  /// Confirm New Email Text Field Controller
  TextEditingController confirmNewEmailController = TextEditingController();*/

  /// Old Password Text Field Controller
  TextEditingController oldPasswordController = TextEditingController();

  /// New Password Text Field Controller
  TextEditingController newPasswordController = TextEditingController();

  /// Confirm New Password Text Field Controller
  TextEditingController confirmNewPasswordController = TextEditingController();

  /// Email Verify OTP Text Field Controller
  TextEditingController changeEmailOrMobileOtpController = TextEditingController();

  /// Password Verify OTP Text Field Controller
  TextEditingController passwordOtpController = TextEditingController();

  /// Controller for the new mobile no
  TextEditingController newMobileController = TextEditingController();

  /// Mobile no verify otp controller
  TextEditingController mobileOtpController = TextEditingController();

  ///verify change email form
  bool isEmailFieldsValid = false;

  ///verify change password form
  bool isPasswordFieldsValid = false;

  ///verify change email otp form
  bool isEmailVerifyOtpValid = false;

  ///verify change password otp form
  bool isPasswordVerifyOtpValid = false;

  ///Check Validity of change Email Form
  void checkIfEmailValid() {
    isEmailFieldsValid = (newEmailController.text != email && validateEmail(newEmailController.text) == null && validatePassword(emailPasswordController.text) == null);
    notifyListeners();
  }

  ///Check Validity of change Email Form
  void checkIfPasswordValid() {
    isPasswordFieldsValid = ((oldPasswordController.text.length>=8 && oldPasswordController.text.length<=16 ) &&
        RegExp(r'[a-z]').hasMatch(oldPasswordController.text) &&
        RegExp(r'[A-Z]').hasMatch(oldPasswordController.text) &&
        RegExp(r'[0-9]').hasMatch(oldPasswordController.text) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(oldPasswordController.text) &&
        (newPasswordController.text.length>=8 && newPasswordController.text.length<=16 ) &&
        RegExp(r'[a-z]').hasMatch(newPasswordController.text) &&
        RegExp(r'[A-Z]').hasMatch(newPasswordController.text) &&
        RegExp(r'[0-9]').hasMatch(newPasswordController.text) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(newPasswordController.text) &&
        newPasswordController.text==confirmNewPasswordController.text);
    notifyListeners();
  }

  ///Check Validity of change Email Form
  // void checkIfPasswordValid() {
  //   isPasswordFieldsValid = (validatePassword(oldPasswordController.text) == null /*&&
  //           oldPasswordController.text == password &&
  //           newPasswordController.text != password*/
  //       &&
  //       validatePassword(newPasswordController.text) == null &&
  //       validatePassword(confirmNewPasswordController.text) == null &&
  //       newPasswordController.text == confirmNewPasswordController.text);
  //   notifyListeners();
  // }

  ///Clear all form controllers
  void clearFormData() {
    oldEmailController.clear();
    newEmailController.clear();
    oldPasswordController.clear();
    newPasswordController.clear();
    mobilePasswordController.clear();
    emailPasswordController.clear();
    confirmNewPasswordController.clear();
    mobileOtpController.clear();
    changeEmailOrMobileOtpController.clear();
    passwordOtpController.clear();
    newMobileController.clear();
    isShowCurrentPassword = true;
    isShowNewPassword = true;
    isShowConfirmPassword = true;
    isEmailFieldsValid = false;
    isPasswordFieldsValid = false;
    isEmailVerifyOtpValid = false;
    isPasswordVerifyOtpValid = false;
    tempEmail = '';
    tempPassword = '';
    isNewMobileValid = false;
    notifyListeners();
  }

  ///Check if Change Email OTP is valid or not
  void checkIfOtpValid() {
    isEmailVerifyOtpValid = (validateOtp(changeEmailOrMobileOtpController.text) == null);
    notifyListeners();
  }

  ///check if  new and confirm password are same
  bool checkIfNewPasswordIsSameAsConfirmPassword() {
    return newPasswordController.text == confirmNewPasswordController.text;
  }

  ///check if new password is not same as old password
  String? checkIfNewPasswordIsNotSameAsOldPassword() {
    if (password != newPasswordController.text) {
      return null;
    }
    return LocaleKeys.keyNewPasswordNotSameAsOld.localized;
  }

  ///check if new Email is not same as old Email
  String? checkIfNewEmailIsNotSameAsOldEmail() {
    if (email == oldEmailController.text) {
      return null;
    }
    return LocaleKeys.keyNewEmailNotSameAsOld.localized;
  }

  /// validate old password field
  String? verifyOldPassword() {
    if (password == oldPasswordController.text) {
      return null;
    }
    return LocaleKeys.keyEnteredPasswordMustBeSame.localized;
  }

  /// validate old email field
  String? verifyOldEmail() {
    if (email == oldEmailController.text) {
      return null;
    }
    return LocaleKeys.keyEnteredEmailMustBeSame.localized;
  }

  ///For OTP Verification Counter
  int counterSeconds = 30;
  Timer? counter;

  ///Start Counter
  void startCounter() {
    counterSeconds = 30;
    counter?.cancel();
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

  ///Account email
  String email = 'maharaj2@gmail.com';

  /// Store new email temporarily before otp verification
  String tempEmail = '';

  ///Store new password temporarily before verification
  String tempPassword = '';

  /// Account password
  String password = '123456789';

  ///Used for navigating between different profile menus
  int selectedProfileItem = 0;

  ///Update Temporary Email
  void updateTempEmail() {
    tempEmail = newEmailController.text;
    notifyListeners();
  }

  ///Update Email after OTP Verification
  void updateEmail() {
    email = tempEmail;
    notifyListeners();
  }

  ///Update Temporary Email
  void updateTempPassword() {
    tempPassword = newPasswordController.text;
    notifyListeners();
  }

  ///Update Email after OTP Verification
  void updatePassword() {
    password = tempPassword;
    notifyListeners();
  }

  ///Navigate between Profile Options
  void updateSelectedProfile(int index) {
    selectedProfileItem = index;
    notifyListeners();
  }

  /// For mobile Number
  bool isNewMobileValid = false;
  String tempNo = '';

  ///Check Validity of change mobile function
  void validateNewMobile() {
    isNewMobileValid = (newMobileController.text != '' && validateMobile(newMobileController.text) == null
        // &&
        // mobilePasswordController.text != '' &&
        // validateCurrentPassword(mobilePasswordController.text) == null
        );
    notifyListeners();
  }


  /// Email Password Controller
  TextEditingController emailPasswordController = TextEditingController();

  /// Mobile password controller
  TextEditingController mobilePasswordController = TextEditingController();

  /// to change  password visibility
  void changePasswordVisibility() {
    isShowNewPassword = !isShowNewPassword;
    notifyListeners();
  }

  bool isShowCurrentPassword = true;
  bool isShowNewPassword = true;
  bool isShowConfirmPassword = true;

  /// to change current password visibility
  void changeCurrentPasswordVisibility() {
    isShowCurrentPassword = !isShowCurrentPassword;
    notifyListeners();
  }

  /// to change new password visibility
  void changeNewPasswordVisibility() {
    isShowNewPassword = !isShowNewPassword;
    notifyListeners();
  }

  /// to change confirm password visibility
  void changeConfirmPasswordVisibility() {
    isShowConfirmPassword = !isShowConfirmPassword;
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  bool isLoading = false;

  void updateLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }


  var profileState = UIState();

  ProfileRepository profileRepository;

  ProfileController(this.profileRepository);

  var profileDetailState = UIState<ProfileDetailResponseModel>();

  ///get profile detail api
  Future<void> getProfileDetail(BuildContext context) async {
    profileDetailState.isLoading = true;
    profileDetailState.success = null;
    notifyListeners();

    final result = await profileRepository.getProfileDetail();
    result.when(success: (data) async {
      profileDetailState.success = data;
      if (profileDetailState.success?.status == ApiEndPoints.apiStatus_200) {
        Session.saveLocalData(keyCountryUuid, profileDetailState.success?.data?.countryUuid);
      }
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    profileDetailState.isLoading = false;

    notifyListeners();
  }

  var getVendorDocumentsState = UIState<GetVendorDocumentResponseModel>();

  void openPdf(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///Get vendor documents api
  Future<void> getVendorDocumentsApi(BuildContext context) async {
    getVendorDocumentsState.isLoading = true;
    getVendorDocumentsState.success = null;
    notifyListeners();

    final result = await profileRepository.getVendorDocumentsApi(Session.getUuid().toString());
    result.when(success: (data) async {
      getVendorDocumentsState.success = data;
      for (final img in getVendorDocumentsState.success?.data?.vendorDocuments ?? []) {
        if (img.url.contains('.pdf')) {
          final response = await http.get(Uri.parse(img.url.toString()));
          img.bytes = response.bodyBytes;
        }
      }
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    getVendorDocumentsState.isLoading = false;

    notifyListeners();
  }

  var checkPasswordState = UIState<CommonResponseModel>();

  ///Check password API
  Future<void> checkPassword(BuildContext context, String value) async {
    checkPasswordState.isLoading = true;
    checkPasswordState.success = null;
    notifyListeners();

    CheckPasswordRequestModel checkPasswordRequestModel = CheckPasswordRequestModel(
      password: value.trimSpace,
    );
    String request = checkPasswordRequestModelToJson(checkPasswordRequestModel);

    final result = await profileRepository.checkPassword(request);
    result.when(success: (data) async {
      checkPasswordState.success = data;
      counter?.cancel();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    checkPasswordState.isLoading = false;
    notifyListeners();
  }

  var sendOtpState = UIState<CommonResponseModel>();

  /// Send Otp API
  Future<void> sendOtpApi(BuildContext context, {String? email, String? mobileNo}) async {
    sendOtpState.isLoading = true;
    sendOtpState.success = null;
    notifyListeners();

    String type = (email != null) ? 'EMAIL' : 'SMS';
    SendOtpRequestModel requestModel = SendOtpRequestModel(uuid: Session.getUserUuid().toString(), email: email?.trimSpace ?? '', contactNumber: mobileNo?.trimSpace ?? '', userType: Session.getUserType().toString(), type: type, sendingType: 'OTP', verifyBeforeGenerate: true);
    String request = sendOtpRequestModelToJson(requestModel);

    final result = await profileRepository.sendOtpApi(request);

    result.when(success: (data) async {
      sendOtpState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    sendOtpState.isLoading = false;
    notifyListeners();
  }

  var updateEmailOrMobileState = UIState<UpdateEmailResponseModel>();

  ///Change email api
  Future<void> updateEmailMobileApi({BuildContext? context, bool? isEmail, String? mobileNo, String? email, required String otp, required String password}) async {
    updateEmailOrMobileState.isLoading = true;
    updateEmailOrMobileState.success = null;
    notifyListeners();

    UpdateEmailRequestModel requestModelEmail = UpdateEmailRequestModel(
      email: email?.trimSpace ?? newEmailController.text.trimSpace,
      otp: otp,
      password: password,
    );

    UpdateMobileRequestModel requestModelMobile = UpdateMobileRequestModel(
      contactNumber: mobileNo?.trimSpace ?? newMobileController.text.trimSpace,
      // otp: otp, password: password
    );

    String request = isEmail == true ? updateEmailRequestModelToJson(requestModelEmail) : updateMobileRequestModelToJson(requestModelMobile);

    final result = await profileRepository.updateEmailMobile(request, isEmail == true ? true : false);
    result.when(success: (data) async {
      updateEmailOrMobileState.success = data;
      if (updateEmailOrMobileState.success?.status == ApiEndPoints.apiStatus_200) {
        if (isEmail == true) {
          Session.saveLocalData(keyUserAuthToken, updateEmailOrMobileState.success?.data?.accessToken);
          profileDetailState.success?.data?.email = email??'';
        }else{
          profileDetailState.success?.data?.contactNumber = mobileNo??'';
        }
      }
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context!, message: errorMsg);
    });
    updateEmailOrMobileState.isLoading = false;

    notifyListeners();
  }

  var changePasswordState = UIState<ChangePasswordResponseModel>();

  ///Change password api
  Future<void> changePassword(BuildContext context) async {
    changePasswordState.isLoading = true;
    changePasswordState.success = null;
    notifyListeners();

    ChangePasswordRequestModel requestModel = ChangePasswordRequestModel(oldPassword: oldPasswordController.text.trimSpace, newPassword: confirmNewPasswordController.text.trimSpace);
    String request = changePasswordRequestModelToJson(requestModel);

    final result = await profileRepository.changePassword(request);
    result.when(success: (data) async {
      changePasswordState.success = data;
      Session.saveLocalData(keyUserAuthToken, changePasswordState.success?.data?.accessToken);
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    changePasswordState.isLoading = false;

    notifyListeners();
  }

  var getAgencyDocumentsState = UIState<GetAgencyDocumentResponseModel>();

  ///Get Agency Detail api
  Future<void> getAgencyDocumentsApi(BuildContext context) async {
    getAgencyDocumentsState.isLoading = true;
    getAgencyDocumentsState.success = null;
    notifyListeners();

    final result = await profileRepository.getAgencyDocumentsApi(Session.getUuid().toString());
    result.when(success: (data) async {
      getAgencyDocumentsState.success = data;
      for (final img in getAgencyDocumentsState.success?.data?.agencyDocuments ?? []) {
        if (img.url.contains('.pdf')) {
          final response = await http.get(Uri.parse(img.url.toString()));
          img.bytes = response.bodyBytes;
        }
      }
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    getAgencyDocumentsState.isLoading = false;

    notifyListeners();
  }
}
