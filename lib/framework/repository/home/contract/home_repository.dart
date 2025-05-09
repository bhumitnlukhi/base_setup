abstract class HomeRepository{

  ///Vendor Dashboard Api
  Future vendorDashboardApi(int request);

  /// Register device api
  Future registerDeviceApi(String request);

  ///delete device FCM token
  Future deleteDeviceTokenApi(String deviceId);

}