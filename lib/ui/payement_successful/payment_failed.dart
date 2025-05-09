import 'package:flutter/material.dart';
import 'package:odigo_vendor/framework/repository/wallet/model/response/payment_fail_response_model.dart';
import 'package:odigo_vendor/ui/payement_successful/mobile/payment_failed_mobile.dart';
import 'package:odigo_vendor/ui/payement_successful/web/payment_failed_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PaymentFailed extends StatelessWidget {
  final FailPaymentResponseModel? failPaymentResponseModel;
  const PaymentFailed({Key? key, this.failPaymentResponseModel}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const PaymentFailedMobile();
        },
        desktop: (BuildContext context) {
          return  PaymentFailedWeb(failPaymentResponseModel: failPaymentResponseModel,);
        }
    );
  }
}

