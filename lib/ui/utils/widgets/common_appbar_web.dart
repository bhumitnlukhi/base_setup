import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/notification/notification_screen_controller.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/appbar_shimmer.dart';
import 'package:odigo_vendor/ui/notification/web/helper/notification_header_tile_list_web.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/hover_animation.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_initial_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';

class CommonAppBarWeb extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final bool hasTitle;
  final bool hasActions;
  final int menuIndex;

  const CommonAppBarWeb({
    this.hasTitle = true,
    this.hasActions = true,
    Key? key,
    this.menuIndex = -1,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height + 30.h);

  @override
  ConsumerState<CommonAppBarWeb> createState() => _CommonAppBarWebState();
}

class _CommonAppBarWebState extends ConsumerState<CommonAppBarWeb> with BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    final profileWatch = ref.read(profileController);
    profileWatch.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await profileWatch.getProfileDetail(context);

    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final profileWatch = ref.watch(profileController);
    return Column(
      children: [
        ///App bar
        profileWatch.profileDetailState.isLoading?const AppbarShimmer():Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
               ref.read(navigationStackController).push(const NavigationStackItem.profile());
              },
              child: Row(
                children: [
                  // profileWatch.profileImage == null
                  //     ?
                  CommonInitialText(
                    text:  '${profileWatch.profileDetailState.success?.data?.name}'.toUpperCase(),
                    height: 57.h,
                    width: 57.h,
                    fontSize: 25.sp,
                  ).paddingOnly(right: context.width*0.015),

                  CommonText(
                    title: '${profileWatch.profileDetailState.success?.data?.name?.trim().capitalizeFirstLetterOfSentence}',
                    textStyle: TextStyles.regular.copyWith(fontSize: 22.sp, color: AppColors.black),
                  ).paddingOnly(right: 6.w),
                  CommonSVG(strIcon: Assets.svgs.svgRightArrow.keyName,height: context.height*0.050,width: context.width*0.050,isRotate: true,)
                ],
              ),
            ),
            Row(
              children: [
                ///-------------notification dialog---------///
                Consumer(
                    builder: (context,ref,child) {
                      final notificationWatch = ref.watch(notificationScreenController);
                      return Stack(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                            ),
                            child: PopupMenuButton<SampleItem>(
                              tooltip:'',
                              padding: EdgeInsets.zero,
                              clipBehavior: Clip.hardEdge,
                              elevation: 5,
                              constraints: BoxConstraints.expand(
                                  height: context.height * 0.5,
                                  width: context.width * 0.3
                              ),
                              iconSize: 60.w,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                              offset: Offset(0, 50.h),
                              color: AppColors.white,
                              surfaceTintColor: AppColors.white,
                              shadowColor: AppColors.white,
                              onOpened: () async{
                                notificationWatch.disposeController(isNotify:true);
                                await notificationWatch.notificationListAPI(context,initPageSize: 5,);
                                if(notificationWatch.notificationListState.success?.status == ApiEndPoints.apiStatus_200){
                                  if(mounted){
                                    await notificationWatch.readAllNotificationAPI(context);
                                  }
                                }

                              },
                              icon: Container(
                                height: 57.h,
                                width: 57.h,
                                decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
                                child: CommonSVG(
                                  strIcon: Assets.svgs.svgNotificationAppbar.keyName,
                                  boxFit: BoxFit.scaleDown,
                                  height: 57.h,
                                  width: 57.h,
                                ),
                              ).paddingOnly(right: 0.w),
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                                PopupMenuItem<SampleItem>(
                                  padding: EdgeInsets.zero,
                                  child: Consumer(
                                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                        final notificationScreenWatch= ref.watch(notificationScreenController);
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CommonText(
                                                  title: LocaleKeys.keyNotification.localized,
                                                  textStyle: TextStyles.medium
                                                      .copyWith(fontSize: 18.sp, color: AppColors.black),
                                                ).paddingSymmetric(vertical: 12.h, horizontal: 20.w),


                                                /// Clear All notification
                                                notificationScreenWatch.isNotificationListEmpty()
                                                    ?const Offstage():  InkWell(
                                                  onTap: ()async {
                                                    showConfirmationDialogWeb(context: context, title: LocaleKeys.keyDeleteNotification.localized,
                                                        dialogWidth:context.width*0.3 ,
                                                        message: LocaleKeys.keyDeleteAllNotificationMessage.localized,
                                                        didTakeAction: (status)
                                                        async{
                                                          if(status)
                                                          {
                                                            await notificationScreenWatch.deleteNotificationListAPI(context);
                                                            if(notificationScreenWatch.deleteNotificationListState.success?.status==ApiEndPoints.apiStatus_200 && context.mounted)
                                                            {
                                                              await notificationScreenWatch.notificationListAPI(context);
                                                            }
                                                          }
                                                        }
                                                    );

                                                  },
                                                  child: CommonText(
                                                    title: LocaleKeys.keyClearAll.localized,
                                                    textStyle: TextStyles.medium
                                                        .copyWith(fontSize: 16.sp, color: AppColors.black),
                                                  ).paddingSymmetric(vertical: 12.h, horizontal: 20.w),
                                                ),
                                              ],
                                            ),

                                            /// List
                                            SizedBox(
                                                height: context.height*0.35,
                                                child:
                                                notificationScreenWatch.notificationListState.isLoading
                                                    ?const Center(child: CircularProgressIndicator(color: AppColors.black171717,))
                                                    :notificationScreenWatch.isNotificationListEmpty()?
                                                Center(
                                                  child: EmptyStateWidget(
                                                    imgHeight: context.height*0.19,
                                                    imgWidth:  context.width*0.19,
                                                    title: LocaleKeys.keyNoNotification.localized,
                                                    imgName: Assets.svgs.svgNoData.keyName,
                                                  ),
                                                ):
                                                SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      ListView.builder(
                                                        itemCount:
                                                        notificationScreenWatch.notificationFilterList.length,
                                                        shrinkWrap: true,
                                                        physics: const BouncingScrollPhysics(),
                                                        itemBuilder: (context, index) {
                                                          var model =
                                                          notificationScreenWatch.notificationFilterList[index];
                                                          return NotificationHeaderTileListWeb(
                                                            model: model,
                                                            isFromHome: true,
                                                          ).paddingOnly(bottom: 15.h);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ),
                                            !notificationScreenWatch.notificationListState.isLoading && (notificationScreenWatch.notificationListState.success?.data?.isNotEmpty??false)?InkWell(
                                              onTap: (){
                                                Navigator.of(context).pop();
                                                ref.read(navigationStackController).push(const NavigationStackItem.notification());
                                              },
                                              child: CommonText(
                                                title: LocaleKeys.keyViewMore.localized,
                                                fontSize: 14.sp,
                                                textStyle: TextStyles.regular.copyWith(
                                                    color: AppColors.blue009AF1,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: AppColors.blue009AF1
                                                ),
                                              ).alignAtBottomRight().paddingOnly(top: 10.h),
                                            ):const Offstage(),
                                          ],
                                        ).paddingSymmetric(horizontal: 20.w);
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible:(notificationWatch.notificationUnReadCountState.success?.data??0)>0,
                            //visible:(notificationWatch.notificationUnReadCountState.success?.data??0)>0,
                            child: Container(
                              height: 20.h,
                              width: 20.w,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red
                              ),
                              child: CommonText(title:notificationWatch.notificationUnReadCountState.success?.data.toString()??'',
                                textStyle: TextStyles.regular.copyWith(color: AppColors.white,fontSize: 12.sp),),),
                          )
                        ],
                      );
                    }
                ),
              ],
            )
          ],
        ),
      ],
    ).paddingSymmetric( vertical: 19.h);
  }
}

class ActionIconWidget extends StatelessWidget {
  const ActionIconWidget({super.key, required this.icon, required this.onTap});

  final String icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return HoverAnimation(
      transformSize: 1.05,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: context.width * 0.05,
          height: context.height * 0.05,
          child: CommonSVG(
            strIcon: icon,
            width: context.width * 0.05,
            height: context.height * 0.05,
          ),
        ),
      ),
    );
  }
}
