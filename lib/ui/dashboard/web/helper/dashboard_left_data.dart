import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_content_card.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_total_count_content_web.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class DashboardLeftData extends StatelessWidget {
  const DashboardLeftData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final dashboardWatch = ref.watch(dashboardController);
        return Column(
          children: [
            FadeBoxTransition(
              child: CommonTotalCountContentWeb(
                  title:LocaleKeys.keyTotalAdsShownYesterday,
                  totalCount: dashboardWatch.vendorDashboardState.success?.data?.totalShownAdsToday ?? 0,
                  icon: Session.getUserType() == UserType.VENDOR.name?Assets.svgs.svgDashbaordVendor.keyName:Assets.svgs.svgDashboardAgency.keyName
              ).paddingOnly(bottom: 20.h),
            ),
            FadeBoxTransition(
              child: CommonContentCard(
                title:LocaleKeys.keyOngoingAdBudget,
                totalActiveCount: dashboardWatch.vendorDashboardState.success?.data?.alreadySpentBudgetForOngoingAds ?? 0,
                totalInActiveCount: dashboardWatch.vendorDashboardState.success?.data?.remainingBudgetForOngoingAds ?? 0,
                activeColor:AppColors.clrF3DF8D,
                inActiveColor: AppColors.clrECECEC,
                activeText: LocaleKeys.keyAlreadySpent,
                inActiveText: LocaleKeys.keyRemainingAmount,
                currencyRequired: true,
                //LocaleKeys.keyClients.localized,
                totalCount: dashboardWatch.vendorDashboardState.success?.data?.totalOngoingAdsBdget ?? 0,
                value: 0.2, countText: '',
              ),
            ),


          ],
        );
      },
    );
  }
}
