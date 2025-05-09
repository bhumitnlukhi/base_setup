import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/package/mobile/billing_mobile.dart';
import 'package:odigo_vendor/ui/package/web/billing_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Billing extends StatelessWidget {
  final bool? isForOwn;
  final bool? isVertical;
  final int dailyBudget;
  const Billing({Key? key,this.isVertical,this.isForOwn, required this.dailyBudget}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
        mobile: (BuildContext context) {
          return const BillingMobile();
        },
        desktop: (BuildContext context) {
          return  BillingWeb(isForOwn:isForOwn,isVertical:isVertical, dailyBudget: dailyBudget);
        },
        // tablet: (BuildContext context){
        //   return OrientationBuilder(builder: (BuildContext context, Orientation orientation){
        //     return orientation == Orientation.landscape ?  BillingWeb(isForOwn:isForOwn,isVertical:isForOwn) : const BillingMobile();
        //   });}
    );
  }
}

