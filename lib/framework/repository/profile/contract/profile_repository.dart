import 'package:dio/dio.dart';

abstract class ProfileRepository{

  ///get profile detail of admin
   Future getProfileDetail();

   ///change password
   Future changePassword(String request);

   /// Update Email / Mobile
   Future updateEmailMobile(String request,bool isEmail);

   /// Check Password
   Future checkPassword(String request);

   ///Send OTP Api
   Future sendOtpApi(String request);

   ///Get Vendor Documents
   Future getVendorDocumentsApi(String uuid);

   ///Get Vendor Documents
   Future getAgencyDocumentsApi(String uuid);

   ///Update  Vendor
   Future updateVendorApi(String request);

   ///Upload Agency Document image
   Future uploadVendorDocumentsApi(FormData formData, String uuid);

   ///Delete Vendor Documents
   Future deleteVendorDocumentApi({required String request});

}