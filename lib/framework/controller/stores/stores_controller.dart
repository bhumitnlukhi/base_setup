import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/contract/store_repository.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_details_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_language_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/stores/web/helper/store_details_dialog_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/repository/registration/model/request_model/destination_list_request_model.dart';

final storesController = ChangeNotifierProvider(
  (ref) => getIt<StoresController>(),
);

@injectable
class StoresController extends ChangeNotifier {
  final StoreRepository storeRepository;
  OverlayPortalController? tooltipDestinationController;

  ///For filter overlay
  final LayerLink link = LayerLink();
  // final OverlayPortalController tooltipController = OverlayPortalController();

  ///Key for details Dialog
  GlobalKey detailsDialogKey = GlobalKey();

  ///Key for loading Dialog
  GlobalKey loadingDialogKey = GlobalKey();

  StoresController(this.storeRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isLoading = false;
    storeListState.success = null;
    storeListState.isLoading = false;
    storeList.clear();
    destinationListState.success = null;
    storeDetailsLanguageState.success = null;
    destinationListState.isLoading = false;
    tooltipDestinationController = null;
    pageNumber = 1;
    selectedDestination = null;

    if (isNotify) {
      notifyListeners();
    }
  }

  final TextEditingController storeSearchCtr = TextEditingController();

  clearSearchCtr() {
    storeSearchCtr.text = '';
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  var storeListState = UIState<StoreListResponseModel>();
  List<StoreListData?> storeList = [];
  // int pageNo = 1;

  ///Progress Indicator
  bool isLoading = false;

  /// Page number for pagination of store
  int pageNumber = 1;

  /// Store scroll controller
  ScrollController storeScrollController = ScrollController();

  /// Api call with pagination
  Future<void> storeListApiCall(BuildContext context, {bool? activeRecords}) async {
    resetPagination();
    showLog("pageNumber storeListApiCall $pageNumber");
    storeScrollController.removeListener(() {});
    await storeListApi(context, dataSize: pageCount, activeRecords: activeRecords);
    storeScrollController.addListener(() async {
      if ((storeScrollController.position.pixels >= storeScrollController.position.maxScrollExtent)) {
        if ((storeListState.success?.hasNextPage ?? false) && !(storeListState.isLoadMore)) {
          // increasePageNumber();
          await storeListApi(context, dataSize: pageCount, activeRecords: activeRecords);
        }
      }
    });
    notifyListeners();
  }

  GlobalKey storeImportDialogKey = GlobalKey();

  /// Reset Pagination
  void resetPagination() {
    pageNumber = 1;
    storeList.clear();
    storeListState.success = null;
    notifyListeners();
  }

  /// Increase page no
  void increasePageNumber() {
    pageNumber += 1;
    showLog("pageNumber increasePageNumber : $pageNumber");
    notifyListeners();
  }


  StoreListData? selectedStoreData;

  List<StoreListData?> searchedStoreList = [];

  searchStore(String storeName) {
    if (storeName.isEmpty) {
      searchedStoreList = storeList;
    } else {
      searchedStoreList = storeList.where((store) => (store?.name?.toLowerCase().contains(storeName.toLowerCase()) ?? false)).toList();
    }
    notifyListeners();
  }
  updateSelectedStore(StoreListData? selectedStore) {
    selectedStoreData = selectedStore;
    notifyListeners();
  }

    /// Store List APi
  Future<void> storeListApi(BuildContext context, {required int dataSize, required bool? activeRecords}) async {
    if (storeListState.success?.hasNextPage ?? false) {
      pageNumber = pageNumber + 1;
    }

    if (pageNumber == 1) {
      storeListState.isLoading = true;
      storeList = [];
    } else {
      storeListState.isLoadMore = true;
      storeListState.isLoadMore = true;
    }

    storeListState.success = null;
    notifyListeners();

    Map<String, dynamic> request = {'searchKeyword': storeSearchCtr.text.trimSpace, 'destinationUuid': selectedDestination?.uuid, 'activeRecords': activeRecords};

    final result = await storeRepository.storeListApi(request: jsonEncode(request), pageNumber: pageNumber, uuid: Session.getUuid(), dataSize: dataSize);

    result.when(success: (data) async {
      storeListState.success = data;
      storeList.addAll(storeListState.success?.data ?? []);
      storeListState.isLoading = false;
      storeListState.isLoadMore = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      storeListState.isLoadMore = false;
      storeListState.isLoading = false;
      storeListState.success = null;
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
      notifyListeners();
    });
    storeListState.isLoading = false;
    storeListState.isLoadMore = false;
    notifyListeners();
  }

  var storeDetailsState = UIState<StoreDetailsResponseModel>();

  /// Store Detail APi
  Future<void> storeDetailApi(BuildContext context, {required String storeUuid, required bool forOdigoStore}) async {
    storeDetailsState.success = null;
    storeDetailsState.isLoading = true;
    notifyListeners();
    final result = await storeRepository.storeDetailApi(storeUuid: storeUuid, forOdigoStore: forOdigoStore);
    result.when(success: (data) async {
      storeDetailsState.success = data;
      storeDetailsState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      storeDetailsState.isLoading = false;
      notifyListeners();
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    storeDetailsState.isLoading = false;
    notifyListeners();
  }

  var storeDetailsLanguageState = UIState<StoreLanguageDetailResponseModel>();

  /// Store Detail APi
  Future<void> storeDetailLanguageApi(BuildContext context, {required String storeUuid}) async {
    storeDetailsLanguageState.success = null;
    storeDetailsLanguageState.isLoading = true;
    notifyListeners();
    final result = await storeRepository.storeDetailLanguageApi(storeUuid: storeUuid, );
    result.when(success: (data) async {
      storeDetailsLanguageState.success = data;
      storeDetailsLanguageState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      storeDetailsLanguageState.isLoading = false;
      notifyListeners();
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    storeDetailsLanguageState.isLoading = false;
    notifyListeners();
  }

  Future<void> showStoreDetailsDialog(BuildContext context, WidgetRef ref, {required String storeUuid}) async {
    if (detailsDialogKey.currentContext == null) {
      await storeDetailApi(context, storeUuid: storeUuid, forOdigoStore: false).then((value) {
        if (storeDetailsState.success?.status == ApiEndPoints.apiStatus_200 && storeDetailsState.success?.data != null) {
          showCommonWebDialog(
              // height: storeDetailsState.success?.data?.verificationResultResponseDto?.status == 'REJECTED' ? 0.600 : 0.450,
              width: 0.7,
              context: context,
              keyBadge: detailsDialogKey,
              dialogBody: const StoreDetailsDialogWidget());
        } else {
          ref.read(navigationStackController).pushRemove(const NavigationStackItem.stores());
        }
      });
    }
  }

  (Color bgColor, Color textColor) getStatusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return (AppColors.clrE7FBFF, AppColors.clr009AF1);
      case 'REJECTED':
        return (AppColors.clrFFECEC, AppColors.clrEB1F1F);
      case 'ACTIVE':
        return (AppColors.clrEAFFF0, AppColors.clr35A600);
      case 'ACCEPTED':
        return (AppColors.clrEAFFF0, AppColors.clr35A600);
      case 'INACTIVE':
        return (AppColors.clrE9E9E9, AppColors.clrB0B0B0);
      default:
        return (AppColors.clrE9E9E9, AppColors.clrB0B0B0);
    }
  }

  ////Change Status Api////
  var updateStoreStatusState = UIState<CommonResponseModel>();

  int? updatingStoreIndex;

  /// Store Detail APi
  Future<void> updateStoreStatusApi(BuildContext context, {required String storeUuid, required String status, required int updatingStoreIndex}) async {
    updateStoreStatusState.success = null;
    this.updatingStoreIndex = updatingStoreIndex;
    updateStoreStatusState.isLoading = true;
    notifyListeners();
    final result = await storeRepository.updateStoreStatusApi(storeUuid: storeUuid, status: status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE');
    result.when(success: (data) async {
      updateStoreStatusState.success = data;
      if (updateStoreStatusState.success?.status == ApiEndPoints.apiStatus_200) {
        storeList[updatingStoreIndex]?.status = (status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE');
        this.updatingStoreIndex = null;
      }
      notifyListeners();
      updateStoreStatusState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      updateStoreStatusState.isLoading = false;
      this.updatingStoreIndex = null;
      notifyListeners();
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    updateStoreStatusState.isLoading = false;
    notifyListeners();
  }

  ///--------------- Destination -------------------///

  var destinationListState = UIState<DestinationListResponseModel>();
  List<DestinationData?> destinationList = [];
  List<DestinationData?> searchedDestinationList = [];

  ///Search Destination
  searchDestination(String destinationName) {
    showLog("searchDestination");
    if (destinationName.isEmpty) {
      showLog("searchDestination isEmplty");
      showLog("destinationList ${destinationList.length}");
      searchedDestinationList = destinationList;
      showLog("searchedDestinationList ${searchedDestinationList.length}");

    } else {
      searchedDestinationList = destinationList.where((destination) => (destination?.name?.toLowerCase().contains(destinationName.toLowerCase()) ?? false)).toList();
    }
    notifyListeners();
  }

  int destinationPageNumber = 1;

  /// Store scroll controller
  ScrollController destinationScrollController = ScrollController();

  /// Reset Pagination
  void resetDestinationPagination() {
    destinationPageNumber = 1;
    destinationList.clear();
    destinationListState.isLoading = false;
    destinationListState.success = null;
    notifyListeners();
  }

  /// Increase page no
  void increaseDestinationPageNumber() {
    destinationPageNumber += 1;
    notifyListeners();
  }

  ///Selected Destination for Filter
  DestinationData? selectedDestination;

  updateSelectedDestination(DestinationData? selectedDestination) {
    this.selectedDestination = selectedDestination;
    notifyListeners();
    isFilterApplied();
  }

  /// destination List APi
  Future<void> destinationListApi(BuildContext context, {bool? activeRecords, bool? hasAdsForClient, bool? hasAds, bool? hasPurchased, bool? hasPurchasedForClient, String? searchText, int? pageSize}) async {
    if (destinationListState.success?.hasNextPage ?? false) {
      destinationPageNumber = destinationPageNumber + 1;
    }

    if (destinationPageNumber == 1) {
      destinationListState.isLoading = true;
      destinationList.clear();
    } else {
      destinationListState.isLoading = true;
      destinationListState.isLoadMore = true;
    }

    destinationListState.success = null;
    notifyListeners();

    DestinationListRequestModel requestModel = DestinationListRequestModel(
      activeRecords: activeRecords,
      searchKeyword: searchText?.trimSpace,
      hasAdsForClient: hasAdsForClient,
      hasAds: hasAds,
      hasPurchased: hasPurchased,
      hasPurchasedForClient: hasPurchasedForClient,
      countryUuid: Session.userBox.get(keyCountryUuid),
    );
    // Map<String, dynamic> request = {
    //   'activeRecords': true,
    //   'searchKeyword': searchText,
    // };
    final String request = destinationListRequestModelToJson(requestModel);

    // String requestBody = jsonEncode(request);
    final result = await storeRepository.destinationListApi(request: request, pageNumber: destinationPageNumber, pageSize: pageSize);

    result.when(success: (data) async {
      destinationListState.success = data;
      destinationList.addAll(destinationListState.success?.data ?? []);
      // destinationListState.success?.data?.forEach((destination) {
      //   if (destinationList.where((element) => (element?.uuid == destination.uuid)).firstOrNull == null) {
      //     destinationList.add(destination);
      //   }
      // });
      searchedDestinationList.clear();
      searchedDestinationList.addAll(destinationListState.success?.data ?? []);
      destinationListState.isLoading = false;
      destinationListState.isLoadMore = false;
    }, failure: (NetworkExceptions error) {
      destinationListState.isLoadMore = false;
      destinationListState.isLoading = false;
      notifyListeners();
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    destinationListState.isLoading = false;
    destinationListState.isLoadMore = false;
    notifyListeners();
  }

  ///Destination Api call with pagination
  Future<void> destinationListApiCall(BuildContext context, {String? searchText, int? pageSize}) async {
    resetDestinationPagination();
    await destinationListApi(context, searchText: searchText, pageSize: pageSize, activeRecords: true);
    storeScrollController.addListener(() async {
      if ((storeScrollController.position.pixels >= storeScrollController.position.maxScrollExtent)) {
        if ((destinationListState.success?.hasNextPage ?? false) && !(destinationListState.isLoadMore)) {
          increaseDestinationPageNumber();
          await destinationListApi(context, searchText: searchText, activeRecords: true);
        }
      }
    });
  }

  ///Filter check
  bool isFilterApplied() {
    return (selectedDestination != null || storeSearchCtr.text.isNotEmpty);
  }

  ///Clear Filters
  void clearFilters(BuildContext context) {
    selectedDestination = null;
    storeSearchCtr.clear();
    disposeController(isNotify: true);
    storeListApiCall(context);
    notifyListeners();
  }

  ///------------ Destination --------------///
}
