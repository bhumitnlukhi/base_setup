import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/package/mobile/select_store_mobile.dart';
import 'package:odigo_vendor/ui/package/web/select_store_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SelectStore extends StatelessWidget {
  final String destinationUuid;

  const SelectStore({Key? key, required this.destinationUuid}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
          return const SelectStoreMobile();
        },
        desktop: (BuildContext context) {
          return SelectStoreWeb(destinationUuid: destinationUuid);
        },
    // tablet: (BuildContext context){
    // return OrientationBuilder(builder: (BuildContext context, Orientation orientation){
    // return orientation == Orientation.landscape ? const SelectStoreWeb() : const SelectStoreMobile();
    // })
    // ;}
    );
  }
}

