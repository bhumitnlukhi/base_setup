import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/datetime_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/int_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:readmore/readmore.dart';

class TicketDetailDialog extends ConsumerWidget with BaseConsumerWidget {
  const TicketDetailDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget buildPage(BuildContext context, ref) {
    final ticketManagementWatch = ref.watch(ticketManagementController);
    final ticketDetailData = ticketManagementWatch.ticketDetailState.success?.data;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CommonText(
                  title: LocaleKeys.keyTicket.localized,
                  fontSize: 20.sp,
                  clrfont: AppColors.black,
                ),
              ),
              InkWell(
                onTap: () {
                  ref.read(navigationStackController).pushRemove(const NavigationStackItem.ticketManagement());
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CommonSVG(strIcon: Assets.svgs.svgClose.keyName),
                ),
              )
            ],
          ),
          SizedBox(
            height: context.height * 0.020,
          ),
          Row(
            children: [
              Container(width: context.width * 0.040, height: context.height * 0.075, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r), color: AppColors.black1A1A1A), padding: EdgeInsets.only(top: context.height * 0.020, bottom: context.height * 0.020, left: context.width * 0.005, right: context.width * 0.005), child: CommonSVG(strIcon: Assets.svgs.svgTicketManagement.keyName, width: context.width * 0.002, height: context.height * 0.002)).paddingOnly(right: context.width * 0.020),
              Expanded(
                  child: CommonText(
                title: ticketDetailData?.name ?? '',
                textStyle: TextStyles.regular,
              )),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: context.width * 0.020),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                          color: ticketDetailData?.ticketStatus == ticketStatus.PENDING.name
                              ? AppColors.redFF0000
                              : ticketDetailData?.ticketStatus == ticketStatus.ACKNOWLEDGED.name
                                  ? AppColors.orangeEE7700
                                  : AppColors.black)),
                  height: context.height * 0.060,
                  child: Center(
                      child: CommonText(
                          title: ticketDetailData?.ticketStatus ?? '',
                          textStyle: TextStyles.regular.copyWith(
                              color: ticketDetailData?.ticketStatus == ticketStatus.PENDING.name
                                  ? AppColors.redFF0000
                                  : ticketDetailData?.ticketStatus == ticketStatus.ACKNOWLEDGED.name
                                      ? AppColors.orangeEE7700
                                      : AppColors.black,
                              fontSize: 12.sp))),
                ),
              )
            ],
          ),
          SizedBox(
            height: context.height * 0.020,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    title: LocaleKeys.keyTicketID.localized,
                    textStyle: TextStyles.regular.copyWith(color: AppColors.grey4B465C14),
                  ),
                  SizedBox(
                    height: context.height * 0.010,
                  ),
                  CommonText(
                    title: (ticketDetailData?.uuid ?? '-').toString(),
                    textStyle: TextStyles.regular.copyWith(color: AppColors.black),
                  ),
                ],
              ),
              SizedBox(
                width: context.width * 0.050,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    title: LocaleKeys.keyDate.localized,
                    textStyle: TextStyles.regular.copyWith(color: AppColors.grey4B465C14),
                  ),
                  SizedBox(
                    height: context.height * 0.010,
                  ),
                  CommonText(
                    title: dateFormatFromDateTime(((ticketDetailData?.createdAt ?? 0).milliSecondsToDateTime()), dateFormat),
                    textStyle: TextStyles.regular.copyWith(color: AppColors.black),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: context.height * 0.030,
          ),
          Divider(
            height: context.height * 0.010,
            color: AppColors.grey4B465C14,
          ),
          SizedBox(
            height: context.height * 0.030,
          ),
          ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Visibility(
                  visible: index == 0
                      ? (ticketDetailData?.description != null)
                          ? true
                          : false
                      : index == 1
                          ? (ticketDetailData?.acknowledgeComment != null)
                              ? true
                              : false
                          : index == 2
                              ? (ticketDetailData?.resolveComment != null)
                                  ? true
                                  : false
                              : false,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteF7F7FC,
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: context.height * 0.02, horizontal: context.height * 0.02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            CommonSVG(strIcon: Assets.svgs.svgUser1.keyName),
                            SizedBox(
                              height: context.height * 0.010,
                            ),
                            CommonText(
                              title: index == 0 ? "You" : '',
                              textStyle: TextStyles.regular.copyWith(color: AppColors.grey4B465C14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: context.width * 0.015,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReadMoreText(
                                index == 0
                                    ? (ticketDetailData?.description ?? '-')
                                    : index == 1
                                        ? (ticketDetailData?.acknowledgeComment ?? '-')
                                        : index == 2
                                            ? (ticketDetailData?.resolveComment ?? '-')
                                            : '-',
                                style: TextStyles.regular,
                                trimLines: 2,
                                colorClickableText: Colors.blue,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Read More',
                                trimExpandedText: 'Read Less',
                              ),
                              // CommonText(
                              //   title: index == 0
                              //       ? (ticketDetailData?.description ?? '-')
                              //       : index == 1
                              //           ? (ticketDetailData?.acknowledgeComment ?? '-')
                              //           : index == 2
                              //               ? (ticketDetailData?.resolveComment ?? '-')
                              //               : '-',
                              //   textStyle: TextStyles.regular,
                              //   maxLines: 3,
                              // ),
                              SizedBox(
                                height: context.height * 0.010,
                              ),
                              CommonText(
                                title: index == 0
                                    ? ('${DateTime.fromMillisecondsSinceEpoch(ticketDetailData?.createdAt ?? 0).dateOnly} ${DateTime.fromMillisecondsSinceEpoch(ticketDetailData?.createdAt ?? 0).timeOnly}')
                                    : index == 1
                                        ? ('${DateTime.fromMillisecondsSinceEpoch(ticketDetailData?.acknowledgedDate ?? 0).dateOnly} ${DateTime.fromMillisecondsSinceEpoch(ticketDetailData?.acknowledgedDate ?? 0).timeOnly}')
                                        : index == 2
                                            ? ('${DateTime.fromMillisecondsSinceEpoch(ticketDetailData?.resolvedDate ?? 0).dateOnly} ${DateTime.fromMillisecondsSinceEpoch(ticketDetailData?.resolvedDate ?? 0).timeOnly}')
                                            : '-',
                                textStyle: TextStyles.regular.copyWith(color: AppColors.grey4B465C14),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ).paddingOnly(bottom: context.height * 0.030),
                );
              })
        ],
      ).paddingAll(context.height * 0.040),
    );
  }
}
