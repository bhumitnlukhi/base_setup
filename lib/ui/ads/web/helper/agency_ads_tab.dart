import 'package:flutter/material.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/agency_tab_tile.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class AgencyAdsTab extends StatelessWidget{
  const AgencyAdsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AgencyTabTile(title: LocaleKeys.keyOwnAds.localized,value: true),
        SizedBox(width: context.width * 0.01,),
        AgencyTabTile(title: LocaleKeys.keyClientAds.localized,value: false),
      ],
    );
  }
}

