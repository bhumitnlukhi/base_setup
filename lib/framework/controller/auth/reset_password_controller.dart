import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/reset_password_request_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';

final resetPasswordController = ChangeNotifierProvider(
  (ref) => getIt<ResetPasswordController>(),
);

@injectable
class ResetPasswordController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    resetPasswordState.isLoading = false;
    resetPasswordState.success = null;
    Future.delayed(const Duration(milliseconds: 10), () {
      formKey.currentState?.reset();
    });
    isAllFieldsValid = false;
    isShowConfirmPassword = true;
    isShowPassword = true;
    newPasswordController.clear();
    confirmPasswordController.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ///Check Validity of all fields
  bool isAllFieldsValid = false;

  ///Update the value of is all fields valid
  // void checkIfAllFieldsValid() {
  //   isAllFieldsValid = (validatePassword(newPasswordController.text) == null && validatePassword(confirmPasswordController.text) == null && confirmPasswordController.text == newPasswordController.text);
  //   notifyListeners();
  // }

  void checkIfAllFieldsValid() {
    isAllFieldsValid = (
        (newPasswordController.text.length>=8 && newPasswordController.text.length<=16 ) &&
            RegExp(r'[a-z]').hasMatch(newPasswordController.text) &&
            RegExp(r'[A-Z]').hasMatch(newPasswordController.text) &&
            RegExp(r'[0-9]').hasMatch(newPasswordController.text) &&
            RegExp(r'[!@#$%^&*(),.?":{}|<>\-]').hasMatch(newPasswordController.text) &&
            newPasswordController.text==confirmPasswordController.text
    );
    notifyListeners();
  }

  ///To show and hide password
  bool isShowPassword = false;

  /// to change password visibility
  void changePasswordVisibility() {
    isShowPassword = !isShowPassword;
    notifyListeners();
  }

  ///To show and hide confirm password
  bool isShowConfirmPassword = false;

  /// to change password visibility
  void changeConfirmPasswordVisibility() {
    isShowConfirmPassword = !isShowConfirmPassword;
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  AuthRepository authRepository;

  ResetPasswordController(this.authRepository);

  var resetPasswordState = UIState<CommonResponseModel>();

  /// resetPassword API
  Future<void> resetPasswordApi(BuildContext context, {required String otp, required String email}) async {
    resetPasswordState.isLoading = true;
    resetPasswordState.success = null;
    notifyListeners();

    ResetPasswordRequestModel requestModel = ResetPasswordRequestModel(email: email.trimSpace, userType: Session.getUserType(), type: 'EMAIL', otp: otp, password: confirmPasswordController.text.trimSpace);
    String request = resetPasswordRequestModelToJson(requestModel);

    final result = await authRepository.resetPasswordApi(request);

    result.when(success: (data) async {
      resetPasswordState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    resetPasswordState.isLoading = false;
    notifyListeners();
  }
}
