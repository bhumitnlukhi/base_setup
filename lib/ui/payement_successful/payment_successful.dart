import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/payement_successful/mobile/payment_successful_mobile.dart';
import 'package:odigo_vendor/ui/payement_successful/web/payment_successful_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({Key? key}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context){
        return const PaymentSuccessfulMobile();
      },
       desktop: (BuildContext context){
         return const PaymentSuccessfulWeb();
       }
    );
  }
}

