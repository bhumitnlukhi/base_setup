import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/package/mobile/select_client_mobile.dart';
import 'package:odigo_vendor/ui/package/web/select_client_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SelectClient extends StatelessWidget {
  final bool? isForOwn;
  const SelectClient({Key? key, this.isForOwn}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

        mobile: (BuildContext context) {
          return const SelectClientMobile();
        },
        desktop: (BuildContext context) {
          return  SelectClientWeb(isForOwn:isForOwn);
        },
    // tablet: (BuildContext context){
    // return OrientationBuilder(builder: (BuildContext context, Orientation orientation){
    // return orientation == Orientation.landscape ? SelectClientWeb(isForOwn:isForOwn) : const SelectClientMobile();
    // });}
    );
  }
}

