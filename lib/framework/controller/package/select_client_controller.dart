import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/client_master/model/request/client_update_request_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/contract/package_repository.dart';
import 'package:odigo_vendor/framework/repository/package/model/client_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';

final selectClientController = ChangeNotifierProvider(
  (ref) => getIt<SelectClientController>(),
);

@injectable
class SelectClientController extends ChangeNotifier {
  final PackageRepository packageRepository;

  SelectClientController(this.packageRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    clientListState.isLoading = true;
    clientListState.success = null;
    pageNo = 1;
    clientList.clear();
    selectedClient = null;

    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey importDialog = GlobalKey();

  // /// call api on search
  // Timer? debounce;
  // void onSearchChanged(String value,BuildContext context){
  //   if (debounce?.isActive ?? false) debounce!.cancel();
  //   debounce = Timer(const Duration(milliseconds: 500), () async {
  //     clientList = [];
  //     pageNo =1;
  //     clientListState.success = null;
  //     // disposeApiData();
  //     // adsListApi(context, false, isGetOnlyClient: true);
  //     await clientListApi(context, false, isAdsAvailable: true, searchText: value);
  //
  //   });
  //   notifyListeners();
  // }
  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ClientData? selectedClient;

  updateSelectedClient(ClientData? value) {
    selectedClient = value;
    notifyListeners();
  }

  updateClientValue(int index, ClientUpdateRequestModel model) {
    clientListState.success?.data?[index].uuid = model.uuid ?? '';
    clientListState.success?.data?[index].name = model.name ?? '';
    clientListState.success?.data?[index].houseNumber = model.houseNumber ?? '';
    clientListState.success?.data?[index].streetName = model.streetName ?? '';
    clientListState.success?.data?[index].addressLine1 = model.addressLine1 ?? '';
    clientListState.success?.data?[index].addressLine2 = model.addressLine2 ?? '';
    clientListState.success?.data?[index].landmark = model.landmark ?? '';
    clientListState.success?.data?[index].cityUuid = model.cityUuid ?? '';
    clientListState.success?.data?[index].stateUuid = model.stateUuid ?? '';
    clientListState.success?.data?[index].countryUuid = model.countryUuid ?? '';
    clientListState.success?.data?[index].businessCategory?.uuid = model.businessCategoryUuid ?? '';
    clientListState.success?.data?[index].postalCode = model.postalCode ?? '';
    notifyListeners();
  }

  var clientListState = UIState<ClientListResponseModel>();
  List<ClientData?> clientList = [];
  int pageNo = 1;

  ScrollController scrollController = ScrollController();

  /// client List APi
  Future<void> clientListApi(BuildContext context, bool pagination, {String? searchText, bool? isAdsAvailable, bool isFromCreateAd = false}) async {
    if (clientListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if (pageNo == 1 || pagination == false) {
      pageNo = 1;

      clientListState.isLoading = true;
      clientList = [];
    } else {
      clientListState.isLoadMore = true;
      clientListState.isLoadMore = true;
    }

    clientListState.success = null;
    notifyListeners();

    Map<String, dynamic> requestModel = {};

    if (isFromCreateAd) {
      requestModel = {"searchKeyword": searchText?.trimSpace, "agencyUuid": Session.getUuid(), "isAdsAvailable": isAdsAvailable, "activeRecords": true};
    } else {
      requestModel = {
        "searchKeyword": searchText?.trimSpace,
        "agencyUuid": Session.getUuid(),
        "isAdsAvailable": isAdsAvailable
     };
    }
    String request = jsonEncode(requestModel);
    final result = await packageRepository.clientListApi(
      request: request,
      pageNumber: pageNo,
    );

    result.when(success: (data) async {
      clientListState.success = data;
      clientList.addAll(clientListState.success?.data ?? []);

      clientListState.isLoading = false;
      clientListState.isLoadMore = false;
    }, failure: (NetworkExceptions error) {
      clientListState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    clientListState.isLoading = false;
    clientListState.isLoadMore = false;

    notifyListeners();
  }

  int? currentIndex;

  changeClientStatus(index) {
    currentIndex = index;
    clientListState.success?.data?[index].active = !(clientListState.success?.data?[index].active ?? false);
    notifyListeners();
  }

  var clientStatusUpdateState = UIState<CommonResponseModel>();

  Future<UIState<CommonResponseModel>> clientStatusUpdateApi(BuildContext context, int index, {required String clientId, required bool active}) async {
    currentIndex = index;

    clientStatusUpdateState.isLoading = true;
    clientStatusUpdateState.success = null;
    notifyListeners();

    // String request = jsonEncode(requestModel);
    final result = await packageRepository.clientStatusUpdateApi('', clientId, active);

    result.when(success: (data) async {
      clientStatusUpdateState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    clientStatusUpdateState.isLoading = false;

    notifyListeners();
    return clientStatusUpdateState;
  }
}
