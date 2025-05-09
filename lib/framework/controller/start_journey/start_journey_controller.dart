import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigo_vendor/framework/repository/auth/model/request_model/contact_us_request_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';

final startJourneyController = ChangeNotifierProvider(
  (ref) => getIt<StartJourneyController>(),
);

@injectable
class StartJourneyController extends ChangeNotifier {
  AuthRepository authRepository;

  StartJourneyController(this.authRepository);

  String strDescription = '';

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    addContactUsState.isLoading = false;
    addContactUsState.success = null;
    strDescription = '';
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateDescription(String str) {
    strDescription = '';

    strDescription = str;
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  var addContactUsState = UIState<CommonResponseModel>();

  /// destination List APi
  Future<void> addContactUsAPI(BuildContext context, {required String name, required String description, required String mobileNumber, required String email}) async {
    addContactUsState.isLoading = true;
    addContactUsState.success = null;
    notifyListeners();

    ContactUsRequestModel requestModel = ContactUsRequestModel(
      name: name,
      description: description,
      contactNumber: mobileNumber,
      email: email,
    );
    final String request = contactUsRequestModelToJson(requestModel);
    final result = await authRepository.addContactUsAPI(request);

    result.when(success: (data) async {
      addContactUsState.success = data;
      addContactUsState.isLoading = false;

      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    addContactUsState.isLoading = false;
    notifyListeners();
  }
}
