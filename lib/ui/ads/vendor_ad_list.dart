import 'package:flutter/material.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/ui/ads/mobile/vendor_ad_list_mobile.dart';
import 'package:odigo_vendor/ui/ads/web/vendor_ad_list_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VendorAdList extends StatelessWidget with BaseStatelessWidget {
  final StoreListData? storeListData;
  final String? storeUuid;
  final String? destinationUuid;

  const VendorAdList({Key? key,  this.storeListData, required this.storeUuid, required this.destinationUuid}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

        mobile: (BuildContext context) {
          return const VendorAdListMobile();
        },
        desktop: (BuildContext context) {
          return VendorAdListWeb(storeUuid: storeUuid, destinationUuid: destinationUuid);
        }
    );
  }
}

