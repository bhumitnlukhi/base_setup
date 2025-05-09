import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/contract/profile_repository.dart';
import 'package:odigo_vendor/framework/repository/profile/model/request_model/delete_vendor_document_request_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/update_vendor_request_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';

final editRegistrationFormController = ChangeNotifierProvider(
  (ref) => getIt<EditRegistrationFormController>(),
);

@injectable
class EditRegistrationFormController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isLoading = false;
    imageList = [];
    imageListSecond = [];
    documentListForRemove = [];
    isImageValidate = false;
    checkImageValidationList.clear();
    generateImageList();
    checkIfAllFieldsValid();
    if (isNotify) {
      notifyListeners();
    }
  }

  ///Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ///Controller
  TextEditingController ownerNameController = TextEditingController();

  ///To check if all fields are valid or not
  bool isAllFieldsValid = false;

  ///Check Validity of Password
  void checkIfAllFieldsValid() {
    isAllFieldsValid = (ownerNameController.text.length >= 3 && ownerNameController.text != '');
    notifyListeners();
  }

  ///Set Name Value
  setNameValue(value) {
    ownerNameController.text = value;
    notifyListeners();
  }

  List<Uint8List?> imageList = [];
  List<Uint8List?> imageListSecond = [];

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

  bool isImageValidate = false;
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

  ///Check Image Validation
  checkNullImage() {
    showLog('image list length ${imageList.length}');
    for (var i in imageList) {
      if (i != null) {
        checkImageValidationList.add(i);
      }
    }
    notifyListeners();
  }

  ///Add Uni8List Image
  addCloudImage(WidgetRef ref) async {
    for (var image in ref.read(profileController).getVendorDocumentsState.success?.data?.vendorDocuments ?? []) {
      documentListForRemove?.add(image.uuid.toString());
      final response = await http.get(Uri.parse(image.url.toString()));
      imageListSecond.add(response.bodyBytes);
      for (var i = 0; i < imageListSecond.length; i++) {
        imageList[i] = imageListSecond[i];
      }
    }
    notifyListeners();
  }

  List<String>? documentListForRemove = [];

  ///Update Document List
  updateDocumentListForRemove(value) {
    documentListForRemove?.add(value);
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  ///Progress Indicator
  bool isLoading = false;

  void updateLoadingStatus(bool value) {
    isLoading = value;
    notifyListeners();
  }

  ProfileRepository profileRepository;

  EditRegistrationFormController(this.profileRepository);

  var updateVendorState = UIState<CommonResponseModel>();

  ///Check Update Vendor API
  Future<void> updateVendorApi(BuildContext context) async {
    updateVendorState.isLoading = true;
    updateVendorState.success = null;
    notifyListeners();

    UpdateVendorRequestModel updateVendorRequestModel = UpdateVendorRequestModel(uuid: Session.getUuid(), name: ownerNameController.text.trimSpace);
    String request = updateVendorRequestModelToJson(updateVendorRequestModel);

    final result = await profileRepository.updateVendorApi(request);
    result.when(success: (data) async {
      updateVendorState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    updateVendorState.isLoading = false;
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

    final result = await profileRepository.uploadVendorDocumentsApi(formData, uuid);
    result.when(success: (data) async {
      uploadVendorDocumentState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    uploadVendorDocumentState.isLoading = false;
    notifyListeners();
  }

  var deleteVendorDocumentState = UIState<CommonResponseModel>();

  ///Delete Vendor Document API
  Future<void> deleteVendorDocumentApi(BuildContext context) async {
    deleteVendorDocumentState.isLoading = true;
    deleteVendorDocumentState.success = null;
    notifyListeners();

    DeleteVendorDocumentRequestModel deleteVendorDocumentRequestModel = DeleteVendorDocumentRequestModel(uuidList: documentListForRemove);
    String request = deleteVendorDocumentRequestModelToJson(deleteVendorDocumentRequestModel);

    final result = await profileRepository.deleteVendorDocumentApi(request: request);
    result.when(success: (data) async {
      deleteVendorDocumentState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    deleteVendorDocumentState.isLoading = false;
    notifyListeners();
  }
}
