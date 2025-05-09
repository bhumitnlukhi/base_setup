import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/store/contract/store_repository.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';

final selectStoreController = ChangeNotifierProvider(
  (ref) => getIt<SelectStoreController>(),
);

@injectable
class SelectStoreController extends ChangeNotifier {
  final StoreRepository storeRepository;

  SelectStoreController(this.storeRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    pageNo = 1;
    storeList = [];
    storeListState.isLoading = false;
    storeListState.isLoadMore = false;
    storeListState.success = null;
    selectedStore = null;

    if (isNotify) {
      notifyListeners();
    }
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  StoreListData? selectedStore;

  updateSelectedStore(StoreListData? value) {
    selectedStore = value;
    notifyListeners();
  }

  var storeListState = UIState<StoreListResponseModel>();
  List<StoreListData?> storeList = [];
  int pageNo = 1;

  /// store List APi
  Future<UIState<StoreListResponseModel>> storeListApi(
    BuildContext context,
    bool pagination,

  {required String destinationUuid, required int dataSize, bool? isAdsAvailable}
  ) async {
    if (storeListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if (pageNo == 1 || pagination == false) {
      storeListState.isLoading = true;
      storeList = [];
    } else {
      storeListState.isLoadMore = true;
      storeListState.isLoadMore = true;
    }

    storeListState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'activeRecords': true,
      'destinationUuid': destinationUuid,
      "isAdsAvailable": isAdsAvailable,
      "status":"ACTIVE"
    };

    final result = await storeRepository.storeListApi(request: jsonEncode(request), pageNumber: pageNo, uuid: Session.getUuid(), dataSize: dataSize);

    result.when(success: (data) async {
      storeListState.success = data;
      storeList.addAll(storeListState.success?.data ?? []);

      storeListState.isLoading = false;
      storeListState.isLoadMore = false;
    }, failure: (NetworkExceptions error) {
      storeListState.isLoadMore = false;
      storeListState.isLoading = false;
      showLog("storeListState.isLoading ${storeListState.isLoading}");

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    storeListState.isLoading = false;
    storeListState.isLoadMore = false;

    notifyListeners();
    return storeListState;
  }
}
