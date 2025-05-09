import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_background_widget.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/robot_filter_widget.dart';
import 'package:odigo_vendor/ui/utils/anim/animation_extension.dart';
import 'package:odigo_vendor/ui/utils/anim/custom_animation_controller.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/custom_date_picker.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';

class UptimeReportChart extends ConsumerWidget with BaseConsumerWidget{
  const UptimeReportChart({super.key});

  @override
  Widget buildPage(BuildContext context,ref) {
    // final dashboardWatch = ref.watch(dashboardController);
    return FadeBoxTransition(
      child: CommonBackGroundWidget(
        height: context.height*0.704,
        backGroundColor: AppColors.white,
        content: PieChartOrderUptime(
          pieChartList: [
            CustomPieChartDataUptime(
                value: 11.8,
                color: AppColors.pinkFF7777,

                title: 'Emergency'),
            ///Total Earnings of agency  + Total earnings of client
            CustomPieChartDataUptime(
                value: 64.7,
                color: AppColors.green00AE14,
                title: 'Uptime'),

            CustomPieChartDataUptime(
                value: 23.5,
                color: AppColors.yellowFFD700,
                title: 'Charging'),
          ],
        ),
      ),
    );
  }
}

class PieChartOrderUptime extends ConsumerStatefulWidget {
  final List<CustomPieChartDataUptime> pieChartList;

  const PieChartOrderUptime({super.key, required this.pieChartList});

  @override
  ConsumerState<PieChartOrderUptime> createState() => PieChartOrderState();
}

class PieChartOrderState extends ConsumerState<PieChartOrderUptime> with TickerProviderStateMixin {
  List<AnimationController> pieChartAnimationControllerList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final customAnimationWatch = ref.watch(customAnimationController);
      pieChartAnimationControllerList = List.generate(widget.pieChartList.length, (index) => AnimationController(vsync: this, duration: const Duration(milliseconds: 500)));
      customAnimationWatch.notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
    });
  }

  @override
  void dispose() {
    for (var element in pieChartAnimationControllerList) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    final storeWatch = ref.watch(storesController);
    return pieChartAnimationControllerList.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              title: LocaleKeys.keyUptimeReportsDay.localized,
              textStyle: TextStyles.bold.copyWith(color: AppColors.clr11263C, fontSize: 18.sp),
            ),
            Container (
              decoration: BoxDecoration(color: AppColors.whiteF7F7FC,borderRadius: BorderRadius.circular(24.r)),
              child: Row(
                children: [
                  Container(
                    height: 10.h,
                    width: 10.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green00AE14 ,
                    ),
                  ).paddingOnly(right: 5.w),
                  CommonText(
                    title: 'Uptime',
                    textStyle: TextStyles.medium.copyWith(color: AppColors.black.withOpacity(0.5), fontSize: 12.sp),
                  ),
                  SizedBox(width: 10.w,),
                  Container(
                    height: 10.h,
                    width: 10.w,
                    decoration:  const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.pinkFF7777 ,
                    ),
                  ).paddingOnly(right: 5.w),
                  CommonText(
                    title: 'Emergency',
                    textStyle: TextStyles.medium.copyWith(color: AppColors.black.withOpacity(0.5), fontSize: 12.sp),
                  ),
                  SizedBox(width: 10.w,),
                  Container(
                    height: 10.h,
                    width: 10.w,
                    decoration:  const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.yellowFFD700 ,
                    ),
                  ).paddingOnly(right: 5.w),
                  CommonText(
                    title: 'Charging',
                    textStyle: TextStyles.medium.copyWith(color: AppColors.black.withOpacity(0.5), fontSize: 12.sp),
                  ),
                ],
              ).paddingAll(12.h),
            )
          ],
        ),

        SizedBox(height: 10.h,),
        /// Filter widgets
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r,),
                  border: Border.all(color: AppColors.grayA5A5A5)
              ),
              child: Row(
                children: [
                  TableHeaderTextWidget(
                    text: storeWatch.selectedStoreData == null ? LocaleKeys.keyRobot.localized : storeWatch.selectedStoreData?.name ?? '',textStyle: TextStyles.medium.copyWith(fontSize: 14.sp,color: AppColors.grey8D8C8C),),
                  SizedBox(
                    width: context.height*0.01,
                  ),
                  RobotFilterWidget(
                    controller: dashboardWatch.tooltipControllerCategoryRobot,
                    onTap: () async {
                      showLog(storeWatch.selectedStoreData?.name ?? '');
                      // dashboardWatch.updateDestination(destinationWatch.selectedDestination);
                      // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                    },
                  ),

                ],
              ).paddingSymmetric(vertical: 5.h,horizontal: 10.w),
            ).paddingOnly(right: 20.w),

            /// Date Picker
            Consumer(builder: (context, ref, child) {
              final ticketManagementWatch = ref.watch(ticketManagementController);
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      /// Start Date Calender Picker
                      showCommonWebDialog(
                          keyBadge: ticketManagementWatch.startDateDialogKey,
                          width: 0.5,
                          // height:0.5,
                          context: context, dialogBody: CustomDatePicker(
                        selectDateOnTap: true,

                        bubbleDirection: true,
                        bubbleColor: AppColors.white,
                        initialDate: ticketManagementWatch.startDate,
                        firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 365),
                        lastDate: DateTime.now(),
                        getDateCallback: (DateTime? selectedDate, {bool? isOkPressed}) {
                          ticketManagementWatch.updateStartEndDate(true, selectedDate);
                          // = DateFormat('dd/MM/yyyy').format(selectedDate ?? DateTime.now());
                        },
                        onOkTap: () {
                          ticketManagementWatch.clearEndDate();
                          // updateIsDatePickerVisible();
                          // orderListWatch.updateIsDatePickerVisible(false);
                        },
                        onCancelTap: () {
                          // updateIsDatePickerVisible();
                          // orderListWatch.updateIsDatePickerVisible(false);
                        },
                      ));
                    },
                    child: Container(
                      height: context.height*0.05,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.lightPinkF7F7FC),
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 20.h,
                          ),
                          if(ticketManagementWatch.startDate != null)
                            Row(
                              children: [
                                SizedBox(
                                  width: context.width*0.010,
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: CommonText(
                                    title: dateFormatFromDateTime(ticketManagementWatch.startDate, 'dd/MM/yyyy'),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ).paddingSymmetric(horizontal: context.width*0.007),
                    ),
                  ),
                  Visibility(visible: ticketManagementWatch.startDateError != null, child: CommonText(title: ticketManagementWatch.startDateError.toString(), textStyle: TextStyles.regular.copyWith(color: AppColors.red), maxLines: 3,))
                ],
              );
            }).paddingOnly(right: 20.w),

            Container(
              height: context.height*0.04,
              decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20.r)),
              child: Row(
                children: [
                  Icon(Icons.refresh_outlined,color: Colors.white,size: 16.h,).paddingOnly(right: 6.w),
                  CommonText(title: 'Reset',textStyle: TextStyles.regular.copyWith(color: Colors.white,fontSize: 12.sp),)
                ],
              ).paddingSymmetric(horizontal: 10.w),
            ),

          ],
        ),

        /// Pie Chart
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        borderData: FlBorderData(
                          show: true,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 80.r,
                        sections: showingSections(),
                      ),
                    ),
                    PieChart(
                      PieChartData(
                        borderData: FlBorderData(
                          show: true,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 100.r,
                        sections: [
                          PieChartSectionData(
                            color: AppColors.greyF7F7F7,
                            showTitle: false,
                            value: (1) * (1 - pieChartAnimationControllerList[0].value),
                            radius: 20.r,
                            titleStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainTextColor1,
                              shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer(
                              builder: (context, ref, child) {
                                // final homeWatch = ref.watch(homeController);
                                return CommonText(
                                  title: '9 Hr',
                                  textStyle: TextStyles.semiBold.copyWith(color: AppColors.black, fontSize: 40.sp),
                                ).paddingOnly(bottom: 10.h);
                              }
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
          
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                    widget.pieChartList.length,
                        (index) =>  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              title: widget.pieChartList[index].title,
                              textStyle: TextStyles.regular.copyWith(color: AppColors.black171717,fontSize: 14.sp),
                            ),
                            CommonText(
                              title: ": ${widget.pieChartList[index].value.toStringAsFixed(0)}%",
                              textStyle: TextStyles.regular.copyWith(color: AppColors.black171717,fontSize: 14.sp),
                            )
                          ],
                        ).paddingSymmetric(vertical: 10.h)
                  ),
                ],
              ),
              const Spacer()
            ],
          ),
        )
      ],
    )
        : const Offstage();
  }

  /// List of the Data
  List<PieChartSectionData> showingSections() {
    return List.generate(
      (widget.pieChartList.length),
          (index) {
        final radius = 30.r;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
        final customAnimationWatch = ref.watch(customAnimationController);
        if (pieChartAnimationControllerList[index].isDisposed == false) {
          pieChartAnimationControllerList[index].forward();
          pieChartAnimationControllerList[index].addListener(() {
            customAnimationWatch.notifyListeners();
          });
        }
        return PieChartSectionData(
          color: widget.pieChartList[index].color,
          showTitle: false,
          value: (widget.pieChartList[index].value) * (pieChartAnimationControllerList[index].value),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        );
      },
    );
  }
}

class CustomPieChartDataUptime {
  final double value;
  final String title;
  final Color color;

  CustomPieChartDataUptime({required this.value, required this.color, required this.title});
}