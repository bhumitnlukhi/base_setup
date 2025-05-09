import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/drawer/drawer_controller.dart';
import 'package:odigo_vendor/framework/controller/package/package_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/repository/home/model/home_menu_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/hover_animation.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ExpandedDrawerWeb extends StatelessWidget with BaseStatelessWidget {
  const ExpandedDrawerWeb({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final drawerWatch = ref.watch(drawerController);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.height * 0.05,
              child: InkWell(
                onTap: () {
                  drawerWatch.hideSideMenu();
                  ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
                },
                child: CommonSVG(
                  strIcon: Assets.svgs.svgDashboardAppIcon.keyName,
                ),
              ),
            ),
            SizedBox(height: 35.h),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: drawerWatch.drawerMenuList.length,
                itemBuilder: (BuildContext context, int menuIndex) {
                  DrawerMenuModel screen = drawerWatch.drawerMenuList[menuIndex];
                  return HoverAnimation(
                    transformSize: 1.05,
                    child: InkWell(
                      onDoubleTap: () {
                        drawerWatch.hideSideMenu();
                        // ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
                      },
                      onTap: () {
                        if ((drawerWatch.selectedScreen?.parentScreen == screen.parentScreen) == false) {
                          switch (menuIndex) {
                            case 0:
                              break;
                            case 1:
                              break;
                            case 2:
                              final storeWatch = ref.watch(storesController);
                              storeWatch.disposeController(isNotify: true);
                              break;
                            case 3:
                              final packageWatch = ref.watch(packageController);
                              packageWatch.disposeController(isNotify: true);
                              break;
                            case 4:
                              final adsWatch = ref.watch(adsController);
                              adsWatch.disposeController(isNotify: true);
                              break;
                          }
                        }

                        drawerWatch.updateSelectedScreen(screen.screenName ?? ScreenName.dashboard);
                        drawerWatch.expandingList(menuIndex);
                        ref.read(navigationStackController).pushAndRemoveAll(screen.item);
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: (drawerWatch.selectedScreen?.parentScreen == screen.parentScreen) ? AppColors.black232222 : AppColors.black,
                              borderRadius: BorderRadius.circular(54.r),
                            ),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  child: CommonSVG(
                                    strIcon: drawerWatch.drawerMenuList[menuIndex].strIcon ?? '',
                                    svgColor: (drawerWatch.selectedScreen?.parentScreen == screen.parentScreen) ? AppColors.blue009AF1 : AppColors.white,
                                    // boxFit: BoxFit.scaleDown,
                                  ),
                                ).paddingOnly(right: 4.w),
                                Expanded(
                                  child: CommonText(
                                    title: drawerWatch.drawerMenuList[menuIndex].menuName.localized,
                                    textStyle: TextStyles.regular.copyWith(fontSize: 13.sp, color: (drawerWatch.selectedScreen?.parentScreen == screen.parentScreen) ? AppColors.blue009AF1 : AppColors.white),
                                  ),
                                ),
                                (drawerWatch.drawerMenuList[menuIndex].dropDownList != null)
                                    ? CommonSVG(
                                        strIcon: screen.isExpanded ? Assets.svgs.svgArrowUp.keyName : Assets.svgs.svgDownArrow.keyName,
                                        boxFit: BoxFit.scaleDown,
                                        svgColor: (drawerWatch.selectedScreen?.parentScreen == screen.parentScreen) ? AppColors.blue009AF1 : AppColors.white,
                                      ).paddingOnly(right: 13.w)
                                    : Container()
                              ],
                            ).paddingSymmetric(vertical: 10.h),
                          ).paddingOnly(bottom: 0.h),
                          drawerWatch.drawerMenuList[menuIndex].isExpanded
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: drawerWatch.drawerMenuList[menuIndex].dropDownList?.length ?? 0,
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {},
                                        child: CommonText(
                                          title: drawerWatch.drawerMenuList[menuIndex].dropDownList?[index] ?? '',
                                          textStyle: TextStyles.regular.copyWith(
                                              fontSize: 12.sp,
                                              color: /*(orderManagementWatch.selectedTab == index) ? AppColors.blue009AF1 :*/
                                                  AppColors.white.withOpacity(0.6)),
                                        ).paddingOnly(
                                          left: 23.w,
                                        ));
                                  },
                                  separatorBuilder: (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 35.h,
                                    );
                                  },
                                )
                              : Container()
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10.h,
                  );
                },
              ),
            ),
            SizedBox(height: 25.h),
            InkWell(
              onTap: () {
                /// show popup confirmation popup
                showConfirmationDialogWeb(
                  context: context,
                  title: LocaleKeys.keyAreYouSure.localized,
                  message: LocaleKeys.keyLogoutConfirmationMessageWeb.localized,
                  titleFontSize: 20.sp,
                  messageFontSize: 16.sp,
                  dialogWidth: context.width * 0.35,
                  didTakeAction: (isPositive) async {
                    if (isPositive) {
                      await drawerWatch.logoutApi(context);

                      if (drawerWatch.logoutAPIState.success?.status == ApiEndPoints.apiStatus_200) {
                        if (context.mounted) {
                          Session.sessionLogout(ref, context);
                        }
                      }
                    }
                  },
                );
              },
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40.w,
                    child: CommonSVG(
                      strIcon: Assets.svgs.svgLogoutTransparent.keyName,
                      svgColor: AppColors.white,
                      isRotate: true,
                    ),
                  ).paddingOnly(right: 4.w),
                  Expanded(
                    child: CommonText(
                      title: LocaleKeys.keyLogout.localized,
                      textStyle: TextStyles.regular.copyWith(fontSize: 13.sp, color: AppColors.white),
                    ),
                  ),
                ],
              ).paddingSymmetric(vertical: 10.h),
            ),
            SizedBox(height: 35.h),
          ],
        ).paddingOnly(left: 23.w, top: 33.h, bottom: 25.h);
      },
    );
  }
}
