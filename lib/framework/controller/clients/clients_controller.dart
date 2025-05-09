import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/client_master/contract/client_master_repository.dart';
import 'package:odigo_vendor/framework/repository/client_master/model/response/client_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/contract/master_repository.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/business_category_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/city_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/countrt_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/master/model/response/state_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';
import 'package:odigo_vendor/ui/clients/web/helper/client_details_dialog_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';


final clientsController = ChangeNotifierProvider(
      (ref) => getIt<ClientsController>(),
);

@injectable
class ClientsController extends ChangeNotifier {

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    isEditing = true;

    businessCategoryListState.success = null;
    countryListState.success = null;
    stateListState.success = null;
    cityListState.success = null;
    businessCategoryListState.isLoading = true;
    countryListState.isLoading = true;
    stateListState.isLoading = true;
    cityListState.isLoading = true;
    clientSearchCtr.clear();
    categoryList.clear();
    countryList.clear();
    stateList.clear();
    cityList.clear();

    if (isNotify) {
      notifyListeners();
    }
  }

  TextEditingController clientSearchCtr = TextEditingController();

  clearSearchCtr(){
    clientSearchCtr.text='';
    notifyListeners();
  }

  GlobalKey clientDetailDialogKey = GlobalKey();

  Future<void> showClientDetailsDialog(BuildContext  context, WidgetRef ref, {required String clientUuid}) async{
    if(clientDetailDialogKey.currentContext == null){
      await clientDetailsApi(context, clientUuid).then((value) {
        if(value.success?.status == ApiEndPoints.apiStatus_200){
          showCommonWebDialog(
            // height: 0.4,
              width: 0.5,
              context: context,
              keyBadge: clientDetailDialogKey,
              dialogBody: const ClientDetailsDialogWidget()
          );
        }
      },);
    }

  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  /// --------MASTER APIS--------------
  Timer? debounce;

  MasterRepository masterRepository;
  ClientMasterRepository clientMasterRepository;
  ClientsController(this.masterRepository,this.clientMasterRepository);

  var businessCategoryListState = UIState<BusinessCategoryListResponseModel>();

  final List<BusinessCategoryData> categoryList = [];

  /// businessCategory list API
  Future<void> businessCategoryListApi(BuildContext context) async {
    businessCategoryListState.isLoading = true;
    businessCategoryListState.success = null;
    categoryList.clear();
    notifyListeners();

    Map<String, dynamic> requestModel = {
      "searchKeyword": "",
      "activeRecords": true
    };

    String request = jsonEncode(requestModel);
    final result = await masterRepository.businessCategoryApi(context, 1, request);

    result.when(success: (data) async {
      businessCategoryListState.isLoading = false;
      businessCategoryListState.success = data;
      categoryList.addAll(businessCategoryListState.success?.data ?? []);
    },
        failure: (NetworkExceptions error) {
          businessCategoryListState.isLoading = false;
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    businessCategoryListState.isLoading = false;
    notifyListeners();
  }


  var stateListState = UIState<StateListResponseModel>();

  final List<StateData> stateList = [];
  /// State list API
  Future<void> stateListApi(BuildContext context,{String? countryId}) async {
    stateListState.isLoading = true;
    stateListState.success = null;
    stateList.clear();
    notifyListeners();

    Map<String,dynamic> requestModel = {
      "searchKeyword": "",
      "countryUuid": countryId,
      "activeRecords": true
    };

    String request = jsonEncode(requestModel);
    final result = await masterRepository.stateListApi(context, 1,request );

    result.when(success: (data) async {
      stateListState.success = data;
      stateList.addAll(stateListState.success?.data??[]);
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    stateListState.isLoading = false;
    notifyListeners();
  }



  var cityListState = UIState<CityListResponseModel>();
  final List<CityData> cityList = [];


  /// City list API
  Future<void> cityListApi(BuildContext context,{String? countryId, String? stateId}) async {
    cityListState.isLoading = true;
    cityListState.success = null;
    cityList.clear();
    notifyListeners();

    Map<String,dynamic> requestModel = {
      "searchKeyword": "",
      "stateUuid": stateId,
      "countryUuid": countryId,
      "activeRecords": true
    };

    String request = jsonEncode(requestModel);
    final result = await masterRepository.cityListApi(context, 1,request );

    result.when(success: (data) async {
      cityListState.success = data;
      cityList.addAll(cityListState.success?.data ?? []);
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    cityListState.isLoading = false;
    notifyListeners();
  }


  var countryListState = UIState<CountryListResponseModel>();

  final List<CountryData> countryList = [];

  /// Country list API
  Future<void> countryListApi(BuildContext context) async {
    countryListState.isLoading = true;
    countryListState.success = null;
    countryList.clear();
    notifyListeners();

    Map<String,dynamic> requestModel = {
      "searchKeyword": "",
      "activeRecords": "true"
    };
    String request = jsonEncode(requestModel);
    final result = await masterRepository.countryListApi(context, 1,request );

    result.when(success: (data) async {
      countryListState.isLoading = false;
      countryListState.success = data;
      countryList.addAll(countryListState.success?.data ?? []);
    },
        failure: (NetworkExceptions error) {
          countryListState.isLoading = false;
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    cityListState.isLoading = false;
    notifyListeners();
  }


 var clientDetailsState = UIState<ClientDetailResponseModel>();

  /// Country list API
  Future<UIState<ClientDetailResponseModel>> clientDetailsApi(BuildContext context,String clientId) async {
    clientDetailsState.isLoading = true;
    clientDetailsState.success = null;
    // countryList.clear();
    notifyListeners();

    final result = await clientMasterRepository.clientDetailsApi(clientId);

    result.when(success: (data) async {
      clientDetailsState.success = data;
    },
        failure: (NetworkExceptions error) {
          // String errorMsg = NetworkExceptions.getErrorMessage(error);
          // showCommonErrorDialog(context: context, message: errorMsg);

        });

    clientDetailsState.isLoading = false;
    notifyListeners();
    return clientDetailsState;
  }

  bool isEditing = true;

  updateClientDetailState(bool value){
    isEditing = value;
    notifyListeners();
  }





}
