import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/auth/contract/auth_repository.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/home/model/home_menu_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

final drawerController = ChangeNotifierProvider((ref) => getIt<DrawerController>());

@injectable
class DrawerController extends ChangeNotifier {
  AuthRepository authRepository;

  DrawerController(this.authRepository);

  disposeController() {
    ///for update drawer dynamically
    drawerMenuList = [
      DrawerMenuModel(menuName: LocaleKeys.keyDashboard, strIcon: Assets.svgs.svgDashboard.keyName, isExpanded: false, screenName: ScreenName.dashboard, parentScreen: ScreenName.dashboard, screen: Container(), item: const NavigationStackItem.dashBoard()),
      DrawerMenuModel(menuName: LocaleKeys.keyWallet, strIcon: Assets.svgs.svgWallet.keyName, isExpanded: false, screenName: ScreenName.wallet, parentScreen: ScreenName.wallet, screen: Container(), item: const NavigationStackItem.wallet()),
      DrawerMenuModel(menuName: Session.getUserType() == UserType.VENDOR.name ? LocaleKeys.keyStores : LocaleKeys.keyClients, strIcon: Assets.svgs.svgStores.keyName, isExpanded: false, screenName: ScreenName.stores, parentScreen: ScreenName.stores, screen: Container(), item: Session.getUserType() == UserType.VENDOR.name ? const NavigationStackItem.stores() : const NavigationStackItem.clients()),
      DrawerMenuModel(menuName: LocaleKeys.keyPackage, strIcon: Assets.svgs.svgAds.keyName, isExpanded: false, screenName: ScreenName.purchaseAds, parentScreen: ScreenName.purchaseAds, screen: Container(), item: Session.getUserType() == UserType.VENDOR.name ? const NavigationStackItem.package() : const NavigationStackItem.package(tabIndex: 0)),
      DrawerMenuModel(menuName: LocaleKeys.keyAds, strIcon: Assets.svgs.svgPurchaseAds.keyName, isExpanded: false, screenName: ScreenName.ads, parentScreen: ScreenName.ads, screen: Container(), item: Session.getUserType() == UserType.VENDOR.name ? const NavigationStackItem.ads() : const NavigationStackItem.ads(tabIndex: 0)),
      DrawerMenuModel(menuName: LocaleKeys.keyTicket, strIcon: Assets.svgs.svgTicket.keyName, isExpanded: false, screenName: ScreenName.ticket, parentScreen: ScreenName.ticket, screen: Container(), item: const NavigationStackItem.ticketManagement()),
      DrawerMenuModel(menuName: LocaleKeys.keyFaq, strIcon: Assets.svgs.svgFaq.keyName, isExpanded: false, screenName: ScreenName.faq, parentScreen: ScreenName.faq, screen: Container(), item: const NavigationStackItem.faq()),
    ];
    notifyListeners();
  }

  ///Update Selected Screen
  updateSelectedScreen(ScreenName screenName, {bool? fromHome, bool? isNotify}) {
    if (fromHome ?? false) {
    } else {
      selectedScreen = drawerMenuList.firstWhere((element) => element.screenName == screenName);
    }
    if (isNotify ?? true) {
      notifyListeners();
    }
  }

  ///Selected Screen
  DrawerMenuModel? selectedScreen;

  /// drawer menu list
  List<DrawerMenuModel> drawerMenuList = [
    DrawerMenuModel(menuName: LocaleKeys.keyDashboard, strIcon: Assets.svgs.svgDashboard.keyName, isExpanded: false, screenName: ScreenName.dashboard, parentScreen: ScreenName.dashboard, screen: Container(), item: const NavigationStackItem.dashBoard()),
    DrawerMenuModel(menuName: LocaleKeys.keyWallet, strIcon: Assets.svgs.svgWallet.keyName, isExpanded: false, screenName: ScreenName.wallet, parentScreen: ScreenName.wallet, screen: Container(), item: const NavigationStackItem.wallet()),

    DrawerMenuModel(menuName: Session.getUserType() == UserType.VENDOR.name ? LocaleKeys.keyStores : LocaleKeys.keyClients, strIcon: Assets.svgs.svgStores.keyName, isExpanded: false, screenName: ScreenName.stores, parentScreen: ScreenName.stores, screen: Container(), item: Session.getUserType() == UserType.VENDOR.name ? const NavigationStackItem.stores() : const NavigationStackItem.clients()),

    DrawerMenuModel(menuName: LocaleKeys.keyPackage, strIcon: Assets.svgs.svgAds.keyName, isExpanded: false, screenName: ScreenName.purchaseAds, parentScreen: ScreenName.purchaseAds, screen: Container(), item: Session.getUserType() == UserType.VENDOR.name ? const NavigationStackItem.package() : const NavigationStackItem.package(tabIndex: 0)),
    DrawerMenuModel(menuName: LocaleKeys.keyAds, strIcon: Assets.svgs.svgPurchaseAds.keyName, isExpanded: false, screenName: ScreenName.ads, parentScreen: ScreenName.ads, screen: Container(), item: Session.getUserType() == UserType.VENDOR.name ? const NavigationStackItem.ads() : const NavigationStackItem.ads(tabIndex: 0)),

    DrawerMenuModel(menuName: LocaleKeys.keyTicket, strIcon: Assets.svgs.svgTicket.keyName, isExpanded: false, screenName: ScreenName.ticket, parentScreen: ScreenName.ticket, screen: Container(), item: const NavigationStackItem.ticketManagement()),
    DrawerMenuModel(menuName: LocaleKeys.keyFaq, strIcon: Assets.svgs.svgFaq.keyName, isExpanded: false, screenName: ScreenName.faq, parentScreen: ScreenName.faq, screen: Container(), item: const NavigationStackItem.faq()),
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyOrder.localized,
    //     strIcon: AppAssets.svgOrder,
    //     isExpanded: false,
    //     screenName: ScreenName.order,
    //     parentScreen: ScreenName.order,
    //     screen: const OrderHome(),
    //     item: const NavigationStackItem.orderHome()
    // ),
    // HomeMenuOperator(
    //   menuName: LocalizationStrings.keyMyOrder.localized,
    //   strIcon: AppAssets.svgMyOrderSelected,
    //   isExpanded: false,
    //   screenName: ScreenName.myOrder,
    //   parentScreen: ScreenName.myOrder,
    //   screen: const MyOrder(orderType: OrderType.order,),
    //   item: const NavigationStackItem.myOrder(type: OrderType.order),
    // ),
    // /// Do not remove this commented code
    // // HomeMenuOperator(
    // //     menuName: LocalizationStrings.keyServices.localized,
    // //     strIcon: AppAssets.svgServices,
    // //     isExpanded: false,
    // //     screenName: ScreenName.service,
    // //     parentScreen: ScreenName.service,
    // //     screen: const Services(),
    // //     item: const NavigationStackItem.services()
    // // ),
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyOrderHistory.localized,
    //     strIcon: AppAssets.svgOrderHistory,
    //     isExpanded: false,
    //     screenName: ScreenName.orderHistory,
    //     parentScreen: ScreenName.orderHistory,
    //     screen: Container(),
    //     item: const NavigationStackItem.orderHistory()
    // ),
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyUserManagement.localized,
    //     strIcon: AppAssets.svgUserManagement,
    //     isExpanded: false,
    //     screenName: ScreenName.userManagement,
    //     parentScreen: ScreenName.userManagement,
    //     screen: Container(),
    //     item: const NavigationStackItem.userManagement()
    // ),
    // /// Do not remove this commented code
    // // HomeMenuOperator(
    // //     menuName: LocalizationStrings.keyServiceHistory.localized,
    // //     strIcon: AppAssets.svgServiceHistory,
    // //     isExpanded: false,
    // //     screenName: ScreenName.serviceHistory,
    // //     parentScreen: ScreenName.serviceHistory,
    // //     screen: const ServiceHistory(),
    // //     item: const NavigationStackItem.serviceHistory()
    // // ),
    // // HomeMenuOperator(
    // //     menuName: LocalizationStrings.keyServiceManagement.localized,
    // //     strIcon: AppAssets.svgServiceManagement,
    // //     isExpanded: false,
    // //     screenName: ScreenName.serviceManagement,
    // //     parentScreen: ScreenName.serviceManagement,
    // //     screen: Container(),
    // //     item: const NavigationStackItem.serviceManagement()
    // // ),
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyProductManagement.localized,
    //     strIcon: AppAssets.svgProductManagement,
    //     isExpanded: false,
    //     screenName: ScreenName.productManagement,
    //     parentScreen: ScreenName.productManagement,
    //     screen: const ProductManagement(),
    //     item: const NavigationStackItem.productManagement()
    // ),
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyMaster.localized,
    //     strIcon: AppAssets.svgMaster,
    //     isExpanded: false,
    //     screenName: ScreenName.master,
    //     parentScreen: ScreenName.master,
    //     screen: Container(),
    //     item: const NavigationStackItem.master()
    // ),
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyCMSManagement.localized,
    //     strIcon: AppAssets.svgCmsManagement,
    //     isExpanded: false,
    //     screenName: ScreenName.cmsManagement,
    //     parentScreen: ScreenName.cmsManagement,
    //     screen: Container(),
    //     item: const NavigationStackItem.cms()
    // ),
    // /// Do not remove this commented code
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyRolePermission.localized,
    //     strIcon: AppAssets.svgRolePermission,
    //     isExpanded: false,
    //     screenName: ScreenName.rolesPermission,
    //     parentScreen: ScreenName.rolesPermission,
    //     screen: const RolesAndPermissions(),
    //     item: const NavigationStackItem.rolesAndPermissions()
    // ),
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyTicketManagement.localized,
    //     strIcon: AppAssets.svgTicketManagement,
    //     isExpanded: false,
    //     screenName: ScreenName.ticketManagement,
    //     parentScreen: ScreenName.ticketManagement,
    //     screen: const TicketManagement(),
    //     item: const NavigationStackItem.ticketManagement()
    // ),
    // HomeMenuOperator(
    //     menuName: LocalizationStrings.keyCompany.localized,
    //     strIcon: AppAssets.svgCompany,
    //     isExpanded: false,
    //     screenName: ScreenName.company,
    //     parentScreen: ScreenName.company,
    //     screen: const Company(),
    //     item: const NavigationStackItem.company()
    // ),
  ];

  void expandingList(int index) {
    drawerMenuList[index].isExpanded = !drawerMenuList[index].isExpanded;
    notifyListeners();
  }

  bool isExpanded = true;

  ///hide Tray Button
  void hideSideMenu() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  UIState<CommonResponseModel> logoutAPIState = UIState<CommonResponseModel>();

  /// Logout API
  Future<void> logoutApi(context) async {
    logoutAPIState.isLoading = true;
    logoutAPIState.success = null;
    notifyListeners();

    final result = await authRepository.logoutApi(Session.getDeviceID());

    result.when(success: (data) async {
      logoutAPIState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    logoutAPIState.isLoading = false;
    notifyListeners();
  }
}
