import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigo_vendor/framework/controller/drawer/drawer_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/add_edit_store_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/login_request_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/language_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/auth/model/response_model/login_response_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/auth/web/helper/waiting_dialog.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';

final loginController = ChangeNotifierProvider(
  (ref) => getIt<LoginController>(),
);

@injectable
class LoginController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10), () {
      formKey.currentState?.reset();
    });
    isLogin = true;
    isAllFieldsValid = false;
    isPasswordHidden = true;
    emailController.text = '';
    passwordController.text = '';
    loginState.success = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey waitingDialog = GlobalKey();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ///To show and hide password
  bool isPasswordHidden = true;

  ///To check if all fields are valid or not
  bool isAllFieldsValid = false;

  ///Check Validity of Password
  void checkIfAllFieldsValid() {
    isAllFieldsValid = (validateEmail(emailController.text) == null && validatePassword(passwordController.text) == null);
    notifyListeners();
  }

  ///change visibility of the password
  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  bool isLogin = true;

  updateLogin(bool value) {
    isLogin = value;
    notifyListeners();
  }

  bool rememberMe = false;

  updateRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  AuthRepository authRepository;

  LoginController(this.authRepository);

  var loginState = UIState<LoginResponseModel>();

  /// Login API
  Future<UIState<LoginResponseModel>> loginApi(BuildContext context, {required WidgetRef ref}) async {
    loginState.isLoading = true;
    loginState.success = null;
    notifyListeners();

    LoginRequestModel requestModel = LoginRequestModel(email: emailController.text.toLowerCase().trimSpace, password: passwordController.text.trimSpace, userType: Session.getUserType());
    String request = loginRequestModelToJson(requestModel);

    final result = await authRepository.loginApi(request);

    result.when(success: (data) async {
      loginState.success = data;
      loginState.isLoading = false;
      if (loginState.success?.status == ApiEndPoints.apiStatus_200) {
        loginNavigation(ref, context);
        if(loginState.success?.data?.isRegistrationCompleted == false){
          Session.saveLocalData(keyIsRegistrationPending, true);
        }else{
          Session.saveLocalData(keyIsRegistrationPending, false);
        }
        Session.saveLocalData(keyCountryUuid, loginState.success?.data?.countryUuid);
        Session.saveLocalData(keyIsSignUpPending,false );
      }
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    loginState.isLoading = false;
    notifyListeners();
    return loginState;
  }

  loginNavigation(WidgetRef ref, BuildContext context) {
    final drawerWatch = ref.watch(drawerController);
    // final signUpWatch = ref.watch(signUpController);
    // if (loginState.success?.data?.emailVerified == true) {
    _saveDataHive();
    // }

    if (loginState.success?.data?.emailVerified == false) {
      final otpVerificationWatch = ref.watch(otpVerificationController);
      otpVerificationWatch.disposeController(isNotify: true);

      otpVerificationWatch
          .sendOtpApi(
        context,
        email: loginState.success?.data?.email ?? '',
        mobileNo: loginState.success?.data?.contactNumber ?? '',
        userUuid: loginState.success?.data?.userUuid ?? '',
      )
          .then((value) {
        if (otpVerificationWatch.sendOtpState.success?.status == ApiEndPoints.apiStatus_200) {
          ref.read(navigationStackController).push(NavigationStackItem.otpVerification(email: loginState.success?.data?.email ?? '', screenName: ScreenName.login));
        }
      });
    } else if (loginState.success?.data?.entityStatus == AccountStatus.ACTIVE.name) {
      if (loginState.success?.data?.isRegistrationCompleted == true) {
        ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
      } else {
        loginState.success?.data?.entityType == UserType.VENDOR.name ? ref.read(navigationStackController).push(const NavigationStackItem.vendorRegistrationForm()) : ref.read(navigationStackController).push(const NavigationStackItem.agencyRegistrationForm());
      }
    } else if (loginState.success?.data?.entityStatus == AccountStatus.INACTIVE.name) {
      showCommonErrorDialogNew(context: context, message: LocaleKeys.keyYourAccountHasBeenINACTIVE.localized);
    } else if (loginState.success?.data?.entityStatus == AccountStatus.REJECTED.name) {
      showCommonErrorDialogNew(context: context, message: LocaleKeys.keyYourAccountHasBeenRejected.localized);
    } else if (loginState.success?.data?.entityStatus == AccountStatus.PENDING.name) {
      showCommonWebDialog(
        keyBadge: waitingDialog,
        context: context,
        width: 0.5,
        height: 0.45,
        barrierDismissible: true,
        dialogBody: const WaitingDialog(),
      );
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } else if (loginState.success?.data?.isRegistrationCompleted == false) {
      final addEditStoreWatch = ref.watch(addEditStoreController);
      addEditStoreWatch.disposeController(isNotify: true);
      loginState.success?.data?.entityType == UserType.VENDOR.name ? ref.read(navigationStackController).push(const NavigationStackItem.vendorRegistrationForm()) : ref.read(navigationStackController).push(const NavigationStackItem.agencyRegistrationForm());
    } else if (loginState.success?.data?.entityStatus == AccountStatus.NEW.name) {
      showCommonErrorDialogNew(message: LocaleKeys.keyAdminApprovalIsPending.localized, context: context);
    }
    drawerWatch.disposeController();
  }

  void _saveDataHive() {
    Session.saveLocalData(keyUserAuthToken, loginState.success?.data?.accessToken);
    Session.saveLocalData(keyUserUuid, loginState.success?.data?.userUuid);
    Session.saveLocalData(keyUuid, loginState.success?.data?.uuid);
    Session.saveLocalData(keyUserType, loginState.success?.data?.entityType);
    Session.saveLocalData(keyAccountStatus, loginState.success?.data?.entityStatus);
    Session.saveLocalData(keyCurrency, loginState.success?.data?.currencyName);
    Session.saveLocalData(keyName, loginState.success?.data?.name);
    Session.saveLocalData(keyEmailId, loginState.success?.data?.email);
    Session.saveLocalData(keyContactNumber, loginState.success?.data?.contactNumber);
  }


  TextEditingController languageController = TextEditingController();

  /// Language List
  List<LanguageData> languageList = [];

  /// Language Data Object
  LanguageData? languageData;

  /// Update App Language
  updateAppLanguage(String? languageUuid) {
    languageData = languageList.where((element) => element.uuid == languageUuid).firstOrNull;
    languageController.clear();
    languageController.text = languageData?.name ?? '';
    Session.saveLocalData(keyAppLanguage, languageData?.code);
    Session.saveLocalData(keyAppLanguageUuid, languageData?.uuid ?? '');
    Session.isRTL = languageData?.isRtl ?? false;
    notifyListeners();
  }

  /// Update Selected Locale
  updateSelectedLocale(String? languageUuid) {
    languageData = languageList.where((element) => element.uuid == languageUuid).firstOrNull;
    notifyListeners();
  }
  //
  // bool isEngLang = true;
  //
  // currentLang(){
  //   if(Session.appLanguage == LanguageType.en.name){
  //     isEngLang = true;
  //   }else{
  //     isEngLang = false;
  //   }
  //   notifyListeners();
  // }



  /// Get Language
  UIState<LanguageListResponseModel> languageState = UIState<LanguageListResponseModel>();

  Future<void> getLanguageApi(BuildContext context) async {
    languageState.isLoading = true;
    languageState.success = null;
    languageList.clear();
    notifyListeners();

    final result = await authRepository.languageApi();

    result.when(success: (data) async {
      languageState.success = data;
      languageList.clear();
      languageList.addAll(languageState.success?.data ?? []);
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    languageState.isLoading = false;
    notifyListeners();
  }

  /// Change Language
  UIState<CommonResponseModel> changeLanguageState = UIState<CommonResponseModel>();

  Future<void> changeLanguageApi(BuildContext context, {required String languageUuid}) async {
    changeLanguageState.isLoading = true;
    changeLanguageState.success = null;
    notifyListeners();

    final result = await authRepository.changeLanguageApi(languageUuid);

    result.when(success: (data) async {
      changeLanguageState.success = data;
      showLog("changeLanguageState $changeLanguageState");
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    changeLanguageState.isLoading = false;
    notifyListeners();
  }
}
