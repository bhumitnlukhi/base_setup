import 'package:odigo_vendor/framework/repository/registration/model/response_model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';

class DestinationStoreListData {
  DestinationData? destinationData;
  StoreListData? storeData;

  DestinationStoreListData({required this.destinationData, required this.storeData});
}
