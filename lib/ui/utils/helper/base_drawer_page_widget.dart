import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/drawer/drawer_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/widgets/drawer/expanded_drawer_web.dart';
import 'package:odigo_vendor/ui/utils/widgets/drawer/small_drawer_web.dart';

mixin BaseDrawerPageWidget<Page extends StatefulWidget> on State<Page> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(1366, 758),
      minTextAdapt: true,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.black,
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final drawerWatch = ref.watch(drawerController);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Left Widget
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: drawerWatch.isExpanded
                    ? const Expanded(
                  flex: 2,
                  child: ExpandedDrawerWeb(),
                )
                    : const Expanded(
                  flex: 1,
                  child: SmallDrawerWeb(),
                ),
              ),

              ///Right Widget
              Expanded(
                flex: 12,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r), color: AppColors.whiteF7F7FC),
                  child: buildPage(context),
                ).paddingOnly(left: 11.w, right: 30.w, bottom: 30.h, top: 30.h),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPage(BuildContext context);
}
