import 'package:odigo_vendor/framework/provider/network/network.dart';

abstract class RegistrationRepository{

  ///store list Api
  Future storeListApi({required String destinationUuid});

  ///Destination list Api
  Future destinationListApi({required String request, bool? forVendor});

  ///Upload Vendor Document image
  Future uploadVendorDocumentsApi(FormData formData, String uuid);

  ///Upload Odigo Store
  Future uploadOdigoStoreApi({required String request});

  /// Country list
  Future countryList(String request);

  /// State list
  Future stateList(String request);

  /// City list
  Future cityList(String request);

  ///Upload Agency Document image
  Future uploadAgencyDocumentsApi(FormData formData, String uuid);

  ///Agency Registration Api
  Future agencyRegistrationApi(String request);

  ///Get Agency Details Api
  Future getAgencyDetailsApi(String uuid);

  ///Delete Agency Document Api
  Future deleteAgencyDocumentApi({required String request});

  ///Update Agency Name Api
  Future updateAgencyNameAPI(String request);

}
