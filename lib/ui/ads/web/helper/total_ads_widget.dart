import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_details_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/total_ads_list_tile.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';

class TotalAdsWidget extends StatelessWidget {
  const TotalAdsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final adsDetailsWatch = ref.watch(adsDetailsController);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(title: LocaleKeys.keyTotalAds.localized, textStyle: TextStyles.regular.copyWith(color: AppColors.black171717,fontSize: 22.sp),),

            SizedBox(height: context.height * 0.038,),

            /// ads list
            Expanded(
              child: adsDetailsWatch.adContentState.isLoading?
              const CommonListShimmer(height: 200,):
                  adsDetailsWatch.contentList.isEmpty?
                  Center(child: EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,title: LocaleKeys.keyNoDataFound.localized, imgHeight: 100, imgWidth: 100,)):
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: adsDetailsWatch.contentList.length,
                  controller: adsDetailsWatch.contentScroll,
                  itemBuilder: (context,index){
                return TotalAdsListTile(index: index);
              }, separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: context.height * 0.020);
              },),
            )
          ],
        );
      }
    );
  }
}
