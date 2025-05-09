import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/common/model/common_response_model.dart';
import 'package:odigo_vendor/framework/repository/notification/contract/notification_repository.dart';
import 'package:odigo_vendor/framework/repository/notification/model/response/notification_list_reponse_model.dart';
import 'package:odigo_vendor/framework/repository/notification/model/response/notification_unread_count_reponse_model.dart';

@LazySingleton(as: NotificationRepository, env: Env.environments)
class NotificationApiRepository extends NotificationRepository {
  final DioClient apiClient;

  NotificationApiRepository(this.apiClient);

  @override
  Future notificationListAPI(String request,int pageNumber, int pageSize)async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.notificationList(pageNumber,pageSize),request);
      NotificationListResponseModel responseModel = notificationListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future deleteNotification(String notificationId) async{
    try {
      Response? response = await apiClient.deleteRequest(ApiEndPoints.notificationListDeleteNotification(notificationId), '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future deleteNotificationList() async{
    try {
      Response? response = await apiClient.deleteRequest(ApiEndPoints.notificationListDeleteAll, '');
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future notificationUnreadCountAPI(String request) async{
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.notificationUnReadCount,request);
      NotificationUnReadCountResponseModel responseModel = notificationUnReadCountResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
  @override
  Future readAllNotification() async{
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.notificationReadAll);
      CommonResponseModel responseModel = commonResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
