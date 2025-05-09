import 'package:odigo_vendor/framework/provider/network/network.dart';

abstract class AdsRepository {
    ///create ad
    Future createAdApi({required String request});
    Future addAdsContentApi({required FormData formData,required  String adUuid,ProgressCallback? onSendProgress});
    Future getAdsContentApi({required String request,required  int pageNo});
    Future adsDetailApi({required String adUuid});
    Future changeStatusOfDefaultAd({required String adUuid});
    Future changeStatusOfAd({required String adUuid, required String status});
    Future archiveAd({required String adUuid});
    Future adListApi({required String request, required int pageNo});
    Future assignedStoreListForDestinationApi({required String destinationUuid});


}

