import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/client_master/contract/client_master_repository.dart';
import 'package:odigo_vendor/framework/repository/client_master/model/request/client_add_request_model.dart';
import 'package:odigo_vendor/framework/repository/client_master/model/request/client_update_request_model.dart';
import 'package:odigo_vendor/framework/repository/client_master/model/response/client_add_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/business_category_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/city_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/countrt_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/state_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';

final addEditClientsController = ChangeNotifierProvider(
      (ref) => getIt<AddEditClientsController>(),
);

@injectable
class AddEditClientsController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isAllFieldsValid = false;
    selectedCountry = null;
    selectedState = null;
    selectedCity = null;
    selectedCategory = null;
    if (isNotify) {
      notifyListeners();
    }
  }

  clearData(){
    clientNameController.clear();
    houseNameController.clear();
    streetNameController.clear();
    address1Controller.clear();
    address2Controller.clear();
    postCodeController.clear();
    landMarkController.clear();
    Future.delayed(const Duration(milliseconds: 10),() {
      formKey.currentState?.reset();
    },);
    notifyListeners();
  }

  ///Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ///Controller
  TextEditingController clientNameController = TextEditingController();
  TextEditingController houseNameController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController landMarkController = TextEditingController();

  ///To check if all fields are valid or not
  bool isAllFieldsValid = false;

  ///Check Validity of Password
  void checkIfAllFieldsValid(){
    isAllFieldsValid = (
        clientNameController.text.length>=3 &&
            clientNameController.text!='' &&  houseNameController.text.length>=3 &&
            houseNameController.text!='' &&  streetNameController.text.length>=3 &&
            streetNameController.text!='' && address1Controller.text.length>=3 &&
            address1Controller.text!='' && address2Controller.text.length>=3 &&
            address2Controller.text!='' && postCodeController.text.length>=3 &&
            postCodeController.text!=''&& landMarkController.text.length>=3 &&
            landMarkController.text!=''
    );
    notifyListeners();
  }

  ///Country List
  List<String> countryList = [
    'India',
    'USA',
    'UK'
  ];

  CountryData? selectedCountry;

  updateCountry(CountryData value){
    selectedCountry=value;
    if(selectedState!=null){
      selectedState=null;
      stateList.clear();
    }
    if(selectedCity!=null){
      selectedCity=null;
      cityList.clear();
    }
    notifyListeners();
  }

  ///State List
  List<String> stateList = [
    'Gujarat',
    'MP',
    'Bihar'
  ];

  StateData? selectedState;

  updateState(StateData value){
    selectedState=value;
    if(selectedCity!=null){
      selectedCity=null;
      cityList.clear();
    }
    notifyListeners();
  }

  ///City List
  List<String> cityList = [
    'Mumbai',
    'Ahmedabad',
    'Delhi'
  ];

  CityData? selectedCity;

  updateCity(value){
    selectedCity=value;
    notifyListeners();
  }

  ///City List
  List<String> categoryList = [
    'Clothing and Accessories',
    'Mobile',
    'Books'
  ];

  BusinessCategoryData? selectedCategory;

  updateCategory(BusinessCategoryData value){
    selectedCategory=value;
    notifyListeners();
  }



  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */




  ClientMasterRepository clientMasterRepository;
  AddEditClientsController(this.clientMasterRepository);

  var clientAddState = UIState<ClientAddResponseModel>();


  /// City list API
  Future<UIState<ClientAddResponseModel>> addClientApi(BuildContext context,{required bool isEdit, String? clientId,int? index,WidgetRef? ref}) async {
    clientAddState.isLoading = true;
    clientAddState.success = null;
    notifyListeners();
    // final selectClientWatch = ref?.watch(selectClientController);

    ClientAddRequestModel requestAddModel = ClientAddRequestModel(
      name: clientNameController.text,
      email: '',
      contactNumber: '',
      stateUuid: selectedState?.uuid??'',
      countryUuid: selectedCountry?.uuid??'',
      cityUuid: selectedCity?.uuid??'',
      addressLine1: address1Controller.text,
      addressLine2: address2Controller.text,
      businessCategoryUuid: selectedCategory?.uuid??'',
      houseNumber: houseNameController.text,
      landmark: landMarkController.text,
      postalCode: postCodeController.text,
      streetName: streetNameController.text
    );

    ClientUpdateRequestModel requestUpdateModel = ClientUpdateRequestModel(
        uuid: clientId,
        name: clientNameController.text.trimSpace,
        email: '',
        contactNumber: '',
        stateUuid: selectedState?.uuid??'',
        countryUuid: selectedCountry?.uuid??'',
        cityUuid: selectedCity?.uuid??'',
        addressLine1: address1Controller.text.trimSpace,
        addressLine2: address2Controller.text.trimSpace,
        businessCategoryUuid: selectedCategory?.uuid??'',
        houseNumber: houseNameController.text.trimSpace,
        landmark: landMarkController.text.trimSpace,
        postalCode: postCodeController.text.trimSpace,
        streetName: streetNameController.text.trimSpace
    );


    String request = isEdit? clientUpdateRequestModelToJson(requestUpdateModel) : clientAddRequestModelToJson(requestAddModel);


    final result = await clientMasterRepository.addClientApi(request,isEdit);

    result.when(success: (data) async {
      clientAddState.success = data;
      // if(isEdit){
      //   selectClientWatch?.updateClientValue(index??0, requestUpdateModel);
      // }
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    clientAddState.isLoading = false;
    notifyListeners();
    return clientAddState;
  }

}
