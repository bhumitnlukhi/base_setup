import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:odigo_vendor/framework/dependency_injection/inject.dart';
import 'package:odigo_vendor/framework/provider/network/network_exceptions.dart';
import 'package:odigo_vendor/framework/repository/ticket/contract/ticket_repository.dart';
import 'package:odigo_vendor/framework/repository/ticket/model/response/faq_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/framework/utils/ui_state.dart';

final faqScreenController = ChangeNotifierProvider(
  (ref) => getIt<FaqScreenController>(),
);

@injectable
class FaqScreenController extends ChangeNotifier {
  TicketRepository ticketRepository;

  FaqScreenController(this.ticketRepository);

  ///Dispose Controller
  void disposeController({bool isNotify = false}) {
    faqListState.isLoading = false;
    faqListState.success = null;
    selectedIndex = null;
    faqData.clear();
    if (isNotify) {
      notifyListeners();
    }
  }

  void resetPagination() {
    pageNo = 1;
    faqData = [];
    faqListState.success = null;
    faqListState.isLoading = false;
    notifyListeners();
  }

  void updateIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
    } else {
      selectedIndex = null;
    }
    notifyListeners();
  }

  /*
  /// ---------------------------- Api Integration ---------------------------------///
   */

  var faqListState = UIState<FaqListResponseModel>();

  int pageNo = 1;
  List<FaqModel?> faqData = [];
  int? selectedIndex;

  /// ticket List APi
  Future<void> faqListAPI(BuildContext context, bool pagination, {String? status}) async {
    if (faqListState.success?.hasNextPage ?? false) {
      pageNo = pageNo + 1;
    }

    if (pageNo == 1 || pagination == false) {
      resetPagination();
      faqListState.isLoading = true;
    } else {
      faqListState.isLoadMore = true;
      faqListState.isLoadMore = true;
    }

    faqListState.success = null;
    notifyListeners();

    Map<String, dynamic> map = {
      "activeRecords": true,
      "platformType": Session.getUserType(),
    };

    final String request = jsonEncode(map);
    final result = await ticketRepository.faqListAPI(request: request, pageNo: pageNo);

    result.when(success: (data) async {
      faqListState.success = data;
      faqData.addAll(faqListState.success?.data ?? []);

      faqListState.isLoading = false;
      faqListState.isLoadMore = false;
    }, failure: (NetworkExceptions error) {
      faqListState.isLoadMore = false;

      // String errorMsg = NetworkExceptions.getErrorMessage(error);
      // showCommonErrorDialog(context: context, message: errorMsg);
    });
    faqListState.isLoading = false;
    faqListState.isLoadMore = false;

    notifyListeners();
  }
}
