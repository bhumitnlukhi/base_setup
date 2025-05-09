import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_content_card.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_total_count_content_web.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class DashboardRightData extends StatelessWidget {
  const DashboardRightData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final dashboardWatch = ref.watch(dashboardController);
        return Column(
          children: [
            FadeBoxTransition(
              child: CommonTotalCountContentWeb(totalCount: dashboardWatch.vendorDashboardState.success?.data?.totalShownAdsTillDate ?? 0, title: LocaleKeys.keyAdsShownTillDate, icon: Session.getUserType() == UserType.VENDOR.name ? Assets.svgs.svgDashbaordVendor.keyName : Assets.svgs.svgDashboardAgency.keyName).paddingOnly(bottom: 20.h),
            ),
            FadeBoxTransition(
              child: CommonContentCard(
                title: Session.getUserType() == UserType.VENDOR.name ? LocaleKeys.keyStoresRegistered : LocaleKeys.keyClientRegistered,
                totalActiveCount: Session.getUserType() == UserType.VENDOR.name ? dashboardWatch.vendorDashboardState.success?.data?.activeStore ?? 0 : dashboardWatch.vendorDashboardState.success?.data?.activeClientMaster ?? 0,
                totalInActiveCount: Session.getUserType() == UserType.VENDOR.name ? dashboardWatch.vendorDashboardState.success?.data?.deActiveStore ?? 0 : dashboardWatch.vendorDashboardState.success?.data?.deActiveClientMaster ?? 0,
                activeColor: AppColors.clrF3DF8D,
                inActiveColor: AppColors.clrECECEC,
                currencyRequired: false,
                countText: Session.getUserType() == UserType.VENDOR.name ? LocaleKeys.keyStores.localized : LocaleKeys.keyClients.localized,
                totalCount: Session.getUserType() == UserType.VENDOR.name ? dashboardWatch.vendorDashboardState.success?.data?.totalStore ?? 0 : dashboardWatch.vendorDashboardState.success?.data?.totalClientMaster ?? 0,
                totalPendingCount: Session.getUserType() == UserType.VENDOR.name ? dashboardWatch.vendorDashboardState.success?.data?.pendingStore : dashboardWatch.vendorDashboardState.success?.data?.pendingStore,
                totalRejectedCount: Session.getUserType() == UserType.VENDOR.name ? dashboardWatch.vendorDashboardState.success?.data?.rejectedStore : dashboardWatch.vendorDashboardState.success?.data?.rejectedStore,
                value: 0.2,
                isRightSideView: true,
              ),
            ),
          ],
        );
      },
    );
  }
}
