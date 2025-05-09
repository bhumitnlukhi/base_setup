import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/notification/notification_screen_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/notification/web/helper/notification_header_tile_list_web.dart';
import 'package:odigo_vendor/ui/notification/web/shimmer_web/notification_shimmer.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_card.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreenWeb extends ConsumerStatefulWidget {
  const NotificationScreenWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationScreenWeb> createState() =>
      _NotificationScreenWebState();
}

class _NotificationScreenWebState extends ConsumerState<NotificationScreenWeb> with BaseConsumerStatefulWidget,BaseDrawerPageWidget {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      final notificationScreenWatch = ref.watch(notificationScreenController);
      notificationScreenWatch.disposeController(isNotify : true);
      await notificationScreenWatch.notificationListAPI(context);
      if(notificationScreenWatch.notificationListState.success?.status == ApiEndPoints.apiStatus_200){
        if(notificationScreenWatch.readAllNotificationState.success == null){
          if(mounted){
            await notificationScreenWatch.readAllNotificationAPI(context);
          }
        }
      }
      notificationScreenWatch.notificationListController.addListener(() async {
        if ((notificationScreenWatch.notificationListController.position.pixels >=
            notificationScreenWatch
                .notificationListController.position.maxScrollExtent -
                100)) {
          if ((notificationScreenWatch
              .notificationListState.success?.hasNextPage ??
              false) &&
              !(notificationScreenWatch.notificationListState.isLoadMore)) {
            notificationScreenWatch.increasePageNumber();
            await notificationScreenWatch.notificationListAPI(context);
          }
        }
      });
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  Widget _bodyWidget() {
    final notificationScreenWatch = ref.watch(notificationScreenController);
    return CommonCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// App bar
          Row(
            children: [
              InkWell(
                onTap: (){
                  ref.read(navigationStackController).pop();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.black,
                ),
              ),
              CommonText(
                title: LocaleKeys.keyNotification.localized,
                textStyle: TextStyles.regular.copyWith(
                  color: AppColors.black,
                  fontSize: 22.sp,
                ),
              ).paddingOnly(left: 7.w)
            ],
          ).paddingSymmetric(horizontal: context.width *0.02,vertical: context.width *0.02),
          Expanded(
            child: SingleChildScrollView(
              controller: notificationScreenWatch.notificationListController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  notificationScreenWatch.notificationListState.isLoading?_shimmerWidget() : notificationScreenWatch.isNotificationListEmpty()? EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,):ListView.builder(
                    itemCount: notificationScreenWatch.notificationFilterList.length,
                    shrinkWrap: true,

                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      var model =
                      notificationScreenWatch.notificationFilterList[index];
                      return  NotificationHeaderTileListWeb(
                        model: model,
                      ).paddingOnly(bottom: 10.h,left: 30.w,right: 30.w);
                    },
                  ),
                  notificationScreenWatch.notificationListState.isLoadMore
                      ? const Center(child: CircularProgressIndicator(color: AppColors.black171717,))
                      : const Offstage(),

                ],
              ),
            ),
          )


        ],
      ),
    );
  }

  Widget _shimmerWidget(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ShimmerNotification();
        },
      ),
    );
  }

}
