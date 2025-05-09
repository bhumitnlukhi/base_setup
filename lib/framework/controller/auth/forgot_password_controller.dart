import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/forgot_password_request_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';

final forgotPasswordController = ChangeNotifierProvider(
      (ref) => getIt<ForgotPasswordController>(),
);

@injectable
class ForgotPasswordController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10), () {
      formKey.currentState?.reset();
    });
    email = '';
    emailController.clear();
    isAllFieldsValid = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  String email = '';

  void updateEmail() {
    email = emailController.text;
    notifyListeners();
  }

  ///To check if all fields are valid
  bool isAllFieldsValid = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  ///Check Validity of Password
  void checkIfAllFieldsValid() {
    isAllFieldsValid = validateEmail(emailController.text) == null;
    notifyListeners();
  }



  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  AuthRepository authRepository;
  ForgotPasswordController(this.authRepository);

  var forgotPasswordState = UIState<CommonResponseModel>();

  /// forgot Password API
  Future<void> forgotPasswordApi(BuildContext context) async {
    forgotPasswordState.isLoading = true;
    forgotPasswordState.success = null;
    notifyListeners();

    ForgotPasswordRequestModel requestModel = ForgotPasswordRequestModel(email: emailController.text.toLowerCase().trimSpace, userType: Session.getUserType(), type: 'EMAIL', sendingType: 'OTP');
    String request = forgotPasswordRequestModelToJson(requestModel);

    final result = await authRepository.forgotPasswordApi(request);

    result.when(success: (data) async {
      forgotPasswordState.success = data;
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    forgotPasswordState.isLoading = false;
    notifyListeners();
  }


}
