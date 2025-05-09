import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/add_edit_ads_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/common_radio_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class AdsForWidget extends ConsumerStatefulWidget {
  const AdsForWidget({super.key});

  @override
  ConsumerState<AdsForWidget> createState() => _AdsForWidgetState();
}

class _AdsForWidgetState extends ConsumerState<AdsForWidget> with BaseConsumerStatefulWidget {

  @override
  Widget buildPage(BuildContext context) {
    final addEditAdsWatch = ref.watch(addEditAdsController);
    final selectClientWatch = ref.watch(selectClientController);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CommonRadioWidget(name: LocaleKeys.keyYourself.localized.localized,isSelect: addEditAdsWatch.selectedAdsFor == AdsForEnum.yourself,onTap:  (){
          addEditAdsWatch.onRadioUpdateAdsFor(AdsForEnum.yourself);
        }),

        SizedBox(width: context.width * 0.02,),

        CommonRadioWidget(name: LocaleKeys.keyClient.localized,isSelect: addEditAdsWatch.selectedAdsFor == AdsForEnum.client,
            onTap: (){
          addEditAdsWatch.onRadioUpdateAdsFor(AdsForEnum.client);
          selectClientWatch.clientListApi(context, false,isFromCreateAd: true);
        }),

      ],
    );
  }
}
