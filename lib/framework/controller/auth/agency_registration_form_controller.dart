import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/request_model/delete_vendor_document_request_model.dart';
import 'package:odigo_vendor/framework/repository/profile/model/response_model/agnecy_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/contract/registration_repository.dart';
import 'package:odigo_vendor/framework/repository/registration/model/request_model/agency_registration_request_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/request_model/city_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/request_model/country_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/request_model/state_list_request_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/city_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/country_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/state_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';

final agencyRegistrationFormController = ChangeNotifierProvider(
  (ref) => getIt<AgencyRegistrationFormController>(),
);

@injectable
class AgencyRegistrationFormController extends ChangeNotifier {
  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    Future.delayed(const Duration(milliseconds: 10), () {
      agencyRegistrationFormKey.currentState?.reset();
    });
    checkImageValidationList.clear();
    isImageValidate = false;
    ownerNameController.text = '';
    houseNameController.text = '';
    streetNameController.text = '';
    address1Controller.text = '';
    address2Controller.text = '';
    postCodeController.text = '';
    isAllFieldsValid = false;
    selectedCountry = null;
    selectedCity = null;
    selectedState = null;
    generateImageList();
    getAgencyDetailState.isLoading = true;
    imageListSecond = [];
    documentListForRemove = [];
    if (isNotify) {
      notifyListeners();
    }
  }

  void onEditPreFilledFields() {
    nameController.text = getAgencyDetailState.success?.data?.name ?? '';
    ownerNameController.text = getAgencyDetailState.success?.data?.ownerName ?? '';
    houseNameController.text = getAgencyDetailState.success?.data?.houseNumber ?? '';
    streetNameController.text = getAgencyDetailState.success?.data?.streetName ?? '';
    address1Controller.text = getAgencyDetailState.success?.data?.addressLine1 ?? '';
    address2Controller.text = getAgencyDetailState.success?.data?.addressLine2 ?? '';
    postCodeController.text = getAgencyDetailState.success?.data?.postalCode ?? '';
    updateCountry(countryState.success?.data?.where((element) => element.uuid == getAgencyDetailState.success?.data?.countryUuid.toString()).first);
    updateState(state.success?.data?.where((element) => element.uuid == getAgencyDetailState.success?.data?.stateUuid.toString()).first);
    updateCity(cityState.success?.data?.where((element) => element.uuid == getAgencyDetailState.success?.data?.cityUuid.toString()).first);
    checkIfAllFieldsValid();
    notifyListeners();
  }

  GlobalKey waitingDialog = GlobalKey();

  ///Form Key
  final GlobalKey<FormState> agencyRegistrationFormKey = GlobalKey<FormState>();

  ///Controller
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController houseNameController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  ///To check if all fields are valid or not
  bool isAllFieldsValid = false;

  ///Check Validity of Password
  void checkIfAllFieldsValid() {
    isAllFieldsValid = (ownerNameController.text.length >= 3 && ownerNameController.text != '' && houseNameController.text != '' && streetNameController.text.length >= 3 && streetNameController.text != '' && address1Controller.text.length >= 3 && address1Controller.text != '' && address2Controller.text.length >= 3 && address2Controller.text != '' && postCodeController.text.length >= 3 && postCodeController.text != '' && selectedCountry!=null && selectedCity!=null && selectedState!=null);
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
    for (var i in imageList) {
      if (i != null) {
        checkImageValidationList.add(i);
      }
    }
    notifyListeners();
  }

  CountryDto? selectedCountry;

  updateCountry(CountryDto? value) {
    selectedCountry = value;
    if (selectedState != null) {
      selectedState = null;
    }
    if (selectedCity != null) {
      selectedCity = null;
    }
    notifyListeners();
  }

  StateDto? selectedState;

  updateState(value) {
    selectedState = value;
    if (selectedCity != null) {
      selectedCity = null;
    }
    notifyListeners();
  }

  CityDto? selectedCity;

  updateCity(value) {
    selectedCity = value;
    notifyListeners();
  }

  List<String>? cloudImageList = [];

  ///Add Uni8List Image
  addCloudImage(WidgetRef ref) async {
    for (var image in ref.read(profileController).getAgencyDocumentsState.success?.data?.agencyDocuments ?? []) {
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

  disposeCountryValue() {
    selectedCountry = null;
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */


  RegistrationRepository registrationRepository;

  AgencyRegistrationFormController(this.registrationRepository);

  var countryState = UIState<CountryListResponseModel>();

  /// Country List APi
  Future<void> countryListApi(BuildContext context) async {
    countryState.isLoading = true;
    countryState.success = null;

    notifyListeners();

    CountryListRequestModel requestModel = CountryListRequestModel();
    final String request = countryListRequestModelToJson(requestModel);
    final result = await registrationRepository.countryList(request);

    result.when(success: (data) async {
      countryState.success = data;
      countryState.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    countryState.isLoading = false;
    notifyListeners();
  }

  var state = UIState<StateListResponseModel>();

  /// State List APi
  Future<void> stateListApi(BuildContext context, {String? countryUuid}) async {
    state.isLoading = true;
    state.success = null;
    notifyListeners();

    StateListRequestModel requestModel = StateListRequestModel(countryUuid: countryUuid);
    final String request = stateListRequestModelToJson(requestModel);
    final result = await registrationRepository.stateList(request);

    result.when(success: (data) async {
      state.success = data;
      state.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    state.isLoading = false;
    notifyListeners();
  }

  var cityState = UIState<CityListResponseModel>();

  /// City List APi
  Future<void> cityListApi(BuildContext context, {String? stateUuid, String? countryUuid}) async {
    cityState.isLoading = true;
    cityState.success = null;
    notifyListeners();

    CityListRequestModel requestModel = CityListRequestModel(countryUuid: countryUuid, stateUuid: stateUuid);
    final String request = cityListRequestModelToJson(requestModel);
    final result = await registrationRepository.cityList(request);

    result.when(success: (data) async {
      cityState.success = data;
      cityState.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    cityState.isLoading = false;
    notifyListeners();
  }

  /// Upload Agency Document
  UIState<CommonResponseModel> uploadAgencyDocumentState = UIState<CommonResponseModel>();

  Future<void> uploadAgencyDocumentApi(BuildContext context, {required String uuid}) async {
    uploadAgencyDocumentState.isLoading = true;
    uploadAgencyDocumentState.success = null;
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

    final result = await registrationRepository.uploadAgencyDocumentsApi(formData, uuid);
    result.when(success: (data) async {
      uploadAgencyDocumentState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    uploadAgencyDocumentState.isLoading = false;
    notifyListeners();
  }

  var agencyRegistrationState = UIState<CommonResponseModel>();

  /// Agency Registration APi
  Future<void> agencyRegistrationApi(BuildContext context) async {
    agencyRegistrationState.isLoading = true;
    agencyRegistrationState.success = null;
    notifyListeners();

    AgencyRegistrationRequestModel requestModel = AgencyRegistrationRequestModel(
      uuid: Session.getUuid().toString(),
      ownerName: ownerNameController.text.trimSpace,
      houseNumber: houseNameController.text.trimSpace,
      streetName: streetNameController.text.trimSpace,
      addressLine1: address1Controller.text.trimSpace,
      addressLine2: address2Controller.text.trimSpace,
      countryUuid: selectedCountry?.uuid,
      stateUuid: selectedState?.uuid,
      cityUuid: selectedCity?.uuid,
      postalCode: postCodeController.text.trimSpace,
      name: nameController.text.trimSpace,
    );
    final String request = agencyRegistrationRequestModelToJson(requestModel);
    final result = await registrationRepository.agencyRegistrationApi(request);

    result.when(success: (data) async {
      agencyRegistrationState.success = data;
      agencyRegistrationState.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    agencyRegistrationState.isLoading = false;
    notifyListeners();
  }

  var updateAgencyRegistrationState = UIState<CommonResponseModel>();

  /// Update Agency Name APi
  Future<void> updateAgencyNameAPI(BuildContext context) async {
    updateAgencyRegistrationState.isLoading = true;
    updateAgencyRegistrationState.success = null;
    notifyListeners();

    AgencyRegistrationRequestModel requestModel = AgencyRegistrationRequestModel(
      uuid: Session.getUuid().toString(),
      ownerName: ownerNameController.text.trimSpace,
      houseNumber: houseNameController.text.trimSpace,
      streetName: streetNameController.text.trimSpace,
      addressLine1: address1Controller.text.trimSpace,
      addressLine2: address2Controller.text.trimSpace,
      countryUuid: selectedCountry?.uuid,
      stateUuid: selectedState?.uuid,
      cityUuid: selectedCity?.uuid,
      postalCode: postCodeController.text.trimSpace,
      name: nameController.text.trimSpace,
    );
    final String request = agencyRegistrationRequestModelToJson(requestModel);
    final result = await registrationRepository.updateAgencyNameAPI(request);

    result.when(success: (data) async {
      updateAgencyRegistrationState.success = data;
      updateAgencyRegistrationState.isLoading = false;
      notifyListeners();
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    updateAgencyRegistrationState.isLoading = false;
    notifyListeners();
  }

  var getAgencyDetailState = UIState<GetAgencyDetailResponseModel>();

  ///Get Agency Detail api
  Future<void> getAgencyDetailApi(BuildContext context) async {
    getAgencyDetailState.isLoading = true;
    getAgencyDetailState.success = null;
    notifyListeners();

    final result = await registrationRepository.getAgencyDetailsApi(Session.getUuid().toString());
    result.when(success: (data) async {
      getAgencyDetailState.success = data;

      if (getAgencyDetailState.success?.status == ApiEndPoints.apiStatus_200) {
        await countryListApi(context);
        if (countryState.success?.status == ApiEndPoints.apiStatus_200) {
          await stateListApi(context, countryUuid: getAgencyDetailState.success?.data?.countryUuid);
          if (state.success?.status == ApiEndPoints.apiStatus_200) {
            await cityListApi(context, countryUuid: getAgencyDetailState.success?.data?.countryUuid, stateUuid: getAgencyDetailState.success?.data?.stateUuid);
            if (cityState.success?.status == ApiEndPoints.apiStatus_200) {
              onEditPreFilledFields();
            }
          }
        }
      }
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    getAgencyDetailState.isLoading = false;

    notifyListeners();
  }

  var deleteAgencyDocumentState = UIState<CommonResponseModel>();

  ///Delete Agency Document API
  Future<void> deleteAgencyDocumentApi(BuildContext context) async {
    deleteAgencyDocumentState.isLoading = true;
    deleteAgencyDocumentState.success = null;
    notifyListeners();

    DeleteVendorDocumentRequestModel deleteVendorDocumentRequestModel = DeleteVendorDocumentRequestModel(uuidList: documentListForRemove);
    String request = deleteVendorDocumentRequestModelToJson(deleteVendorDocumentRequestModel);

    final result = await registrationRepository.deleteAgencyDocumentApi(request: request);
    result.when(success: (data) async {
      deleteAgencyDocumentState.success = data;
    }, failure: (NetworkExceptions error) {
      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });

    deleteAgencyDocumentState.isLoading = false;
    notifyListeners();
  }
}
