import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/contract/store_repository.dart';
import 'package:odigo_vendor/framework/repository/store/model/assign_store_request_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';

final addEditStoreController = ChangeNotifierProvider(
  (ref) => getIt<AddEditStoreController>(),
);

@injectable
class AddEditStoreController extends ChangeNotifier {
  final StoreRepository storeRepository;

  AddEditStoreController(this.storeRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    selectedStore = null;
    selectedDestination = null;
    storeListState.isLoading = false;
    storeListState.success = null;
    storeList.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  ///Selected Destination
  DestinationData? selectedDestination;

  ///Update Selected Destination
  updateSelectedDestination(DestinationData? selectedDestination) {
    this.selectedDestination = selectedDestination;
    notifyListeners();
  }

  StoreListData? selectedStore;

  updateSelectedStore(StoreListData? selectedStore) {
    this.selectedStore = selectedStore;
    notifyListeners();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  var storeListState = UIState<StoreListResponseModel>();
  List<StoreListData?> storeList = [];
  int pageNo = 1;

  /// Page number for pagination of store
  int pageNumber = 1;

  /// Store scroll controller
  ScrollController storeScrollController = ScrollController();

  /// Api call with pagination
  void storeListApiCall(BuildContext context, {String? searchText}) async {
    resetPagination();
    await storeListApi(context, searchText: searchText);
    storeScrollController.addListener(() async {
      if ((storeScrollController.position.pixels >= storeScrollController.position.maxScrollExtent)) {
        if ((storeListState.success?.hasNextPage ?? false) && !(storeListState.isLoadMore)) {
          increasePageNumber();
          await storeListApi(context, searchText: searchText);
        }
      }
    });
  }

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
    notifyListeners();
  }

  /// Store List APi
  Future<void> storeListApi(BuildContext context, {String? searchText, int? pageSize, String? destinationUuid}) async {
    if (storeListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if (pageNo == 1) {
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
      'searchKeyword': searchText?.trimSpace,
      "isUnique": true,
      "isUnassigned": true,
      "destinationUuid": destinationUuid,
    };

    final result = await storeRepository.odigoStoreListApi(request: jsonEncode(request), pageNumber: pageNo, pageSize: pageSize);

    result.when(success: (data) async {
      storeListState.success = data;
      storeListState.success?.data?.forEach((store) {
        if (storeList.where((element) => (element?.uuid == store.uuid)).firstOrNull == null) {
          storeList.add(store);
        }
      });
      storeListState.isLoading = false;
      storeListState.isLoadMore = false;
    }, failure: (NetworkExceptions error) {
      storeListState.isLoadMore = false;
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    storeListState.isLoading = false;
    storeListState.isLoadMore = false;
    notifyListeners();
  }

  var assignStoreState = UIState<CommonResponseModel>();

  /// Assign Store APi
  Future<void> assignStoreApi(BuildContext context) async {
    assignStoreState.success = null;
    assignStoreState.isLoading = true;
    notifyListeners();
    AssignStoreRequestModel assignStoreRequestModel = AssignStoreRequestModel(
      vendorUuid: Session.getUuid(),
      destinationOdigoStoreMappingDtOs: [
        DestinationOdigoStoreMappingDto(destinationUuid: selectedDestination?.uuid, odigoStoreUuid: selectedStore?.uuid),
      ],
    );
    final result = await storeRepository.assignStoreApi(request: assignStoreRequestModel.toJson());
    result.when(success: (data) async {
      assignStoreState.success = data;
      storeListState.isLoading = false;
    }, failure: (NetworkExceptions error) {
      assignStoreState.isLoading = false;
      notifyListeners();
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    assignStoreState.isLoading = false;
    notifyListeners();
  }
}
