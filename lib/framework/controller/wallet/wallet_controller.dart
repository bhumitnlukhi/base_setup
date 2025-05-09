import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/client_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/wallet/contract/wallet_repository.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/add_wallet_amount_request_model.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/response/vendor_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/response/wallet_amount_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/wallet_amount_request_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';

final walletController = ChangeNotifierProvider(
      (ref) => getIt<WalletController>(),
);

@injectable
class WalletController extends ChangeNotifier {
  final WalletRepository walletRepository;
  WalletController(this.walletRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    selectedClient = null;
    amountController.text='';
    isAllFieldValid = false;
    clientList = [];
    transactionHistoryListState.isLoading = true;
    transactionHistoryListState.success = null;
    walletListData = [];
    pageNo = 1;
    selectedClientInList = null;
    selectedTransactionType = TransactionType.ALL;
    isBalanceHidden = true;
    isMenuEnable = false;
    filterApplied = false;
    clientListForDropDown.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  disposeWalletHistoryData(){
    transactionHistoryListState.isLoading = true;
    transactionHistoryListState.success = null;
    walletListData = [];
    // selectedTransactionType = TransactionType.ALL;
    pageNo = 1;
    notifyListeners();
  }
  ///Any pop up menu opened
  bool isMenuEnable = false;

  updateIsMenuEnable(bool isMenuEnable) {
    this.isMenuEnable = isMenuEnable;
    notifyListeners();
  }

  List<TransactionType> transactionTypeFilterList = [
    TransactionType.CREDIT,
    TransactionType.DEBIT,
    TransactionType.ALL,

  ];

  TransactionType selectedTransactionType = TransactionType.ALL;
  bool filterApplied = false;
  updateSelectedType(BuildContext context, TransactionType type){
    selectedTransactionType = type;
    filterApplied=true;
    notifyListeners();
  }

  filterChanged(){
    filterApplied=false;
    notifyListeners();
  }

  ScrollController historyScrollController = ScrollController();

  GlobalKey addFundDialogKey = GlobalKey();
  GlobalKey addFundAgencyDialogKey = GlobalKey();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ///Amount Controller
  TextEditingController amountController = TextEditingController();

  bool isBalanceHidden = true;

  ///change visibility of the password
  void changeBalanceVisibility(){
    isBalanceHidden = !isBalanceHidden;
    notifyListeners();
  }

  ///Dispose Amount
  disposeDialogData(){
    isAllFieldValid = false;
    amountController.text='';
    selectedClient = null;
    addFundFor = LocaleKeys.keyForYourself;
    notifyListeners();
  }

  bool isAllFieldValid = false;

  checkFieldValid(){
    isAllFieldValid=(amountController.text!='' );
    notifyListeners();
  }

  ClientData? selectedClient;
  List<ClientData> clientListForDropDown = [];
  void setClientListForDropDown(List<ClientData?> list){
    for(ClientData? item in list){
      if(item != null) {
        if (item.active == true) {
          clientListForDropDown.add(item);
        }
      }
    }
    notifyListeners();
  }
  updateSelectedClient(ClientData? value){
    selectedClient = value;
    notifyListeners();
  }

  updateClientList(List<ClientData?> list){
    clientList = list;
    notifyListeners();
  }

  ClientData? selectedClientInList;
  updateSelectedClientInList(ClientData? value){
    selectedClientInList = value;
    notifyListeners();
  }

  /// agency purchase dialog list
  String addFundFor = LocaleKeys.keyForYourself;
  List<String> agencyPurchasePackageDialogList = [
    LocaleKeys.keyForYourself,
    LocaleKeys.keyForClient,
  ];
  void changeSelectedAgencyPurchasePackageFor(String value){
    addFundFor=value;
    notifyListeners();
  }


  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  List<ClientData?> clientList = [];


  var addWalletAmountState = UIState<CommonResponseModel>();

  /// add wallet amount api
  Future<void> addWalletAmountApi(BuildContext context, {String? clientMasterUuid}) async {
    addWalletAmountState.isLoading = true;
    addWalletAmountState.success = null;
    notifyListeners();

    AddWalletAmountRequestModel requestModel = AddWalletAmountRequestModel(
      agencyUuid: Session.getUserType() == UserType.AGENCY.name ? Session.getUuid() : null,
      vendorUuid:  Session.getUserType() == UserType.VENDOR.name ? Session.getUuid() : null,
      clientMasterUuid: clientMasterUuid,
      amount: int.parse(amountController.text)
    );

    String request = addWalletAmountRequestModelToJson(requestModel);

    final result = await walletRepository.addWalletAmountApi(request: request);

    result.when(success: (data) async {
      addWalletAmountState.success = data;
      addWalletAmountState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    addWalletAmountState.isLoading = false;
    notifyListeners();
  }



  var transactionHistoryListState = UIState<WalletAmountListResponseModel>();

  List<WalletListData> walletListData = [];

  int pageNo = 1;
  /// add wallet amount List api
  Future<UIState<WalletAmountListResponseModel>> transactionHistoryListApi(BuildContext context, bool pagination,{
    String? clientMasterUuid,
      }) async {


    if ( transactionHistoryListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if(pageNo == 1 || pagination == false ){
      transactionHistoryListState.isLoading = true;
      walletListData = [];
    }
    else{
  transactionHistoryListState.isLoadMore = true;
  transactionHistoryListState.success = null;

    }
    notifyListeners();


    WalletAmountListRequestModel requestModel = WalletAmountListRequestModel(
        vendorUuid: Session.getUserType() == UserType.VENDOR.name ? Session.getUuid() : null,
        agencyUuid: Session.getUserType() == UserType.AGENCY.name ? Session.getUuid() : null,
        clientMasterUuid: selectedClientInList?.uuid??'',
        transactionType: selectedTransactionType.name==TransactionType.ALL.name? null : selectedTransactionType.name
    );

    String request = walletAmountListRequestModelToJson(requestModel);

    final result = await walletRepository.getWalletHistoryApi(request, pageNo);

    result.when(success: (data) async {
      transactionHistoryListState.success = data;
      walletListData.addAll(transactionHistoryListState.success?.data ?? []);

      transactionHistoryListState.isLoading = false;
      transactionHistoryListState.isLoadMore = false;

    }, failure: (NetworkExceptions error) {
      transactionHistoryListState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context:context,message: errorMsg);
    });
    transactionHistoryListState.isLoading = false;
    transactionHistoryListState.isLoadMore = false;

    filterApplied=true;

    notifyListeners();
    return transactionHistoryListState;
  }


  var vendorDetailState = UIState<VendorDetailResponseModel>();

  /// add wallet amount api
  Future<UIState<VendorDetailResponseModel>> vendorDetailApi(BuildContext context) async {

    vendorDetailState.isLoading = true;
    vendorDetailState.success = null;
    notifyListeners();

    final result = await walletRepository.getVendorDetailApi();

    result.when(success: (data) async {
      vendorDetailState.success = data;
      vendorDetailState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    vendorDetailState.isLoading = false;
    notifyListeners();
    return vendorDetailState;
  }


}
