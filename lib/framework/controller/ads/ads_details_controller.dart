import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/ads/contract/ads_repository.dart';
import 'package:odigo_vendor/framework/repository/ads/model/request_model/ad_content_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/ad_content_response_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/ads_detail_response_model.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';


final adsDetailsController = ChangeNotifierProvider(
      (ref) => getIt<AdsDetailsController>(),
);

@injectable
class AdsDetailsController extends ChangeNotifier {
final AdsRepository adsRepository;
AdsDetailsController(this.adsRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    contentList = [];
    adDetailState.success = null;
    adContentState.success = null;
    adContentState.isLoading = true;
    if (isNotify) {
      notifyListeners();
    }
  }
  ScrollController contentScroll = ScrollController();

  GlobalKey totalAdsDialogKey = GlobalKey();
  updateUi(){
    notifyListeners();
  }
  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */




  var adDetailState = UIState<AdsDetailResponseModel>();

  Future<void> adDetailApi(BuildContext context, {required String adUuid}) async {
    adDetailState.isLoading = true;
    adDetailState.success = null;
    notifyListeners();

    final result = await adsRepository.adsDetailApi(adUuid: adUuid);

    result.when(success: (data) async {
      adDetailState.success = data;
      adDetailState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    adDetailState.isLoading = false;
    notifyListeners();
  }


  var adContentState = UIState<AdContentResponseModel>();


  int pageNo = 1;
  List<AdsContentData?> contentList =[];


  /// ad content APi
  Future<void> adContentApi(BuildContext context,bool pagination, {required String adUuid}) async {
    if ( adContentState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if(pageNo == 1 || pagination == false ){
      adContentState.isLoading = true;
      contentList = [];
    }
    else{
      adContentState.isLoadMore = true;
      adContentState.isLoadMore = true;

    }

    adContentState.success = null;
    notifyListeners();


    AdContentListRequestModel requestModel = AdContentListRequestModel(
      activeRecords: true,
      adsUuid: adUuid
    );


    String request = adContentListRequestModelToJson(requestModel);

    final result = await adsRepository.getAdsContentApi(request: request,pageNo:  1);

    result.when(success: (data) async {
      adContentState.success = data;
      contentList.addAll(adContentState.success?.data??[]);

      if((contentList).isNotEmpty){
        for(var i = 0 ; i< (contentList).length ; i++){
          if(imageExt.contains(contentList[i]?.originalAdsFile?.split('.').last)){
            try {
              XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
                video: contentList[i]?.adsFileUrl ?? '',
                // thumbnailPath: (await getTemporaryDirectory()).path,
                imageFormat: ImageFormat.JPEG,
                // maxHeight: 64,
                // quality: 100,
              );
              showLog("DATA RESULT  ${thumbnailFile.path}");
              contentList[i]?.thumbnailFile = thumbnailFile.path;
              notifyListeners();
            } on Exception catch (e) {
              showLog("INSIDE Catch$e");
              // TODO
            }
          }
        }

      }
      adContentState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    adContentState.isLoading = false;
    notifyListeners();

  }
}
