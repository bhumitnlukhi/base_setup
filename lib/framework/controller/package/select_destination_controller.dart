import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/package/contract/package_repository.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';

final selectDestinationController = ChangeNotifierProvider(
  (ref) => getIt<SelectDestinationController>(),
);

@injectable
class SelectDestinationController extends ChangeNotifier {
  final PackageRepository packageRepository;

  SelectDestinationController(this.packageRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    destinationDetailsState.isLoading = false;
    destinationDetailsState.success = null;

    destinationList = [];
    destinationListState.success = null;
    destinationListState.isLoading = false;
    selectedDestination = null;

    if (isNotify) {
      notifyListeners();
    }
  }

  GlobalKey destinationDialogKey = GlobalKey();

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  var destinationListState = UIState<DestinationListResponseModel>();
  List<DestinationData?> destinationList = [];
  int pageNo = 1;

  DestinationData? selectedDestination;

  updateSelectedDestination(DestinationData? value) {
    selectedDestination = value;
    notifyListeners();
  }

  /// destination List APi
  Future<void> destinationListApi(BuildContext context, bool pagination, {bool forVendor = false, int? dataSize, bool? adsForOwn}) async {
    if (destinationListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if (pageNo == 1 || pagination == false) {
      destinationListState.isLoading = true;
      destinationList = [];
    } else {
      destinationListState.isLoadMore = true;
      destinationListState.isLoadMore = true;
    }

    destinationListState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {
      'activeRecords': true,
      'firstOfflineSync': true,
      'hasPackages':true,
    };

    Map<String, dynamic> agencyRequest = {
      'activeRecords': true,
      'hasAds': adsForOwn == true ? true : null,
      'hasAdsForClient': adsForOwn == false ? true : null,
      'firstOfflineSync': true,
      'hasPackages':true,
    };

    String requestBody = jsonEncode(forVendor ? request : agencyRequest);
    final result = await packageRepository.destinationListApi(request: requestBody, pageNumber: pageNo, forVendor: forVendor, dataSize: dataSize);

    result.when(success: (data) async {
      destinationListState.success = data;
      destinationList.addAll(destinationListState.success?.data ?? []);

      destinationListState.isLoading = false;
      destinationListState.isLoadMore = false;
    }, failure: (NetworkExceptions error) {
      destinationListState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    destinationListState.isLoading = false;
    destinationListState.isLoadMore = false;

    notifyListeners();
  }

  var destinationDetailsState = UIState<DestinationDetailsResponseModel>();

  Future<UIState<DestinationDetailsResponseModel>> destinationDetailApi(BuildContext context, String destinationUuid) async {
    destinationDetailsState.isLoading = true;
    destinationDetailsState.success = null;

    final result = await packageRepository.destinationDetailApi(destinationUuid: destinationUuid);
    result.when(success: (data) async {
      destinationDetailsState.success = data;
      destinationDetailsState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      destinationDetailsState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    destinationDetailsState.isLoading = false;
    return destinationDetailsState;
  }
}
