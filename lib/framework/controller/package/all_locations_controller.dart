import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/package/contract/package_repository.dart';
import 'package:odigo_vendor/framework/repository/package/model/package_limit_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';

final allLocationsController = ChangeNotifierProvider(
      (ref) => getIt<AllLocationsController>(),
);

@injectable
class AllLocationsController extends ChangeNotifier {
  PackageRepository packageRepository;
  AllLocationsController(this.packageRepository);
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    disposeFormKey();
    priceCtr.clear();
    startDate = null;
    startDateCtr.clear();
    endDate = null;
    endDateCtr.clear();
    disposeFormKey();
    if (isNotify) {
      notifyListeners();
    }
  }

  void updateUI() {
    notifyListeners();
  }

  /// Price ctr
  TextEditingController priceCtr = TextEditingController();
  TextEditingController startDateCtr = TextEditingController();
  TextEditingController endDateCtr = TextEditingController();

  /// Form key
  final formKey = GlobalKey<FormState>();

  /// dispose from key
  void disposeFormKey() {
    Future.delayed(const Duration(milliseconds: 100), () {
      formKey.currentState?.reset();
    });
  }

  /// Start date
  DateTime? startDate;

  /// End date
  DateTime? endDate;

  /// Update start date and end date
  void updateStartEndDate(bool isStartDate, DateTime? date) {
    if (isStartDate) {
      startDate = date;
      startDateCtr.text=DateFormat(dateFormat)
          .format(startDate ?? DateTime.now());
      endDateCtr.clear();
    } else {
      endDate = date;
      endDateCtr.text=DateFormat(dateFormat)
          .format(endDate ?? DateTime.now());
    }
       notifyListeners();
  }



  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */



  var packageLimitState = UIState<PackageLimitResponseModel>();

  /// package limit API
  Future<void> packageLimitApi({required BuildContext context,
    required String destinationUuid,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? budget,
    required String? storeUuid,
    required String? clientUuid}) async {

    packageLimitState.isLoading = true;
    packageLimitState.success = null;
    notifyListeners();


    Map<String, dynamic> request = {
      'destinationUuid': destinationUuid,
      'startDate': getUtcTime(startDate),
      'endDate': getUtcTime(endDate),
      'budget': budget?.trimSpace
    };

    /// vendor
    if(Session.getUserType() == userTypeValue.reverse[UserType.VENDOR]){
      request.addAll({'vendorUuid':Session.getUuid(),
        'storeUuid':storeUuid
      },);
    }else{/// agency
      request.addAll({'agencyUuid':Session.getUuid(),});
      if(clientUuid != null && clientUuid.isNotEmpty){
        request.addAll({'clientMasterUuid':clientUuid});
      }
    }

    String requestBody = jsonEncode(request);

    final result = await packageRepository.packageLimitApi(request: requestBody);


    result.when(success: (data) async {
      packageLimitState.success = data;
      packageLimitState.isLoading = false;
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    packageLimitState.isLoading = false;
    notifyListeners();
  }


}
