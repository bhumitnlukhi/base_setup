import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/int_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/ticket_management_table_child.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/shimmer/common_master_shimmer.dart';

class AllTicketManagementList extends ConsumerStatefulWidget {
  const AllTicketManagementList({Key? key}) : super(key: key);

  @override
  ConsumerState<AllTicketManagementList> createState() =>
      _AllTicketManagementListState();
}

class _AllTicketManagementListState extends ConsumerState<AllTicketManagementList> {



  ///Init
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final ticketManagementWatch = ref.read(ticketManagementController);
      // await ticketManagementWatch.getCreatedTicketListApi(context);
      ticketManagementWatch.disposeController();
      ticketManagementWatch.ticketListApi(context, false);

      ticketManagementWatch.ticketListScrollController.addListener(() async{
        if (ticketManagementWatch.ticketListState.success?.hasNextPage == true) {
          if (ticketManagementWatch.ticketListScrollController.position.maxScrollExtent == ticketManagementWatch.ticketListScrollController.position.pixels) {
            if(!ticketManagementWatch.ticketListState.isLoadMore) {
              await ticketManagementWatch.ticketListApi(context,true,);
            }
          }
        }
      });
    });
  }

  ///Dispose
  @override
  void dispose() {
    super.dispose();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    final ticketManagementWatch = ref.watch(ticketManagementController);
    return /// List Widget
      FadeBoxTransition(
        child: ticketManagementWatch.ticketListState.isLoading ?
        const CommonListShimmer().paddingSymmetric(horizontal: context.width * 0.020) :
        ticketManagementWatch.ticketData.isEmpty?
        EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,title: LocaleKeys.keyNoDataFound.localized,):
        Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: ticketManagementWatch.ticketData.length,
                controller:ticketManagementWatch.ticketListScrollController,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final data =  ticketManagementWatch.ticketData[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.r),
                      ),
                      color: AppColors.clrF7F7FC,
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Table(
                        textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        columnWidths: const {

                          /// Ticket ID
                          // 0: FlexColumnWidth(2.89),
                        /// Date
                        0: FlexColumnWidth(4.1),
                      /// User Name
                      1: FlexColumnWidth(4.1),
                  /// Reason type
                  // 3: FlexColumnWidth(4.05),
                  /// Reason
                  2: FlexColumnWidth(5),
                  /// Status
                  3: FlexColumnWidth(6),
                  /// comments
                  4: FlexColumnWidth(3),

                  5: FlexColumnWidth(0.5),
                                              },
                        children: [
                          TableRow(
                            children: [
                              // TableChildWidget(text: (data?.id??'').toString(), textStyle: TextStyles.regular.copyWith(color: AppColors.blue0083FC, fontSize: 15.sp)).paddingOnly(left: context.width*0.0134),
                              TableChildWidget(text: dateFormatFromDateTime(((data?.createdAt ?? 0).milliSecondsToDateTime()), dateFormat), textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 15.sp)).paddingOnly(left: context.width*0.0134),
                              TableChildWidget(text: data?.name??'' ,textStyle: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 15.sp)).paddingOnly(right:  context.width*0.01),
                              // TableChildWidget(text: data?.userType??'', textStyle: TextStyles.regular.copyWith(color: AppColors.blue0083FC, fontSize: 15.sp)),
                              TableChildWidget(text: data?.ticketReason??'', textStyle: TextStyles.regular.copyWith(color: AppColors.blue0083FC, fontSize: 15.sp)),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(context.height * 0.030),
                                        border: Border.all(color: data?.ticketStatus == TicketStatus.PENDING.name ? AppColors.redFF0000 :
                                        data?.ticketStatus == TicketStatus.ACKNOWLEDGED.name ?  AppColors.orangeEE7700 : AppColors.black )
                                    ),
                                    height: context.height*0.060,
                                    child: Center(
                                        child: CommonText(
                                            title: data?.ticketStatus??'',
                                            textStyle: TextStyles.regular.copyWith(
                                                color: data?.ticketStatus == TicketStatus.PENDING.name ? AppColors.redFF0000 :
                                                data?.ticketStatus == TicketStatus.ACKNOWLEDGED.name ?  AppColors.orangeEE7700 : AppColors.black ,
                                                fontSize: 15.sp
                                            )
                                        ).paddingSymmetric(horizontal: context.width * 0.020)
                                    ),
                                  ).paddingOnly(right: context.width*0.01),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  ref.read(navigationStackController).pushRemove(NavigationStackItem.ticketManagement(ticketUuid: data?.uuid));
                                  if (data?.uuid != null) {
                                    ticketManagementWatch.showTicketDetailDialog(context, ref, ticketUuid: data?.uuid??'');
                                  }

                                },
                                child: CommonSVG(strIcon: Assets.svgs.svgInfo2.keyName, height: context.height*0.035).alignAtCenter(),
                              ),
                              const Offstage()
                            ],
                          ),
                        ],
                      ).paddingOnly( top: 13.h, bottom: 13.h),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: context.height * 0.022,
                  );
                },
              ).paddingOnly(bottom: context.height * 0.005, right: context.width*0.020, left: context.width*0.020),
            ),
            DialogProgressBar(isLoading: ticketManagementWatch.ticketListState.isLoadMore, forPagination: true,)
          ],
        )
      );
  }

}
