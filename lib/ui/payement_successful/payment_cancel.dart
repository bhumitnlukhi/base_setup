import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/payement_successful/mobile/payment_cancel_mobile.dart';
import 'package:odigo_vendor/ui/payement_successful/web/payment_cancel_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PaymentCancel extends StatelessWidget {
  const PaymentCancel({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const PaymentCancelMobile();
        },
        desktop: (BuildContext context) {
          return const PaymentCancelWeb();
        }
    );
  }
}

