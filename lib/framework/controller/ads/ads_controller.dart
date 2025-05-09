import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/ads/contract/ads_repository.dart';
import 'package:odigo_vendor/framework/repository/ads/model/request_model/ad_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/ads_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/client_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';

final adsController = ChangeNotifierProvider(
      (ref) => getIt<AdsController>(),
);

@injectable
class AdsController extends ChangeNotifier {
final AdsRepository adsRepository;
AdsController(this.adsRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isSelectedOwnAds = true;
    adsListState.success = null;
    clientDataList.clear();
    storeList.clear();
    adsListState.isLoading = true;
    adsList = [];
    pageNo = 1;
    selectedDestinationData = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  ///Dispose Controller
  void disposeData({bool isNotify = false}) {
  isSelectedOwnAds = true;
  adsListState.success = null;
  clientDataList.clear();
  adsListState.isLoading = true;
  adsList = [];
  pageNo = 1;
  selectedDestinationData = null;
  if (isNotify) {
    notifyListeners();
  }
}

  disposeApiData(){
    adsListState.success = null;
    adsListState.isLoading = true;
    adsList = [];
    pageNo = 1;
    notifyListeners();
  }

  List<ClientData?> clientDataList = [];
  updateClientList(List<ClientData?> data){
      clientDataList.addAll(data);
      notifyListeners();
  }
  ScrollController storeScrollCtr = ScrollController();

  List<StoreListData?> storeList = [];

  updateStoreList(List<StoreListData?> data){
    storeList.addAll(data);
    notifyListeners();
  }
  replaceStoreData(List<StoreListData?> data){
    storeList= data;
    notifyListeners();
  }
  ///Filter check
  bool isFilterApplied() {
    return selectedDestinationData != null ;
  }

  ///Clear Filters
  void clearFilters(BuildContext context) {
    selectedDestinationData = null;
    notifyListeners();
  }

  DestinationData? selectedDestinationData;
  updateDestination(DestinationData? data){
    selectedDestinationData =  data;
    notifyListeners();
  }

  TextEditingController searchCtr = TextEditingController();
  ScrollController vendorAdsCtr = ScrollController();
  ScrollController agentAdsCtr = ScrollController();
  ScrollController clientAdsCtr = ScrollController();

  bool isSelectedOwnAds = true;
  updateAgencyOwnAds(bool value){
    isSelectedOwnAds = value;
    notifyListeners();
  }

void screenNavigationOnTabChange(int index,WidgetRef ref){
  ref.read(navigationStackController).pushRemove(NavigationStackItem.ads(tabIndex: index));
}

  GlobalKey importDialogKey = GlobalKey();


  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  var changeStatusOfDefaultAdState = UIState<CommonResponseModel>();
  var changeStatusOfAdState = UIState<CommonResponseModel>();
  var archiveAdState = UIState<CommonResponseModel>();

  var adsListState = UIState<AdsListResponseModel>();

  int pageNo = 1;
  List<AdsListData?> adsList = [];


  /// Ads List APi
  Future<UIState<AdsListResponseModel>> adsListApi(BuildContext context,bool pagination,{String? vendorUuid, String? agencyUuid, bool? isGetOnlyClient = false, String? storeUuid, String? cilentMasterUuid, String? destinationUuid}) async {
    if ( adsListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if(pageNo == 1 || pagination == false ){
      adsListState.isLoading = true;
      adsList = [];
    }
    else{
      adsListState.isLoadMore = true;
      adsListState.success = null;

    }

    notifyListeners();


    AdListRequestModel requestModel = AdListRequestModel(
        searchKeyword: searchCtr.text.trimSpace,
        isArchive: false,
        storeUuid: storeUuid,
        destinationUuid: selectedDestinationData?.uuid ?? destinationUuid,
        cilentMasterUuid: cilentMasterUuid,
        // activeRecords: true,
      vendorUuid: Session.getUserType() == UserType.VENDOR.name? Session.getUuid() : null,
      agencyUuid: Session.getUserType() == UserType.AGENCY.name? Session.getUuid() : null,
        isGetOnlyClient: Session.getUserType() == UserType.AGENCY.name? (isGetOnlyClient ?? false)? true: false : false
    );
    final String request = adListRequestModelToJson(requestModel);
    final result = await adsRepository.adListApi(request: request, pageNo: pageNo);


    result.when(success: (data) async {
      adsListState.success = data;
      adsList.addAll(adsListState.success?.data ?? []);

      adsListState.isLoading = false;
      adsListState.isLoadMore = false;

    }, failure: (NetworkExceptions error) {
      adsListState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context:context,message: errorMsg);
    });
    adsListState.isLoading = false;
    adsListState.isLoadMore = false;
    notifyListeners();
    return adsListState;
  }

  int? updatingAdListtemIndex;
  int? updatingAdStatusIndex;
  int? updateDeleteIndex;


/// change status of default ad api
  Future<void> changeStatusOfDefaultAdApi(BuildContext context, {/*required AdsListData? adsData*/required String adUid}) async {
    changeStatusOfDefaultAdState.isLoading = true;
    changeStatusOfDefaultAdState.success = null;
    // updatingAdListtemIndex =  adsList.indexWhere((element) => element?.uuid == adsData?.uuid);
    notifyListeners();

    final result = await adsRepository.changeStatusOfDefaultAd(adUuid: adUid);

    result.when(success: (data) async {
      changeStatusOfDefaultAdState.success = data;
    //   if(changeStatusOfDefaultAdState.success?.status == ApiEndPoints.apiStatus_200){
    //     adsList.forEach((element) {
    //       if (element?.uuid == adsData?.uuid ) {
    //         element?.isDefault = true;
    //       }
    //       else if(element?.adsByName == adsData?.adsByName ){
    //         element?.isDefault = false;
    //       }
    //     });
    //     adsList.every((element)=> element?.isDefault == false);
    //
    //     // adsList.where((element)=> element?.uuid == adUuid).firstOrNull?.isDefault = true;
    //   }
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    changeStatusOfDefaultAdState.isLoading = false;
    notifyListeners();
  }


  /// change status of ad api
  Future<void> changeStatusOfAdApi(BuildContext context, {required String adUuid, required String status}) async {
  changeStatusOfAdState.isLoading = true;
  changeStatusOfAdState.success = null;
  updatingAdStatusIndex =  adsList.indexWhere((element) => element?.uuid == adUuid);

  notifyListeners();

  final result = await adsRepository.changeStatusOfAd(adUuid: adUuid, status: status);

  result.when(success: (data) async {
    changeStatusOfAdState.success = data;
    if(changeStatusOfAdState.success?.status == ApiEndPoints.apiStatus_200){
      adsList.where((element) => element?.uuid == adUuid).first?.active = !(adsList.where((element) => element?.uuid == adUuid).first?.active ??  false);
    }
  },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

  changeStatusOfAdState.isLoading = false;
  notifyListeners();
}


  /// Archive Ad api
  Future<void> archiveAdApi(BuildContext context, {required String adUuid}) async {
    archiveAdState.isLoading = true;
    archiveAdState.success = null;
    updateDeleteIndex =  adsList.indexWhere((element) => element?.uuid == adUuid);

    notifyListeners();

  final result = await adsRepository.archiveAd(adUuid: adUuid);

  result.when(success: (data) async {
    archiveAdState.success = data;
    if(archiveAdState.success?.status == ApiEndPoints.apiStatus_200){
      adsList.removeWhere((element) =>  element?.uuid == adUuid);
    }
  },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

    archiveAdState.isLoading = false;
  notifyListeners();
}
}
