abstract class PackageRepository {

  ///package list
  Future packageListApi({required String request, required int pageNumber});

  ///purchase package
  Future purchasePackageApi({required String request});

  ///destination list
  Future destinationListApi({required String request, required int pageNumber, bool? forVendor, int? dataSize});

  ///destination detail
  Future destinationDetailApi({required String destinationUuid});

  ///client list
  Future clientListApi({required String request, required int pageNumber});

  ///client status update api
  Future clientStatusUpdateApi(String request, String clientId, bool status );

  ///get package wallet history Api
  Future packageWalletHistoryApi({required String request,required  String packageUuid, required  int pageNo});

  ///get package Limit Api
  Future packageLimitApi({required String request});

}