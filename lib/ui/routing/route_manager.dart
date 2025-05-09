import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/delegate.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_keys.dart';

class RouteManager {
  ///Singleton Class for [RouteManger]
  RouteManager._();

  ///Instance [route] to call methods for [RouteManager]
  static RouteManager route = RouteManager._();

  ///Path Segments to display a path after removing empty paths
  List<String> pathSegments = [];

  ///To remove any empty path after [/] in Path Segments
  void removeEmptyPath(List<String> segments) {
    pathSegments = segments.toList();
    pathSegments.removeWhere((element) => element.trim().isEmpty);
  }

  ///To check if the current route is valid
  Future<RouteValidator> checkPathValidation() {
    ///If mobile then always return true
    if (globalNavigatorKey.currentContext?.isMobileScreen ?? false) {
      return Future.value(RouteValidator(isAuthenticated: true, isRouteValid: true));
    }

    ///If empty then always return true
    if (pathSegments.isEmpty) {
      return Future.value(RouteValidator(isAuthenticated: true, isRouteValid: true));
    }

    ///Create a path without any parameters
    String path = pathSegments.join('/');

    ///Will check authentication
    bool isAuthenticated = Session.getUserAccessToken().isNotEmpty;

    ///Will check validation and return accordingly
    switch (pathSegments.last) {
      /// Splash
      case Keys.splash:
        String validationPath = Keys.splash;
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.startJourney:
        String validationPath = Keys.startJourney;
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Dashboard
      case Keys.dashBoard:
        String validationPath = Keys.dashBoard;
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Notification
      case Keys.notification:
        String validationPath = "${Keys.dashBoard}/${Keys.notification}";
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.login:
        String validationPath = "${Keys.startJourney}/${Keys.login}";
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.otpVerification:
        String validationPath = Keys.otpVerification;
        String validationPath2 = "${Keys.startJourney}/${Keys.login}/${Keys.forgotPassword}/${Keys.otpVerification}";
        String validationPath3 = "${Keys.startJourney}/${Keys.login}/${Keys.forgotPassword}";
        bool isRouteValid = path == validationPath || path == validationPath2 || path == validationPath3;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.vendorRegistrationForm:
        String validationPath = Keys.vendorRegistrationForm;
        String validationPath2 = "${Keys.startJourney}/${Keys.login}/${Keys.vendorRegistrationForm}";
        String validationPath3 = "${Keys.login}/${Keys.vendorRegistrationForm}";
        bool isRouteValid = path == validationPath || path == validationPath2 || path == validationPath3;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.agencyRegistrationForm:
        String validationPath = Keys.vendorRegistrationForm;
        String validationPath2 = "${Keys.startJourney}/${Keys.login}/${Keys.agencyRegistrationForm}";
        String validationPath3 = "${Keys.login}/${Keys.agencyRegistrationForm}";
        bool isRouteValid = path == validationPath || path == validationPath2 || path == validationPath3;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.resetPassword:
        String validationPath = Keys.resetPassword;
        String validationPath2 = "${Keys.startJourney}/${Keys.login}/${Keys.forgotPassword}/${Keys.resetPassword}";
        String validationPath3 = "${Keys.startJourney}/${Keys.login}/${Keys.resetPassword}";
        bool isRouteValid = path == validationPath || path == validationPath2 || path == validationPath3;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.forgotPassword:
        String validationPath = Keys.forgotPassword;
        String validationPath2 = "${Keys.startJourney}/${Keys.login}/${Keys.forgotPassword}";
        String validationPath3 = "${Keys.login}/${Keys.forgotPassword}";
        bool isRouteValid = path == validationPath || path == validationPath2 || path==validationPath3;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Purchase add
      case Keys.purchaseAdd:
        String validationPath = Keys.purchaseAdd;
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Select detination
      case Keys.selectDestination:
        String validationPath = '${Keys.purchaseAdd}/${Keys.selectDestination}';
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Payment Success
      case Keys.paymentSuccess:
        String validationPath = '${Keys.wallet}/${Keys.paymentSuccess}';
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Payment Cancel
      case Keys.paymentCancel:
        String validationPath = '${Keys.wallet}/${Keys.paymentCancel}';
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.paymentFailed:
        String validationPath = '${Keys.wallet}/${Keys.paymentFailed}';
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Selct store
      case Keys.selectStore:
        String validationPath = '${Keys.purchaseAdd}/${Keys.selectDestination}/${Keys.selectStore}';
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Select client
      case Keys.selectClient:
        String validationPath = '${Keys.purchaseAdd}/${Keys.selectDestination}/${Keys.selectClient}';
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// client list for ads
      case Keys.clientAdList:
        String validationPath = '${Keys.ads}/${Keys.clientAdList}';
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// All locations
      case Keys.allLocations:
        String validationPath = '${Keys.purchaseAdd}/${Keys.selectDestination}/${Keys.allLocations}';
        String validationPath1 = '${Keys.purchaseAdd}/${Keys.selectDestination}/${Keys.selectClient}/${Keys.allLocations}';
        String validationPath2 = '${Keys.purchaseAdd}/${Keys.selectDestination}/${Keys.selectStore}/${Keys.allLocations}';
        bool isRouteValid = (path == validationPath || path == validationPath2 || path == validationPath1);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Billing
      case Keys.billing:
        String validationPath = '${Keys.purchaseAdd}/${Keys.allLocations}/${Keys.billing}';
        String validationPath1 = '${Keys.purchaseAdd}/${Keys.selectDestination}/${Keys.selectClient}/${Keys.allLocations}/${Keys.billing}';
        String validationPath2 = '${Keys.purchaseAdd}/${Keys.selectDestination}/${Keys.selectStore}/${Keys.allLocations}/${Keys.billing}';
        String validationPath3 = '${Keys.purchaseAdd}/${Keys.selectDestination}/${Keys.allLocations}/${Keys.billing}';
        bool isRouteValid = (path == validationPath || path == validationPath2 || path == validationPath1 || path == validationPath3);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Wallet
      case Keys.wallet:
        String validationPath = Keys.wallet;
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.profile:
        String validationPath = '${Keys.dashBoard}/${Keys.profile}';
        String validationPath2 = Keys.profile;
        bool isRouteValid = (path == validationPath || path == validationPath2);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// store
      case Keys.stores:
        String validationPath = Keys.stores;
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// add stores
      case Keys.addStore:
        String validationPath = '${Keys.stores}/${Keys.addStore}';
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// add stores
      case Keys.editStore:
        String validationPath = '${Keys.stores}/${Keys.editStore}';
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// clients
      case Keys.clients:
        String validationPath = Keys.clients;
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// add clients
      case Keys.addClients:
        String validationPath = '${Keys.clients}/${Keys.addClients}';
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));
      case Keys.editClients:
        String validationPath = '${Keys.clients}/${Keys.editClients}';
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// ads
      case Keys.ads:
        String validationPath = Keys.ads;
        bool isRouteValid = (path == validationPath);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// ads details
      case Keys.adsDetails:
        String validationPath = Keys.adsDetails;
        String validationPath2 = "${Keys.ads}/${Keys.adsDetails}";
        String validationPath3 = "${Keys.ads}/${Keys.vendorAdList}/${Keys.adsDetails}";
        bool isRouteValid = (path == validationPath || path == validationPath2 || path == validationPath3);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// ads details
      case Keys.packageWalletDetail:
        String validationPath = Keys.packageWalletDetail;
        String validationPath2 = "${Keys.purchaseAdd}/${Keys.packageWalletDetail}";
        bool isRouteValid = (path == validationPath || path == validationPath2);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// vendor ad list details
      case Keys.vendorAdList:
        String validationPath = Keys.vendorAdList;
        String validationPath2 = "${Keys.ads}/${Keys.vendorAdList}";
        bool isRouteValid = (path == validationPath || path == validationPath2);
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// add ads
      case Keys.addAds:
        String validationPath = '${Keys.ads}/${Keys.addAds}';
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// add ads
      case Keys.ticketManagement:
        String validationPath = Keys.ticketManagement;
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.editVendor:
        String validationPath = '${Keys.dashBoard}/${Keys.profile}/${Keys.editVendor}';
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      case Keys.editAgency:
        String validationPath = '${Keys.dashBoard}/${Keys.profile}/${Keys.editAgency}';
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      /// Dashboard
      case Keys.faq:
        String validationPath = Keys.faq;
        bool isRouteValid = path == validationPath;
        return Future.value(RouteValidator(isAuthenticated: isAuthenticated, isRouteValid: isRouteValid));

      default:
        return Future.value(RouteValidator(isAuthenticated: false, isRouteValid: false));
    }
  }
}

class RouteValidator {
  bool isRouteValid;
  bool isAuthenticated;

  RouteValidator({
    this.isRouteValid = false,
    this.isAuthenticated = false,
  });
}
