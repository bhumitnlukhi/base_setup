import 'package:odigo_vendor/framework/provider/network/api_result.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/package/model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_details_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_language_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';

abstract class StoreRepository {
  ///store list
  Future<ApiResult<StoreListResponseModel>> storeListApi({required String request, required String uuid, required int pageNumber, required int dataSize});

  ///all odigo store list
  Future<ApiResult<StoreListResponseModel>> odigoStoreListApi({required String request, required int pageNumber, int? pageSize});

  ///store details api
  Future<ApiResult<StoreDetailsResponseModel>> storeDetailApi({required String storeUuid, required bool forOdigoStore});

  ///store details api
  Future<ApiResult<StoreLanguageDetailResponseModel>> storeDetailLanguageApi({required String storeUuid});

  ///update store status api
  Future<ApiResult<CommonResponseModel>> updateStoreStatusApi({required String storeUuid, required String status});

  ///destination list api
  Future<ApiResult<DestinationListResponseModel>> destinationListApi({required String request, required int pageNumber, int? pageSize});

  ///Assign Store Api
  Future<ApiResult<CommonResponseModel>> assignStoreApi({required String request});
}
