import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/ads/mobile/client_Ad_list_mobile.dart';
import 'package:odigo_vendor/ui/ads/web/client_ad_list_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ClientAdList extends StatelessWidget with BaseStatelessWidget {
  final String? clientUuid;
  const ClientAdList({Key? key, this.clientUuid}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

        mobile: (BuildContext context) {
          return const ClientAdListMobile();
        },
        desktop: (BuildContext context) {
          return ClientAdListWeb(clientUuid: clientUuid,);
        }
    );
  }
}

