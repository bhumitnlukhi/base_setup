import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/home/contract/home_repository.dart';
import 'package:odigo_vendor/framework/repository/home/model/reponse_model/vendor_dashboard_reponse_model.dart';
import 'package:odigo_vendor/framework/repository/home/model/request/device_registration_request_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_functions.dart';

final dashboardController = ChangeNotifierProvider(
      (ref) => getIt<DashboardController>(),
);

@injectable
class DashboardController extends ChangeNotifier {


  final OverlayPortalController tooltipController = OverlayPortalController();
  final OverlayPortalController tooltipControllerStore = OverlayPortalController();
  final OverlayPortalController tooltipControllerCategory = OverlayPortalController();

  final OverlayPortalController tooltipControllerStoreWeekend = OverlayPortalController();
  final OverlayPortalController tooltipControllerCategoryWeekend = OverlayPortalController();

  final OverlayPortalController tooltipControllerCategoryRobot = OverlayPortalController();


  /// Store the selected year
  int selectedYearIndex = 0 ;

  String? selectedYear = DateTime.now().year.toString();
  String? selectedMonth;
  String? selectedEntity;


  List<double> monthGraphDataListDummy = [
    430, 380, 450, 330, 250, 440, 390,
  ];

  List<String> xTitlesDummy = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  List<double> monthGraphDataListDummyPeakUsage = [
    430, 380, 450, 330,
  ];

  List<double> monthGraphDataList = [10000,2300,4500,0,4400,6700,10000,6600,7708,00,3700,10220];
  List<String> xTitles = ['Jan', 'Feb', 'March', 'April', 'May', 'June', 'July','August','Sept','Oct','Nov','Dec'];


  List<double> monthGraphDataListNavigationRequest = [10000,2300,4500,0,4400,6700,10000,6600,7708,00,3700,10220];
  List<String> xTitlesNavigationRequests = ['Jan', 'Feb', 'March', 'April', 'May', 'June', 'July','August','Sept','Oct','Nov','Dec'];

  List<String> xTitlesDummyPeakUsage = ['10:00-12:00', '12:00-02:00', '02:00-04:00', '04:00-06:00'];

  DestinationData? selectedDestination;

  disposeGraphData(){
    selectedYear = DateTime.now().year.toString();
    selectedEntity = null;
    selectedDestination = null;
    selectedMonth = null;
    notifyListeners();
  }


  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isLoading = false;

    if (isNotify) {
      notifyListeners();
    }
  }

  List<String> yearsDynamicList = [];
  Future<void> getYears() async{
    yearsDynamicList.clear();
    for (int i = 0; i <= numPreviousYears; i++) {
      yearsDynamicList.add((DateTime.now().year - i).toString());
    }
    notifyListeners();
  }

  /// Function to update the year
  Future<void> updateYearIndex(BuildContext context, int index) async {
    selectedYearIndex = index;
    notifyListeners();
  }


  void updateSelectedYear(String selectedYear) {
    this.selectedYear = selectedYear;
    notifyListeners();
  }

  void updateMonthYear(String selectedMonth) {
    this.selectedMonth = selectedMonth;
    notifyListeners();
  }

  void notify(){
    notifyListeners();
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

  HomeRepository homeRepository;
  DashboardController(this.homeRepository);

  var vendorDashboardState = UIState<VendorDashboardResponseModel>();

  /// Login API
  Future<UIState<VendorDashboardResponseModel>>vendorDashboardApi(BuildContext context) async {
    vendorDashboardState.isLoading = true;
    vendorDashboardState.success = null;
    notifyListeners();

    DateTime now = DateTime.now().toUtc();
    DateTime previousDayMidnight = DateTime.utc(now.year, now.month, now.day).subtract(const Duration(days: 1));
    final result = await homeRepository.vendorDashboardApi(getUtcTime(previousDayMidnight));

    result.when(success: (data) async {
      vendorDashboardState.success = data;
      vendorDashboardState.isLoading = false;
    },
        failure: (NetworkExceptions error) {
          vendorDashboardState.isLoading = false;

          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    vendorDashboardState.isLoading = false;
    notifyListeners();
    return vendorDashboardState;
  }

  UIState<CommonResponseModel> registerDeviceState = UIState<CommonResponseModel>();
  /// Register Device FCM token
  Future<void> registerDeviceFcmToken(BuildContext context) async {
    registerDeviceState.isLoading = true;
    registerDeviceState.success = null;
    notifyListeners();
    if(Session.getDeviceID().isEmpty){
      await getDeviceIdPlatformWise();
    }
    DeviceRegistrationRequestModel requestModel;

    requestModel = DeviceRegistrationRequestModel(
      deviceId: Session.getNewFCMToken(),
      deviceType: 'WEB',
      userType: Session.getUserType(),
      uniqueDeviceId:Session.getDeviceID(),
    );

    String request = deviceRegistrationRequestModelToJson(requestModel);

    final result = await homeRepository.registerDeviceApi(request);

    result.when(success: (data) async {
      registerDeviceState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    registerDeviceState.isLoading = false;
    notifyListeners();
  }


  UIState<CommonResponseModel> deleteDeviceIdState = UIState<CommonResponseModel>();
  /// delete Device FCM token
  Future<void> deleteDeviceTokenApi(context) async {
    deleteDeviceIdState.isLoading = true;
    deleteDeviceIdState.success = null;
    notifyListeners();

    final result = await homeRepository.deleteDeviceTokenApi(Session.getDeviceID());

    result.when(success: (data) async {
      deleteDeviceIdState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    deleteDeviceIdState.isLoading = false;
    notifyListeners();
  }
}
