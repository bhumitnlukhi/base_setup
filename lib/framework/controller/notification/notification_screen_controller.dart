import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/notification/contract/notification_repository.dart';
import 'package:odigo_vendor/framework/repository/notification/model/notification_filter_model.dart';
import 'package:odigo_vendor/framework/repository/notification/model/request/notification_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/notification/model/request/notification_unread_count_request_model.dart';
import 'package:odigo_vendor/framework/repository/notification/model/response/notification_list_reponse_model.dart';
import 'package:odigo_vendor/framework/repository/notification/model/response/notification_unread_count_reponse_model.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';

final notificationScreenController = ChangeNotifierProvider(
      (ref) => getIt<NotificationScreenController>(),
);

@injectable
class NotificationScreenController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    notificationListState.success = null;
    for (var element in notificationFilterList) {
      element.notificationDayData?.clear();
    }
    if (isNotify) {
      notifyListeners();
    }
  }

  /// Scroll controller
  ScrollController notificationListController = ScrollController();

  /// list for paginatipon
  List<NotificationData> notificationList = [];


  /// Day wise filter list
  List<NotificationFilterModel> notificationFilterList = [
    NotificationFilterModel(notificationDay: LocaleKeys.keyToday, notificationDayData: []),
    NotificationFilterModel(
        notificationDay: LocaleKeys.keyYesterday, notificationDayData: []),
    NotificationFilterModel(notificationDay: LocaleKeys.keyOlder, notificationDayData: [])
  ];

  /// Check list is empty or not
  bool isNotificationListEmpty() {
    var isNotificationListEmpty = false;
    for (var element in notificationFilterList) {
      isNotificationListEmpty = element.notificationDayData?.isNotEmpty ?? false;
      if(isNotificationListEmpty){
        return false;
      }
    }
    return true;
  }

  /// To check whether list count is less so that we can call list api after any one notiifcation is deleted
  bool getNotificationListState(){
    int maxCount = 0;
    for (var element in notificationFilterList) {
      if(maxCount<(element.notificationDayData?.length??0)){
        maxCount = element.notificationDayData?.length??0;
      }
    }
    return maxCount<=3;
  }


  /// Set notification redirection
  setNotificationRedirection(WidgetRef ref,{bool? isFromHome,String? moduleName,String? uuid,String? entityType, String? entityUuid, String? subEntityUuid ,String? subEntityType}){
    if(moduleName == 'Store'){
      ref.read(navigationStackController).pushAndRemoveAll(NavigationStackItem.stores(storeUuid: entityUuid));
    }else if(moduleName == 'Package'){
      if(entityType == "VENDOR"){
        ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.package());
      }else{
        ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.package(tabIndex: 0));
      }
    }
    else if(moduleName == 'ADS'){
      if(entityType == "VENDOR"){
        ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.ads());
        ref.read(navigationStackController).push(NavigationStackItem.adsDetails(adUuid:uuid??'' ));
      }else if(entityType == "AGENCY"){
        if((entityUuid?.isNotEmpty??false) && (subEntityUuid?.isNotEmpty??false) && (subEntityType == 'CLIENT')){
          ref.read(navigationStackController).pushAndRemoveAll(const  NavigationStackItem.ads(tabIndex: 1));
          ref.read(navigationStackController).push(NavigationStackItem.adsDetails(adUuid:uuid??'' ));
        }else if((entityUuid?.isNotEmpty??false)){
          ref.read(navigationStackController).pushAndRemoveAll(const  NavigationStackItem.ads(tabIndex: 0));
          ref.read(navigationStackController).push(NavigationStackItem.adsDetails(adUuid:uuid??'' ));
        }else{
          if(isFromHome??false){
            ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
            ref.read(navigationStackController).push(const NavigationStackItem.notification());
          }

        }
      }
    }else if(moduleName == 'Ticket'){
      ref.read(navigationStackController).pushAndRemoveAll( NavigationStackItem.ticketManagement(ticketUuid:uuid ));
    }else{
      if(isFromHome??false){
        ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
        ref.read(navigationStackController).push(const NavigationStackItem.notification());
      }

    }

  }
 //-----------------------------------Api intergartion----------------------------//

  NotificationRepository notificationRepository;

  NotificationScreenController(this.notificationRepository);

  var notificationListState = UIState<NotificationListResponseModel>();
  var notificationUnReadCountState = UIState<NotificationUnReadCountResponseModel>();
  var deleteNotificationListState = UIState<CommonResponseModel>();
  var deleteNotificationState = UIState<CommonResponseModel>();
  var readAllNotificationState = UIState<CommonResponseModel>();

  int pageNoNotificationList = 1;

  void increasePageNumber() {
    pageNoNotificationList += 1;
    notifyListeners();
  }

  void resetPagination() {
    pageNoNotificationList = 1;
    notificationListState.success = null;
    for (var element in notificationFilterList) {
      element.notificationDayData?.clear();
    }
    notifyListeners();
  }

  /// Notification List API
  Future<void> notificationListAPI(BuildContext context,
      {bool showLoading = true,int? initPageSize}) async {
    if(!showLoading){
      increasePageNumber();
      notificationListState.isLoading = false;
      notificationListState.success = null;
    }else{
      if ((pageNoNotificationList != 1) && (notificationListState.success?.hasNextPage ?? false)) {
        notificationListState.isLoadMore = true;
      } else {
        pageNoNotificationList = 1;
        notificationList.clear();
        if (showLoading) {
          notificationListState.isLoading = true;
        }
        notificationListState.success = null;
        for (var element in notificationFilterList) {
          element.notificationDayData?.clear();
        }
      }
    }


    notifyListeners();

    NotificationListRequestModel requestModel = NotificationListRequestModel(
        fromDate: null,
        toDate: null,
        currentDate: null
    );

    final result = await notificationRepository
        .notificationListAPI(notificationListRequestModelToJson(requestModel),pageNoNotificationList,initPageSize??pageCount);

    result.when(success: (data) async {
      notificationListState.success = data;

      if (notificationListState.success?.data?.isNotEmpty ?? false) {
        notificationListState.success?.data?.forEach((element) {
          String formattedDate = dateConverter(formatDatetime(
              createdAt: element.createdAt ?? 0,
              dateFormat: 'dd MMM yyyy, hh:mm:ss'));
          var matchingFilter = notificationFilterList.where((filter) => filter.notificationDay == formattedDate);
          if (matchingFilter != null) {
            matchingFilter.first.notificationDayData?.add(element);
          }
        });
        // notificationFilterList[0].notificationDayData?.add(NotificationData(message: "mamshjhdskhds"));
        // notificationFilterList[0].notificationDayData?.add(NotificationData(message: "hafiza"));
        notificationList.addAll(notificationListState.success?.data ?? []);
      }
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    notificationListState.isLoading = false;
    notificationListState.isLoadMore = false;
    notifyListeners();
  }

  /// Notification unread count
  Future<void> notificationUnReadCountAPI(BuildContext context) async {
    notificationUnReadCountState.isLoading = true;
    notificationUnReadCountState.success = null;
    notifyListeners();

    NotificationUnReadCountRequestModel requestModel = NotificationUnReadCountRequestModel(
      isRead:false,
    );
    final result = await notificationRepository.notificationUnreadCountAPI(notificationUnReadCountRequestModelToJson(requestModel));

    result.when(success: (data) async {
      notificationUnReadCountState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    notificationUnReadCountState.isLoading = false;
    notifyListeners();
  }

  /// Delete all Notification
  Future<void> deleteNotificationListAPI(BuildContext context) async {
    deleteNotificationListState.isLoading = true;
    deleteNotificationListState.success = null;
    notifyListeners();

    final result = await notificationRepository.deleteNotificationList();

    result.when(success: (data) async {
      deleteNotificationListState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    deleteNotificationListState.isLoading = false;
    notifyListeners();
  }

  /// Delete one  Notification
  Future<void> deleteNotificationAPI(
      BuildContext context, String notificationId) async {
    deleteNotificationState.isLoading = true;
    deleteNotificationState.success = null;
    notifyListeners();

    final result =
    await notificationRepository.deleteNotification(notificationId);

    result.when(success: (data) async {
      deleteNotificationState.success = data;
      if (deleteNotificationState.success?.status == ApiEndPoints.apiStatus_200) {
        notificationFilterList
            .where((element) => element.notificationDay == LocaleKeys.keyToday)
            .first
            .notificationDayData
            ?.removeWhere((element) => element.uuid == notificationId);
        notificationFilterList
            .where((element) => element.notificationDay == LocaleKeys.keyYesterday)
            .first
            .notificationDayData
            ?.removeWhere((element) => element.uuid == notificationId);
        notificationFilterList
            .where((element) => element.notificationDay == LocaleKeys.keyOlder)
            .first
            .notificationDayData
            ?.removeWhere((element) => element.uuid == notificationId);
      }
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    deleteNotificationState.isLoading = false;
    notifyListeners();
  }

  /// Read all notification
  Future<void> readAllNotificationAPI(BuildContext context) async {
    readAllNotificationState.isLoading = true;
    readAllNotificationState.success = null;
    notifyListeners();

    final result = await notificationRepository.readAllNotification();

    result.when(success: (data) async {
      readAllNotificationState.success = data;
      if(readAllNotificationState.success?.status == ApiEndPoints.apiStatus_200){
        notificationUnReadCountState.success?.data =0;
      }
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    readAllNotificationState.isLoading = false;
    notifyListeners();
  }
  String dateConverter(String myDate) {
    String date;
    DateTime convertedDate =
    DateFormat('dd MMM yyyy, hh:mm:ss').parse(myDate.toString());
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    // final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCheck = convertedDate;
    final checkDate =
    DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if (checkDate == today) {
      date = LocaleKeys.keyToday;
    } else if (checkDate == yesterday) {
      date = LocaleKeys.keyYesterday;
    } else {
      date = LocaleKeys.keyOlder;
    }

    return date;
  }
}


// class NotificationModel {
//   final String header;
//   final List<NotificationHeaderModel> headerModel;
//
//   NotificationModel({required this.header, required this.headerModel});
// }
//
// class NotificationHeaderModel {
//   final String title;
//   final String id;
//
//   final String value;
//
//   NotificationHeaderModel({required this.title, required this.id,required this.value});
// }
