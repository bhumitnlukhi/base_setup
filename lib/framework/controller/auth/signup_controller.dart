import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/sign_up_request_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/sign_up_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/cms_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';

final signUpController = ChangeNotifierProvider(
  (ref) => getIt<SignUpController>(),
);

@injectable
class SignUpController extends ChangeNotifier {
  bool isAcceptTermsAndCondition = false;

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10), () {
      signUpFormKey.currentState?.reset();
    });
    nameController.text = '';
    emailController.text = '';
    mobileNumberController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    isShowConfirmPassword = true;
    isShowPassword = true;
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateTermsAndCondition() {
    isAcceptTermsAndCondition = !isAcceptTermsAndCondition;
    notifyListeners();
  }

  ///Form Key
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final passwordFocusNode = FocusNode();

  ///Controller
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///To check if all fields are valid or not
  bool isAllFieldsValid = false;

  ///Check Validity of Password
  void checkIfAllFieldsValid(WidgetRef ref) {
    isAllFieldsValid = (nameController.text.isNotEmpty && nameController.text.length >= 3 && validateEmail(emailController.text) == null && validateMobile(mobileNumberController.text) == null && (
        (passwordController.text.length>=8 && passwordController.text.length<=16 ) &&
            RegExp(r'[a-z]').hasMatch(passwordController.text) &&
            RegExp(r'[A-Z]').hasMatch(passwordController.text) &&
            RegExp(r'[0-9]').hasMatch(passwordController.text) &&
            RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(passwordController.text) &&
            passwordController.text==confirmPasswordController.text
    ) && ref.read(agencyRegistrationFormController).selectedCountry != null);

    notifyListeners();
  }

  ///To show and hide password
  bool isShowPassword = true;

  /// to change password visibility
  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  ///To show and hide confirm password
  bool isShowConfirmPassword = true;

  /// to change password visibility
  void changeConfirmPasswordVisibility() {
    isShowConfirmPassword = !isShowConfirmPassword;
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  AuthRepository authRepository;

  SignUpController(this.authRepository);

  var signUpState = UIState<SignUpResponseModel>();

  /// SignUp API
  Future<void> signUpApi(BuildContext context, {String? countryUuid}) async {
    signUpState.isLoading = true;
    signUpState.success = null;
    notifyListeners();

    SignUpRequestModel requestModel = SignUpRequestModel(email: emailController.text.toLowerCase().trimSpace, password: passwordController.text.trim().trimSpace, contactNumber: mobileNumberController.text.trimSpace, name: nameController.text.trimSpace, countryUuid: countryUuid);
    String request = signUpRequestModelToJson(requestModel);

    final result = await authRepository.signUpApi(request);

    result.when(success: (data) async {
      signUpState.success = data;
      signUpState.isLoading = false;
      if (signUpState.success?.status == ApiEndPoints.apiStatus_200) {
        Session.saveLocalData(keyCountryUuid, signUpState.success?.data?.countryUuid);
      }
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    signUpState.isLoading = false;
    notifyListeners();
  }

  var cmsState = UIState<CmsResponseModel>();

  /// CMS API
  Future<UIState<CmsResponseModel>> cmsAPI(BuildContext context, {required String cmsType}) async {
    cmsState.isLoading = true;
    cmsState.success = null;
    notifyListeners();

    if (cmsType == CmsType.termsAndCondition.name) {
      cmsType = 'TERMS_AND_CONDITION';
    } else if (cmsType == CmsType.privacyPolicy.name) {
      cmsType = 'PRIVACY_POLICY';
    } else {
      cmsType = 'ABOUT_US';
    }

    final result = await authRepository.cmsAPI(cmsType);

    result.when(success: (data) async {
      cmsState.success = data;
      cmsState.isLoading = false;
      if (cmsState.success?.status == ApiEndPoints.apiStatus_200) {}
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    cmsState.isLoading = false;
    notifyListeners();
    return cmsState;
  }
}
