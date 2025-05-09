abstract class WalletRepository {
    ///add wallet amount Api
    Future addWalletAmountApi({required String request});

    ///get wallet history Api
    Future getWalletHistoryApi(String request, int pageNo);

    ///get Vendor detail
    Future getVendorDetailApi();

}

