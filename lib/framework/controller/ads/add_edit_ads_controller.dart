import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/ads/contract/ads_repository.dart';
import 'package:odigo_vendor/framework/repository/ads/model/request_model/create_ad_request_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/assigned_store_list_for_destination_response_model.dart';
import 'package:odigo_vendor/framework/repository/ads/model/response_model/create_ad_response_model.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/client_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:video_player/video_player.dart';

final addEditAdsController = ChangeNotifierProvider(
      (ref) => getIt<AddEditAdsController>(),
);

@injectable
class AddEditAdsController extends ChangeNotifier {
final AdsRepository adsRepository;
AddEditAdsController(this.adsRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    selectedMediaType = MediaTypeEnum.image;
    selectedContentLength = ContentLengthEnum.ten;
    selectedAdsFor = AdsForEnum.yourself;
    imageList = [null];
    selectedImageCount = 1;
    videoFileList = [null,null,null];
    thumbnailFileList = [null,null,null];
    imageSizeCount.clear();
    _videoPlayerController?.dispose();
    selectedDestination = null;
    selectedStore=null;
    selectedClient = null;
    createAdState.success = null;
    uploadDocumentState.success = null;
    storeList = [];
    if (isNotify) {
      notifyListeners();
    }
  }

  /// dropdown
  StoreListData? selectedStore;
  DestinationData? selectedDestination;
  ClientData? selectedClient;

  GlobalKey combineWithSignleDialogKey = GlobalKey();
  GlobalKey percentageLoadingDialogKey = GlobalKey();

  /// radio
  MediaTypeEnum selectedMediaType = MediaTypeEnum.image;
  ContentLengthEnum selectedContentLength = ContentLengthEnum.ten;
  AdsForEnum selectedAdsFor = AdsForEnum.yourself;


  List<Uint8List?> imageList = [];
  int maxImageCount = 6;
  List<int> imageSizeCount = [];
  int selectedImageCount = 1;
  XFile? videoFileThumbnailImage;

  VideoPlayerController? _videoPlayerController;
  List<File?> videoFileList = [null,null,null];
  List<File?> thumbnailFileList = [null,null,null];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();
  final List<GlobalKey> fieldKeys = [];

  List<StoreListData?> storeList = [];

  updateStoreList(List<StoreListData?> data){
    storeList = data;
    notifyListeners();
  }

updateStore(StoreListData? value){
    selectedStore = value;
    checkAllFieldValid();
    notifyListeners();
  }

  updateDestination(DestinationData? value){
    selectedDestination = value;
    checkAllFieldValid();
    notifyListeners();
  }

  updateClient(ClientData? value){
    selectedClient = value;
    checkAllFieldValid();
    notifyListeners();
  }

  onRadioUpdateMediaType(MediaTypeEnum value){
    selectedMediaType = value;
    checkAllFieldValid();
    notifyListeners();
  }

  onRadioUpdateContentLengthType(ContentLengthEnum value){
    selectedContentLength = value;
    generateVideoList();
    checkAllFieldValid();
    notifyListeners();
  }

  onRadioUpdateAdsFor(AdsForEnum value){
    selectedAdsFor = value;
    checkAllFieldValid();
    notifyListeners();
  }

  ///  images
  getImageSizeList(){
    for (var i = 1; i <= maxImageCount; i++) {
      var result = 30/i;
      if(result is int){
        imageSizeCount.add(i);
      }
    }
  }

  /// selected image count
  onRadioSelectedImageCount(int count){
    selectedImageCount = count;
    generateImageList();
    checkAllFieldValid();
    notifyListeners();
  }

  /// update image list
  generateImageList(){
    imageList = [];
    imageList = List<Uint8List?>.generate(selectedImageCount,(index) => null);
    notifyListeners();
  }

  /// get image from image picker
  updateImage(int index,Uint8List? photoFile) async {
    imageList[index] = photoFile;
    checkAllFieldValid();
    notifyListeners();
  }

  /// remove image
  Future<void> removeImage(int index) async {
    imageList[index] = null;
    checkAllFieldValid();
    notifyListeners();
  }

  /// video
  initVideoPlayerController(File? file,BuildContext context, int index){
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(file?.path ?? ''));
    _videoPlayerController?.initialize().then((value){

      int? pickVideoDuration = _videoPlayerController?.value.duration.inMilliseconds;
      int validDuration = videoFileList.length == 1 ? 29000 : videoFileList.length == 2 ? 14000 : videoFileList.length == 3 ? 9000 : 0;
      int maxValidDuration = videoFileList.length == 1 ? 30000 : videoFileList.length == 2 ? 15000 : videoFileList.length == 3 ? 10000 : 0;
      showLog("pickVideoDuration $pickVideoDuration validDuration $validDuration");
      showLog("Video size>>>>${_videoPlayerController?.value.size} bool val${_videoPlayerController?.value.size??const Size(0,0) > const Size(1080,1920)}");
      showLog('pickVideoDuration $pickVideoDuration validDuration $validDuration maxDuration $maxValidDuration');
      showLog('Video size>>>>${_videoPlayerController?.value.size} bool val${_videoPlayerController?.value.size??const Size(0,0) > const Size(1080,1920)}');
      bool widthValidation = (_videoPlayerController?.value.size.width??0) <= 1080;
      bool heightValidation = (_videoPlayerController?.value.size.height??0) <= 1920 ;
      if(pickVideoDuration! < validDuration || pickVideoDuration > maxValidDuration ){
        _videoPlayerController = null;
        showCommonErrorDialogNew(context: context, message: "Video required ${maxValidDuration/1000} seconds.");
      }

      else if(!widthValidation || !heightValidation){
        showCommonErrorDialogNew(context: context, message: LocaleKeys.keyVideoSizeValidation.localized);
      }
      else if( pickVideoDuration >= validDuration && pickVideoDuration <= maxValidDuration  && widthValidation && heightValidation){
        updateVideoFile(file, index);
      }
    });
  }

  /// generate video list depends on duration
  generateVideoList(){
    int length = 1;
    switch(selectedContentLength){
      case ContentLengthEnum.ten:
        length = 3;
      case ContentLengthEnum.fifteen:
        length = 2;
      case ContentLengthEnum.thirty:
        length = 1;
    }
    videoFileList = List<File?>.generate(length,(index) => null);
    thumbnailFileList = List<File?>.generate(length,(index) => null);
    notifyListeners();
  }

  updateVideoFile(File? file,int index){
    videoFileList[index] = file;
    generateVideoThumbnailImage(file,index);
    checkAllFieldValid();
    notifyListeners();
  }

  /// generate thumbnail after pick video
  generateVideoThumbnailImage(File? file,int index) async {
    final result = await VideoThumbnail.thumbnailFile(
      video: file!.path,
      imageFormat: ImageFormat.JPEG,
    );
   thumbnailFileList[index] = File(result.path);
    notifyListeners();
  }

  removeVideo(int index){
    thumbnailFileList[index] = null;
    videoFileList[index] = null;
    checkAllFieldValid();
    notifyListeners();
  }

  bool isAllFieldValid = false;
  checkAllFieldValid(){
   bool isVendor = Session.getUserType() == userTypeValue.reverse[UserType.VENDOR];
   bool isValidVendor = selectedStore != null;
   bool isValidAgent =  selectedDestination != null;
   bool isValidClient = selectedClient != null && selectedDestination != null;

   /// get true when all list element not null
   bool isValidVideo = videoFileList.every((element) => element != null);
   bool isValidImage = imageList.every((element) => element != null);

    isAllFieldValid = (
        (isVendor ? isValidVendor : selectedAdsFor == AdsForEnum.yourself? isValidAgent : isValidClient )&&
        (selectedMediaType == MediaTypeEnum.video ? isValidVideo : isValidImage));
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  var destinationWiseStoreListState = UIState<AssignedStoreListForDestinationResponseModel>();
  var createAdState = UIState<CreateAdResponseModel>();

  Future<void> destinationWiseStoreListApi(BuildContext context, String destinationUuid) async {
    destinationWiseStoreListState.isLoading = true;
    destinationWiseStoreListState.success = null;
    notifyListeners();

    final result = await adsRepository.assignedStoreListForDestinationApi(destinationUuid: destinationUuid);

    result.when(success: (data) async {
      destinationWiseStoreListState.success = data;
      destinationWiseStoreListState.isLoading = false;
      notifyListeners();
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);
        });

    destinationWiseStoreListState.isLoading = false;
    notifyListeners();
  }

  /// create ad api
  Future<void> createAdApi(BuildContext context, {String? destinationUuid, String? vendorUuid, String? agencyUuid, String? clientMasterUuid, String? storeUuid}) async {
    createAdState.isLoading = true;
  createAdState.success = null;
  notifyListeners();

  CreateAdRequestModel requestModel = CreateAdRequestModel(
      destinationUuid: destinationUuid,
      vendorUuid: vendorUuid,
      agencyUuid: agencyUuid,
      clientMasterUuid: clientMasterUuid,
      storeUuid: storeUuid,
      adsMediaType: selectedMediaType.name.allInCaps,
      contentLength: selectedContentLength == ContentLengthEnum.ten ? 10 : selectedContentLength == ContentLengthEnum.fifteen ? 15 : 30,
      isDefault: true
  );

  String request = createAdRequestModelToJson(requestModel);

  final result = await adsRepository.createAdApi(request: request);

  result.when(success: (data) async {
    createAdState.success = data;
    createAdState.isLoading = false;
    notifyListeners();
  },
      failure: (NetworkExceptions error) {
        // String errorMsg = NetworkExceptions.getErrorMessage(error);
        // showCommonErrorDialog(context: context, message: errorMsg);
      });

    createAdState.isLoading = false;
    notifyListeners();
}


  /// Add Ads Content
  UIState<CommonResponseModel> uploadDocumentState = UIState<CommonResponseModel>();
  Future<void> addAdContentApi(BuildContext context, {required String adUuid}) async {
    uploadDocumentState.isLoading = true;
    uploadDocumentState.success = null;
    notifyListeners();

    List<MultipartFile>? multipartFileData = [];
    if(selectedMediaType == MediaTypeEnum.image){
      for (Uint8List? image in imageList) {

        if(image!=null){
          MultipartFile documentImage = MultipartFile.fromBytes(image,
              filename: '${DateTime.now().millisecondsSinceEpoch}.jpeg',
              contentType: MediaType('image', 'jpeg'));

          multipartFileData.add(documentImage);
        }
      }
    }else {
      for (File? video in videoFileList) {

        if(video!=null){

          http.Response response = await http.get(Uri.parse(video.path));
          final bytes = response.bodyBytes;

          MultipartFile documentVideo = MultipartFile.fromBytes(bytes,
            filename: '${DateTime.now().millisecondsSinceEpoch}.mp4',
              contentType: MediaType('video', 'mp4')
          );

          multipartFileData.add(documentVideo);
        }
      }
    }
    notifyListeners();


    FormData formData = FormData.fromMap({
      'files': multipartFileData,
    });

    final result = await adsRepository.addAdsContentApi(formData: formData, adUuid: adUuid,
      onSendProgress: (count, total) {
        updateProgress((count / total) * 100);
        if(progress == 100){
          Navigator.pop(percentageLoadingDialogKey.currentContext!);
        }
    }
    ,);
    result.when(success: (data) async {
      uploadDocumentState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    uploadDocumentState.isLoading = false;
    notifyListeners();
  }


  double progress = 0.0;

  updateProgress(double value) {
      progress = value;
      showLog("progress == $progress");
      notifyListeners();
    }
}
