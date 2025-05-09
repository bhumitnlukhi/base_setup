import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/drawer/drawer_controller.dart';
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

class SmallDrawerWeb extends StatelessWidget with BaseStatelessWidget {
  const SmallDrawerWeb({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final drawerWatch = ref.watch(drawerController);
        return Column(
          children: [
            /// Top Icon List
            SizedBox(
              height: context.height * 0.05,
              child: InkWell(
                  onTap: () {
                    drawerWatch.hideSideMenu();
                    ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
                    // ref.read(drawerController).updateSelectedScreen(ScreenName.dashboard, isNotify: false);

                  },
                  child:  CommonSVG(strIcon: Assets.svgs.svgDashboardAppIcon.keyName)),
            ),

            /// Additional Space
            SizedBox(height: 35.h),
            Expanded(
              /// Side Menu item List
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: drawerWatch.drawerMenuList.length,
                itemBuilder: (BuildContext context, int menuIndex) {
                  DrawerMenuModel screen = drawerWatch.drawerMenuList[menuIndex];
                  return HoverAnimation(
                    transformSize: 1.05,
                    child: InkWell(
                      /// On Icon Tap (navigate to the screen and remove all other screen from stack)
                      onTap: () {
                        drawerWatch.updateSelectedScreen(screen.screenName ?? ScreenName.dashboard);
                        drawerWatch.expandingList(menuIndex);
                        ref.read(navigationStackController).pushAndRemoveAll(screen.item);
                      },

                      /// On Icon Double tap (expand and shrink side menu)
                      onDoubleTap: () {
                        drawerWatch.hideSideMenu();
                        // ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());

                      },

                      /// Icon Widget
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, color: drawerWatch.selectedScreen?.parentScreen == screen.parentScreen ? AppColors.black232222 : AppColors.transparent),
                        child: CommonSVG(strIcon: drawerWatch.drawerMenuList[menuIndex].strIcon ?? '', svgColor: AppColors.white,).paddingAll(drawerWatch.selectedScreen?.parentScreen == screen.parentScreen ? 10.w : 0),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 30.h,
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
                  didTakeAction: (isPositive) {
                    if (isPositive) {
                      Session.sessionLogout(ref,context);
                    }
                  },
                );
              },
              child: SizedBox(
                width: 40.w,
                child:  CommonSVG(
                  strIcon: Assets.svgs.svgLogoutTransparent.keyName,
                  svgColor: AppColors.white,
                ),
              ).paddingOnly(right: 4.w).paddingSymmetric(vertical: 10.h),
            ),
            SizedBox(height: 35.h),
          ],
        ).paddingOnly(left: 23.w, top: 33.h, bottom: 25.h);
      },
    );
  }
}
