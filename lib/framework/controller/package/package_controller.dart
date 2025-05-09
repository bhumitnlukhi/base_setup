import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/contract/package_repository.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/package_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';

final packageController = ChangeNotifierProvider(
  (ref) => getIt<PackageController>(),
);

@injectable
class PackageController extends ChangeNotifier {
  final PackageRepository packageRepository;

  PackageController(this.packageRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isLoading = false;
    pageNo = 1;
    packageListState.success = null;
    selectedAgencyPurchasePackageFor = LocaleKeys.keyForYourself;
    purchasePackageState.isLoading = false;
    destinationData = null;
    packageList.clear();
    packageListState.success = null;
    packageListState.isLoading = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  clearData() {
    pageNo = 1;
    packageList = [];
    packageListState.success = null;
    notifyListeners();
  }

  ScrollController packageScrollController = ScrollController();

  /// Search Controller
  TextEditingController packageSearchCtr = TextEditingController();

  GlobalKey agencyPurchaseDialogKey = GlobalKey();

  ///For filter overlay
  final LayerLink link = LayerLink();
  final OverlayPortalController tooltipController = OverlayPortalController();

  DestinationData? destinationData;

  updateDestination(DestinationData? data) {
    destinationData = data;
    notifyListeners();
  }

  /// call api on search
  Timer? debounce;

  void onSearchChanged(String value, BuildContext context) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      // disposeController(isNotify: true);
      packageListState.success = null;
      packageList = [];
      packageListApi(context, false);
    });
    notifyListeners();
  }

  /// Agency user tab list
  List<String> agencyUserPackageTabList = [LocaleKeys.keyOwnPackage, LocaleKeys.keyClientPackage];

  int agencyUserTabIndex = 0;

  ///Change Agency  user  Tab
  void changeAgencyDetailsTab(index) {
    agencyUserTabIndex = index;
    notifyListeners();
  }

  /// agency purchase dialog list
  String selectedAgencyPurchasePackageFor = LocaleKeys.keyForYourself;
  List<String> agencyPurchasePackageDialogList = [
    LocaleKeys.keyForYourself,
    LocaleKeys.keyForClient,
  ];

  void changeSelectedAgencyPurchasePackageFor(String value) {
    selectedAgencyPurchasePackageFor = value;
    notifyListeners();
  }

  ///Filter check
  bool isFilterApplied() {
    return destinationData != null;
  }

  ///Clear Filters
  void clearFilters(BuildContext context) {
    destinationData = null;
    notifyListeners();
  }

  void screenNavigationOnTabChange(WidgetRef ref) {
    ref.read(navigationStackController).pushRemove(NavigationStackItem.package(tabIndex: agencyUserTabIndex));
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ///Progress Indicator
  bool isLoading = false;

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }

  var packageListState = UIState<PackageListResponseModel>();
  int pageNo = 1;
  List<PackageData?> packageList = [];

  /// package List APi
  Future<void> packageListApi(
    BuildContext context,
    bool pagination,
  ) async {
    if (packageListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if (pageNo == 1 || pagination == false) {
      packageListState.isLoading = true;
      packageList = [];
      showLog("packageList >> Before filling ${packageList.length}");
    } else {
      packageListState.isLoadMore = true;
      packageListState.isLoadMore = true;
    }

    packageListState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {'searchKeyword': packageSearchCtr.text.trimSpace, Session.getUserType() == userTypeValue.reverse[UserType.VENDOR] ? 'vendorUuid' : 'agencyUuid': Session.getUuid(), 'isGetOnlyClient': agencyUserTabIndex == 1 ? true : false, 'destinationUuid': destinationData?.uuid ?? ''};

    String requestBody = jsonEncode(request);
    final result = await packageRepository.packageListApi(request: requestBody, pageNumber: pageNo);

    result.when(success: (data) async {
      packageListState.success = data;
      packageList.addAll(packageListState.success?.data ?? []);
      showLog("packageList >>  After filling ${packageList.length}");
      packageListState.isLoading = false;
      packageListState.isLoadMore = false;
    }, failure: (NetworkExceptions error) {
      packageListState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    packageListState.isLoading = false;
    packageListState.isLoadMore = false;

    notifyListeners();
  }

  var purchasePackageState = UIState<CommonResponseModel>();

  Future<UIState<CommonResponseModel>> purchasePackage({
    required BuildContext context,
    required String destinationUuid,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? budget,
    required String? storeUuid,
    required String? clientUuid,
    required int? dailyBudget,
  }) async {
    purchasePackageState.isLoading = true;
    purchasePackageState.success = null;

    notifyListeners();

    Map<String, dynamic> request = {
      'destinationUuid': destinationUuid,
      // 'startDate': startDate?.toUtc().millisecondsSinceEpoch,
      'startDate': await getUtcTime(startDate),
      'endDate': getUtcTime(endDate),
      'budget': budget?.trimSpace,
      'dailyBudget': dailyBudget.toString().trimSpace
    };

    /// vendor
    if (Session.getUserType() == userTypeValue.reverse[UserType.VENDOR]) {
      request.addAll(
        {'vendorUuid': Session.getUuid(), 'storeUuid': storeUuid},
      );
    } else {
      /// agency
      request.addAll({
        'agencyUuid': Session.getUuid(),
      });
      if (clientUuid != null && clientUuid.isNotEmpty) {
        request.addAll({'clientMasterUuid': clientUuid});
      }
    }

    String requestBody = jsonEncode(request);

    final result = await packageRepository.purchasePackageApi(request: requestBody);
    result.when(success: (data) async {
      purchasePackageState.success = data;
      purchasePackageState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      purchasePackageState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    purchasePackageState.isLoading = false;
    notifyListeners();
    return purchasePackageState;
  }
}
