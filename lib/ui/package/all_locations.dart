import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/package/mobile/all_locations_mobile.dart';
import 'package:odigo_vendor/ui/package/web/all_locations_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AllLocations extends StatelessWidget {
  final bool? isForOwn;
  const AllLocations({Key? key,this.isForOwn}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
        mobile: (BuildContext context) {
          return const AllLocationsMobile();
        },
        desktop: (BuildContext context) {
          return  AllLocationsWeb(isForOwn:isForOwn);
        },
        // tablet: (BuildContext context){
        //   return OrientationBuilder(builder: (BuildContext context, Orientation orientation){
        //     return orientation == Orientation.landscape ?  AllLocationsWeb(isForOwn:isForOwn) : const AllLocationsMobile();
        //   });}
    );
  }
}

