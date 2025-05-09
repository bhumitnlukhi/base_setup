import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/contract/registration_repository.dart';
import 'package:odigo_vendor/framework/repository/registration/model/destination_store_list.dart';
import 'package:odigo_vendor/framework/repository/registration/model/request_model/destination_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/request_model/upload_odigo_store_request_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';

final vendorRegistrationFormController = ChangeNotifierProvider(
  (ref) => getIt<VendorRegistrationFormController>(),
);

@injectable
class VendorRegistrationFormController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10), () {
      storeAndDestinationFormKey.currentState?.reset();
    });
    destinationStoreList = [];
    selectedStore = null;
    selectedDestination = null;
    isImageValidate = false;
    isStoreAndDestinationValidate = false;
    generateImageList();
    if (isNotify) {
      notifyListeners();
    }
  }

  disposeStore() {
    storeListState.success = null;
    storeListState.isLoading = true;
    notifyListeners();
  }

  GlobalKey waitingDialog = GlobalKey();

  final GlobalKey<FormState> storeAndDestinationFormKey = GlobalKey<FormState>();

  List<Uint8List?> imageList = [];

  /// update image list
  generateImageList() {
    imageList = List<Uint8List?>.generate(3, (index) => null);
    notifyListeners();
  }

  /// get image from image picker
  updateImage(int index, Uint8List? photoFile) async {
    imageList[index] = photoFile;
    if (isImageValidate == true) {
      isImageValidate = false;
    }
    notifyListeners();
  }

  /// remove image
  Future<void> removeImage(int index) async {
    imageList[index] = null;
    notifyListeners();
  }

  ///Destination Value
  DestinationData? selectedDestination;

  updateDestinations(value) {
    selectedDestination = value;
    if (selectedStore != null) {
      selectedStore = null;
    }
    notifyListeners();
  }

  ///Store Value
  StoreListData? selectedStore;

  updateStore(StoreListData? value) {
    selectedStore = value;
    notifyListeners();
  }

  ///Destination and Store List
  List<DestinationStoreListData> destinationStoreList = [];

  ///Add Destination and Store
  addDestinationAndStoreValue(DestinationData? destination, StoreListData? store, context) {
    ///If Value is already in sheet then does not add
    if (destinationStoreList.any((element) => element.storeData?.name == store?.name && element.destinationData?.name == destination?.name)) {
      showCommonErrorDialogNew(context: context, message: LocaleKeys.keyDestinationAndStoreValidation.localized);
    } else {
      destinationStoreList.add(DestinationStoreListData(destinationData: destination, storeData: store));

      ///Remove store and Destination value
      Future.delayed(const Duration(milliseconds: 10), () {
        storeAndDestinationFormKey.currentState?.reset();
      });
      selectedStore = null;
      selectedDestination = null;

      ///Remove Data form Store List Model
      storeListState.success?.data = [];
      if (isStoreAndDestinationValidate == true) {
        isStoreAndDestinationValidate = false;
      }
    }
    notifyListeners();
  }

  ///Remove Destination and Store
  removeDestinationAndStoreValue(index) {
    destinationStoreList.remove(destinationStoreList[index]);
    notifyListeners();
  }

  bool isImageValidate = false;
  bool isStoreAndDestinationValidate = false;
  List<Uint8List?> checkImageValidationList = [];

  ///Check Image Validation
  checkImageValidation() {
    checkNullImage();
    if (checkImageValidationList.isEmpty) {
      isImageValidate = true;
    } else {
      isImageValidate = false;
    }
    notifyListeners();
  }

  ///Check Store and Destination Validation
  checkStoreAndDestinationValidation() {
    if (destinationStoreList.isEmpty) {
      isStoreAndDestinationValidate = true;
    } else {
      isStoreAndDestinationValidate = false;
    }
    notifyListeners();
  }

  ///Check Image Validation
  checkNullImage() {
    for (var i in imageList) {
      if (i != null) {
        checkImageValidationList.add(i);
      }
    }
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  RegistrationRepository registrationRepository;

  VendorRegistrationFormController(this.registrationRepository);

  var destinationState = UIState<DestinationListResponseModel>();

  /// destination List APi
  Future<void> destinationListApi(BuildContext context, {bool? forVendor, bool isFromSignUp = false}) async {
    destinationState.isLoading = true;
    destinationState.success = null;
    notifyListeners();

    DestinationListRequestModel requestModel = DestinationListRequestModel(
      vendorUuid: Session.getUserType() == UserType.VENDOR.name ? Session.getUuid() : null,
      countryUuid: Session.userBox.get(keyCountryUuid),
      isStoreAvailable: isFromSignUp ? true : null,
      activeRecords: true,
    );
    final String request = destinationListRequestModelToJson(requestModel);
    final result = await registrationRepository.destinationListApi(request: request, forVendor: forVendor);

    result.when(success: (data) async {
      destinationState.success = data;
      destinationState.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    destinationState.isLoading = false;
    notifyListeners();
  }

  var storeListState = UIState<AssignStoreListResponseModel>();

  /// store List APi
  Future<void> storeListApi(BuildContext context, {required String destinationUuid}) async {
    storeListState.isLoading = true;
    storeListState.success = null;
    notifyListeners();

    // StoreListRequestModel requestModel = StoreListRequestModel(destinationUuid: destinationUuid, activeRecords: true);
    // final String request = storeListRequestModelToJson(requestModel);
    final result = await registrationRepository.storeListApi(destinationUuid: destinationUuid);

    result.when(success: (data) async {
      storeListState.success = data;
      storeListState.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    storeListState.isLoading = false;
    notifyListeners();
  }

  /// Upload Vendor Document
  UIState<CommonResponseModel> uploadVendorDocumentState = UIState<CommonResponseModel>();

  Future<void> uploadVendorDocumentApi(BuildContext context, {required String uuid}) async {
    uploadVendorDocumentState.isLoading = true;
    uploadVendorDocumentState.success = null;
    notifyListeners();

    List<MultipartFile>? multipartFileData = [];
    for (Uint8List? image in imageList) {
      if (image != null) {
        MultipartFile documentImage = checkIsPdfOrNot(image) ? MultipartFile.fromBytes(image, filename: '${DateTime.now().millisecondsSinceEpoch}.pdf', contentType: MediaType('image', 'pdf')) : MultipartFile.fromBytes(image, filename: '${DateTime.now().millisecondsSinceEpoch}.jpeg', contentType: MediaType('image', 'jpeg'));

        multipartFileData.add(documentImage);
      }
    }
    notifyListeners();

    FormData formData = FormData.fromMap({
      'files': multipartFileData,
    });

    final result = await registrationRepository.uploadVendorDocumentsApi(formData, uuid);
    result.when(success: (data) async {
      uploadVendorDocumentState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    uploadVendorDocumentState.isLoading = false;
    notifyListeners();
  }

  var uploadOdigoState = UIState<CommonResponseModel>();

  ///Upload Odigo APi
  Future<void> uploadOdigoStoreApi(BuildContext context, {String? vendorUuid}) async {
    uploadOdigoState.isLoading = true;
    uploadOdigoState.success = null;
    notifyListeners();

    List<DestinationOdigoStoreMappingDto>? destinationOdigoStoreMappingDtOs = [];

    for (var element in destinationStoreList) {
      destinationOdigoStoreMappingDtOs.add(DestinationOdigoStoreMappingDto(destinationUuid: element.destinationData?.uuid, odigoStoreUuid: element.storeData?.uuid));
    }

    UploadOdigoStoreRequestModel requestModel = UploadOdigoStoreRequestModel(vendorUuid: vendorUuid ?? '', destinationOdigoStoreMappingDtOs: destinationOdigoStoreMappingDtOs);

    final String request = uploadOdigoStoreRequestModelToJson(requestModel);
    final result = await registrationRepository.uploadOdigoStoreApi(request: request);

    result.when(success: (data) async {
      uploadOdigoState.success = data;
      uploadOdigoState.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    uploadOdigoState.isLoading = false;
    notifyListeners();
  }
}
