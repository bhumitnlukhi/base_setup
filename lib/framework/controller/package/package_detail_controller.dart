import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/package/contract/package_repository.dart';
import 'package:odigo_vendor/framework/repository/package/model/package_wallet_history_response_model.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/wallet_amount_request_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';

final packageDetailController = ChangeNotifierProvider(
      (ref) => getIt<PackageDetailController>(),
);

@injectable
class PackageDetailController extends ChangeNotifier {
  final PackageRepository packageRepository;
  PackageDetailController(this.packageRepository);
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    packageWalletHistoryListState.success = null;
    packageWalletHistoryListState.isLoading = true;
    isBalanceHidden = true;
    pageNo = 1;
    currentBalanceValue = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  ScrollController historyScrollController = ScrollController();

  bool isBalanceHidden = true;
  GlobalKey detailsDialogKey = GlobalKey();

  int? currentBalanceValue ;

  ///change visibility of the password
  void changeBalanceVisibility(){
    isBalanceHidden = !isBalanceHidden;
    notifyListeners();
  }
  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  var packageWalletHistoryListState = UIState<PackageWalletHistoryResponseModel>();

  List<PackageWalletTransactionResponseDto> packageWalletListData = [];

  int pageNo = 1;
  /// package wallet history List api
  Future<UIState<PackageWalletHistoryResponseModel>> packageWalletHistoryListApi(BuildContext context, bool pagination,{
    required String packageUuid,
    String? clientMasterUuid
  }) async {


    if ( packageWalletHistoryListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if(pageNo == 1 || pagination == false ){
      packageWalletHistoryListState.isLoading = true;
      packageWalletListData = [];
    }
    else{
      packageWalletHistoryListState.isLoadMore = true;
      packageWalletHistoryListState.isLoadMore = true;

    }

    packageWalletHistoryListState.success = null;
    notifyListeners();


    WalletAmountListRequestModel requestModel = WalletAmountListRequestModel(
        vendorUuid: Session.getUserType() == UserType.VENDOR.name ? Session.getUuid() : null,
        agencyUuid: (Session.getUserType() == UserType.AGENCY.name && clientMasterUuid==null) ? Session.getUuid() : null,
        clientMasterUuid: clientMasterUuid,
        // fromDate: startDate?.millisecondsSinceEpoch.toString(),
        // toDate: endDate?.millisecondsSinceEpoch.toString(),
      fromDate : startDate!=null? getUtcTime(startDate!).toString():null,
      toDate :  endDate!=null? getUtcTime(endDate).toString(): null,

      // transactionType: selectedTransactionType.name==TransactionType.ALL.name? null : selectedTransactionType.name
    );

    String request = walletAmountListRequestModelToJson(requestModel);

    final result = await packageRepository.packageWalletHistoryApi(request: request, packageUuid: packageUuid,  pageNo: pageNo);

    result.when(success: (data) async {
      packageWalletHistoryListState.success = data;
      packageWalletListData.addAll(packageWalletHistoryListState.success?.data?.packageWalletTransactionResponseDtOs?? []);
      if(pageNo == 1){
        currentBalanceValue = packageWalletHistoryListState.success?.data?.currentBalance;
      }
      packageWalletHistoryListState.isLoading = false;
      packageWalletHistoryListState.isLoadMore = false;

    }, failure: (NetworkExceptions error) {
      packageWalletHistoryListState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context:context,message: errorMsg);
    });
    packageWalletHistoryListState.isLoading = false;
    packageWalletHistoryListState.isLoadMore = false;

    notifyListeners();

    packageWalletHistoryListState.isLoading = true;
    packageWalletHistoryListState.success = null;
    notifyListeners();



    result.when(success: (data) async {
      packageWalletHistoryListState.success = data;
      packageWalletHistoryListState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    packageWalletHistoryListState.isLoading = false;
    notifyListeners();
    return packageWalletHistoryListState;
  }



  GlobalKey ticketKey = GlobalKey();
  GlobalKey dateKey = GlobalKey();
  GlobalKey calenderKey = GlobalKey();
  GlobalKey popupKey = GlobalKey();


  /// Search Ctr
  TextEditingController ctrSearch = TextEditingController();

  /// Controller for the comment
  TextEditingController ctrComment  = TextEditingController();

  TextEditingController ticketListCtr  = TextEditingController();

  ScrollController ticketListScrollController = ScrollController();

  ///Form key
  final formKey= GlobalKey<FormState>();

  /// Stores the value for the selected status
  String? strSelectedStatus;

  /// Variable to manage the enabled and disable comment
  bool isCommentEnable = false;

  /// Update the selected status
  void updateStatus(String value)
  {
    strSelectedStatus = value;
    notifyListeners();
  }

  /// Filter By Ticket Status
  List<String> statusList = [
    TicketStatus.ALL.name.localized,
    TicketStatus.PENDING.name.localized,
    TicketStatus.ACKNOWLEDGED.name.localized,
    TicketStatus.RESOLVED.name.localized,
  ];

  /// Dropdown List
  List<String> updateDropdownList = [
    TicketStatus.PENDING.name.localized,
    TicketStatus.ACKNOWLEDGED.name.localized,
    TicketStatus.RESOLVED.name.localized,
  ];

  /// Selected popmenu filter
  int selectedStatusByFilter = 0;

  /// Filter List by Designation
  void updateSelectedStatusByFilter(int index) {
    selectedStatusByFilter = index;
    notifyListeners();
  }

  /// Update Text Controllers
  void updateTextControllers(String? value, String? comment){
    strSelectedStatus=value;
    ctrComment.text = comment??'';
    notifyListeners();
  }

  /// List of Recent Searches
  List<String> searchList = [];
  /// Add Searched String in Search History
  void updateSearchList() {
    if (ctrSearch.text.isNotEmpty) {
      searchList.removeWhere(
            (element) => element.toLowerCase() == ctrSearch.text.toLowerCase(),
      );
      searchList.add(ctrSearch.text);
      searchList = searchList.reversed.toList();
      notifyListeners();
    }
  }

  ///current list searching
  // List<CreatedTicketDataata>? allSearchedItemList = [];

  /// update current search item list based on search
  // void updateAllSearchedItemList(List<CreatedTicketData>? itemList) {
  //   allSearchedItemList = itemList
  //       ?.where((element) => element.id.toString()
  //       .contains(ctrSearch.text) || element.name.toString().toLowerCase().contains(ctrSearch.text.toLowerCase()))
  //       .toList();
  //   notifyListeners();
  // }notifyListeners

  ///to Filter Past Orders
  DateTime? startDate;
  DateTime? endDate;
  DateTime? tempDate;

  ///Update start and end date
  void updateStartEndDate(bool isStartDate, DateTime? date) {
    if (isStartDate) {
      startDate = date;
    } else {
      endDate = date;
    }
    checkStartEndDateValid();

    notifyListeners();
  }

  /// Update start date and end after clear date filter
  void clearStartDateEndDate({DateTime? callbackStartDate, DateTime? callbackEndDate}){
    // startDate = callbackStartDate;
    // endDate = callbackEndDate;

    startDate = null;
    endDate = null;
    notifyListeners();
  }

  bool isCheckStartEndDateValid = false;

  ///Validation for start and end date
  bool checkStartEndDateValid() {
    if (startDate != null && endDate != null) {
      isCheckStartEndDateValid = true;
    } else {
      isCheckStartEndDateValid = false;
    }
    return isCheckStartEndDateValid;
  }

  ///Update Temp date
  void updateTempDate(DateTime? tempDate) {
    this.tempDate = tempDate;
    notifyListeners();
  }

  bool isDatePickerVisible = false;

  /// Function will update the value of picker visible
  updateIsDatePickerVisible(bool isDatePickerVisible) {
    this.isDatePickerVisible = isDatePickerVisible;
    // notifyListeners();
  }


  ///Validate update button
  bool isALLFieldsValid = false;
// validateUpdateForm(int index,{String? comment}){
//   // isALLFieldsValid=strSelectedStatus !=null && (ticketListState.success?.data?[index].ticketStatus
//   isALLFieldsValid=strSelectedStatus !=null && (ticketList[index]?.ticketStatus
//       != strSelectedStatus.toString().toUpperCase() && strSelectedStatus != LocaleKeys.keyPending.localized)
//       && (validateText(comment, LocaleKeys.keyDescriptionIsRequired.localized)==null) ?true:false;
//   notifyListeners();
// }

}
