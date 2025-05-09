import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/ticket/contract/ticket_repository.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/request/add_ticket_request_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/request/ticket_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/request/ticket_reason_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/create_ticket_response_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_reason_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/ticket_detail_dialog_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';


final ticketManagementController = ChangeNotifierProvider(
      (ref) => getIt<TicketManagementController>(),
);

@injectable
class TicketManagementController extends ChangeNotifier {

  TicketRepository ticketRepository;
  TicketManagementController(this.ticketRepository);

  GlobalKey startDateDialogKey = GlobalKey();
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    ctrComment.clear();
    pageNo = 1;
    // ctrSearch.clear();
    strSelectedStatus = null;
    startDate = null;
    endDate = null;
    startDateMessageShow = false;
    startDateError = null;
    endDateError = null;
    selectedFilterList.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  /// List controller
  ScrollController ticketListScrollController = ScrollController();

  /// Dropdown List for update status
  List<String> updateDropdownList = [
    TicketStatus.PENDING.name.localized,
    TicketStatus.ACKNOWLEDGED.name.localized,
    TicketStatus.RESOLVED.name.localized,
  ];

  /// Dropdown List for Create ticket
  List<String> ticketReasonDropdownList = [
    "Order Management Issue"
  ];

  bool? startDateMessageShow = false;

  ///Form key
  final formKey= GlobalKey<FormState>();

  ///Dialog Key
  final dailog1Key = GlobalKey<ScaffoldState>();
  final dailog2Key = GlobalKey<ScaffoldState>();
  final dailog3Key = GlobalKey<ScaffoldState>();

  final startDateSelectionDialogKey = GlobalKey<ScaffoldState>();
  final endDateSelectionDialogKey = GlobalKey<ScaffoldState>();

  /// call api on search
  Timer? debounce;
  void onSearchChanged(BuildContext context){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      disposeController(isNotify: true);
      ticketListApi(context, false);
    });
    notifyListeners();
  }
  /// Search Ctr
  TextEditingController ctrSearch = TextEditingController();

  /// Message Ctr for Create Ticket
  TextEditingController ctrMessage = TextEditingController();

  /// Comments Ctr for Change Status of Ticket
  TextEditingController ctrComment = TextEditingController();

  ///to Filter Past Orders
  DateTime? startDate;
  DateTime? endDate;
  DateTime? tempDate;

  /// Error Message for Start Date and End Date
  String? startDateError;
  String? endDateError;

  ///clear selected ticket reason
  void clearSelectedTicketReason() {
    selectedReason = null;
    notifyListeners();
  }
  ///clear end date
  void clearEndDate() {
    endDate = null;
    notifyListeners();
  }


  void clearFilters(){
    endDate= null;
    startDate=null;
    selectedFilterList = [];
    resetPagination();

  }
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
    startDate = callbackStartDate;
    endDate = callbackEndDate;
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

  /// Start Date Validation
  void startDateValidation() {
    if (startDate == null) {
      showLog('startDate $startDate');
      startDateError = LocaleKeys.keyStartDateRequired.localized;
    } else {
      if (endDate != null) {
        // if (startDate!.isAtSameMomentAs(endDate!)) {
        //   startDateError = LocaleKeys.keyFromDateAndToDateShouldNotBeSame.localized;
        // } else
        if (!startDate!.isBefore(endDate!)) {
          startDateError = null;
        } else {
          startDateError = null;
        }
      } else {
        startDateError = null;
      }
    }
    notifyListeners();
  }

  /// End Date Validation
  void endDateValidation() {
    endDateError = '';
    if (endDate == null) {
      endDateError = LocaleKeys.keyEndDateRequired.localized;
    } else {
      endDateError = null;
      // if (startDate != null) {
      // if (startDate!.isAtSameMomentAs(endDate!)) {
      //   endDateError = LocaleKeys.keyFromDateAndToDateShouldNotBeSame.localized;
      // }
      // if (!startDate!.isBefore(endDate!)) {
      //   endDateError = LocaleKeys.keyToDateShouldNotBeFromPast.localized;
      // }
      // else {
      //   endDateError = null;
      // }
      // }
      // else {
      //   endDateError = LocaleKeys.keyEndDateRequired.localized;
      // }
    }
    notifyListeners();
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

  ///Any pop up menu opened
  bool isMenuEnable = false;

  updateIsMenuEnable(bool isMenuEnable) {
    this.isMenuEnable = isMenuEnable;
    notifyListeners();
  }

  ///Order status filter list
  List<OrderStatusFilterModel> orderStatusFilterList = [
    OrderStatusFilterModel(name: OrdersStatusEnum.RESOLVED.name, type: OrdersStatusEnum.RESOLVED),
    OrderStatusFilterModel(name: OrdersStatusEnum.ACKNOWLEDGED.name, type: OrdersStatusEnum.ACKNOWLEDGED),
    OrderStatusFilterModel(name: OrdersStatusEnum.PENDING.name, type: OrdersStatusEnum.PENDING)
  ];

  bool getIfFilterIsInList(OrderStatusFilterModel filter) {
    return selectedFilterList.contains(filter.name);
  }

  List<OrderStatusFilterModel> selectedOrderStatusFilterList = [];
  List<String> selectedFilterList = [];

  updateSelectedOrderStatusFilterList(BuildContext context, OrderStatusFilterModel filter) async {
    if (selectedOrderStatusFilterList.contains(filter)) {
      selectedOrderStatusFilterList.remove(filter);
      selectedFilterList.remove(filter.name);
    } else {
      selectedOrderStatusFilterList.add(filter);
      selectedFilterList.add(filter.name);
    }
    //await orderListApi(context);
    notifyListeners();
  }

  void clearAlFilter(){
    pageNo = 1;
    ticketData = [];
    selectedOrderStatusFilterList = [];
    selectedFilterList=[];

    notifyListeners();
  }


  void resetPagination(){
    pageNo = 1;
    ticketData = [];
    ticketListState.success = null;
    notifyListeners();
  }
  /// Stores the value for the selected status
  String? strSelectedStatus;

  ReasonData? selectedReason;

  /// Update the selected status
  void updateStatus(String value)
  {
    strSelectedStatus = value;
    notifyListeners();
  }

  /// Update the selected ticket reason
  void updateSelectedTicketReasonStatus(ReasonData? value) {
    selectedReason = value;
    notifyListeners();
  }

  /// Update Text Controllers
  void updateTextControllers(String? value, String? comment){
    strSelectedStatus=value;
    ctrComment.text = comment??'';
    notifyListeners();
  }

  ///Validate update button
  bool isALLFieldsValid = false;
  validateUpdateForm(int index,{String? comment}){
    isALLFieldsValid=strSelectedStatus !=null && (validateText(comment, "DescriptionIsRequired")==null) ?true:false;
    notifyListeners();
  }

  ///Validate update button for create ticket
  bool isALLFieldsValidForCreateTicket = false;
  validateUpdateFormForCreateTicket(int index,{String? message}){
    isALLFieldsValidForCreateTicket= selectedReason !=null && (validateText(message, "DescriptionIsRequired")==null) ?true:false;
    notifyListeners();
  }

  GlobalKey ticketDetailDialogKey = GlobalKey(debugLabel: 'ticketDetailDialogKey');
  GlobalKey createTicketDialogKey = GlobalKey(debugLabel: 'createTicketDialogKey');

  Future<void> showTicketDetailDialog(BuildContext context, ref, {required String ticketUuid}) async{
    if(ticketDetailDialogKey.currentContext == null){
      await ticketDetailApi(context, ticketUuid: ticketUuid).then((value){
        if(ticketDetailState.success?.status == ApiEndPoints.apiStatus_200){
          /// Ticket Details Widget

          showCommonWebDialog(
              height: 0.85,
              width:0.7,
              keyBadge:ticketDetailDialogKey,
              context: context,
              dialogBody: const TicketDetailDialog()
          );
        }
      });
    }

  }
  
  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */



  var ticketListState = UIState<TicketListResponseModel>();


  int pageNo = 1;
  List<TicketData?> ticketData =[];


  /// ticket List APi
  Future<void> ticketListApi(BuildContext context,bool pagination,{ String? status}) async {
    if ( ticketListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if(pageNo == 1 || pagination == false ){
      resetPagination();
      ticketListState.isLoading = true;
    }
    else{
      ticketListState.isLoadMore = true;
      ticketListState.isLoadMore = true;

    }

    ticketListState.success = null;
    notifyListeners();

    TicketListRequestModel requestModel = TicketListRequestModel(

        fromDate: startDate?.millisecondsSinceEpoch,
        toDate: endDate?.millisecondsSinceEpoch,
        status: selectedFilterList.firstOrNull,
        searchKeyword: ctrSearch.text.trimSpace
    );
    final String request = ticketListRequestModelToJson(requestModel);
    final result = await ticketRepository.ticketList(request: request, pageNumber: pageNo);


    result.when(success: (data) async {
      ticketListState.success = data;
      ticketData.addAll(ticketListState.success?.data ?? []);

      ticketListState.isLoading = false;
      ticketListState.isLoadMore = false;

    }, failure: (NetworkExceptions error) {
      ticketListState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context:context,message: errorMsg);
    });
    ticketListState.isLoading = false;
    ticketListState.isLoadMore = false;

    notifyListeners();
  }


  void clearTicketReasonData(){
    ctrMessage.clear();
    selectedReason = null;
    // ctrComment.clear();
    ticketReasonListState.success = null;
    notifyListeners();
  }

  void clearSearchController(){
    ctrSearch.clear();
    notifyListeners();
  }
  var ticketReasonListState = UIState<TicketReasonListResponseModel>();

  /// ticket reason list
  Future<UIState<TicketReasonListResponseModel>> ticketReasonListApi(BuildContext context) async {
    ticketReasonListState.isLoading = true;
    ticketReasonListState.success = null;
    notifyListeners();

    TicketReasonListRequestModel requestModel = TicketReasonListRequestModel(
      activeRecords: true,
      platformType: Session.getUserType(),
    );
    final String request = ticketReasonListRequestModelToJson(requestModel);

    final result = await ticketRepository.getTicketReasonList(request: request);

    result.when(success: (data) async {
      ticketReasonListState.success = data;
      ticketReasonListState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    ticketReasonListState.isLoading = false;
    notifyListeners();
    return ticketReasonListState;
  }


  var addTicketState = UIState<CreateTicketResponseModel>();

  /// create ticket
  Future<void> createTicketApi(BuildContext context) async {
    addTicketState.isLoading = true;
    addTicketState.success = null;
    notifyListeners();

    CreateTicketRequestModel requestModel = CreateTicketRequestModel(
      ticketReasonUuid: selectedReason?.uuid ?? '',
        description: ctrMessage.text
    );

    String request = createTicketRequestModelToJson(requestModel);

    final result = await ticketRepository.createTicket(request: request);

    result.when(success: (data) async {
      addTicketState.success = data;
      addTicketState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    addTicketState.isLoading = false;
    notifyListeners();
  }


  var ticketDetailState = UIState<TicketDetailResponseModel>();

  /// ticket detail
  Future<UIState<TicketDetailResponseModel>> ticketDetailApi(BuildContext context, {required String ticketUuid}) async {
    ticketDetailState.isLoading = true;
    ticketDetailState.success = null;
    notifyListeners();


    final result = await ticketRepository.ticketDetail(ticketId: ticketUuid);

    result.when(success: (data) async {
      ticketDetailState.success = data;
      ticketDetailState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    ticketDetailState.isLoading = false;
    notifyListeners();
    return ticketDetailState;
  }

}

class OrderTypeFilterModel {
  String name;
  OrderType type;

  OrderTypeFilterModel({required this.name, required this.type});
}

class OrderStatusFilterModel {
  String name;
  OrdersStatusEnum type;

  OrderStatusFilterModel({required this.name, required this.type});
}
