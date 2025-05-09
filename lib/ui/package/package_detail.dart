import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/package/mobile/package_detail_mobile.dart';
import 'package:odigo_vendor/ui/package/web/package_detail_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PackageDetail extends StatelessWidget {
  final String packageUuid;
  final String? clientMasterUuid;
  const PackageDetail({Key? key, required this.packageUuid,  this.clientMasterUuid}) : super(key: key);

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
        mobile: (BuildContext context) {
          return const PackageDetailMobile();
        },
        desktop: (BuildContext context) {
          return PackageDetailWeb(packageUuid: packageUuid, clientMasterUuid: clientMasterUuid );
        }
    );
  }
}

