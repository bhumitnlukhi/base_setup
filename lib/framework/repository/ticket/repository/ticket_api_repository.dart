import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/ticket/contract/ticket_repository.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/create_ticket_response_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/faq_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_detail_response_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_reason_list_response_model.dart';

@LazySingleton(as: TicketRepository, env: Env.environments)
class TicketApiRepository implements TicketRepository{
  final DioClient apiClient;
  TicketApiRepository(this.apiClient);

  @override
  Future createTicket({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.addTicket, request);
      CreateTicketResponseModel responseModel = createTicketResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getTicketReasonList({required String request}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.getTicketReasonList, request);
      TicketReasonListResponseModel responseModel = ticketReasonListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future ticketDetail({required String ticketId}) async {
    try {
      Response? response = await apiClient.getRequest(ApiEndPoints.getTicketDetail(ticketId));
      TicketDetailResponseModel responseModel = ticketDetailResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future ticketList({required String request, required  int pageNumber}) async {
    try {
      Response? response = await apiClient.postRequest(
          ApiEndPoints.getTicketList(pageNumber), request);
      TicketListResponseModel responseModel = ticketListResponseModelFromJson(
          response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future faqListAPI({required String request,required int pageNo}) async {
    try {
      Response? response = await apiClient.postRequest(ApiEndPoints.faqList(pageNo), request);
      FaqListResponseModel responseModel = faqListResponseModelFromJson(response.toString());
      return ApiResult.success(data: responseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
