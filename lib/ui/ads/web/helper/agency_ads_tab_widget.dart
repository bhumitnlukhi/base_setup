import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/agency_ads_tab.dart';
import 'package:odigo_vendor/ui/ads/web/helper/client_list_for_ads_widget.dart';
import 'package:odigo_vendor/ui/ads/web/helper/own_ads_list_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class AgencyAdsTabWidget extends ConsumerWidget with BaseConsumerWidget {
  const AgencyAdsTabWidget({super.key});

  @override
  Widget buildPage(BuildContext context,WidgetRef ref) {
    final adsWatch = ref.watch(adsController);
    return Column(
      children: [
        const AgencyAdsTab(),

        SizedBox(height: context.height*0.03,),

        Expanded(child: adsWatch.isSelectedOwnAds ? const OwnAdsListWidget() : const ClientListForAdWidget()),
      ],
    );
  }
}
