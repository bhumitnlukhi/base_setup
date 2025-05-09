import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_background_widget.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_dashboard_dropdown.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class MostRequestedStoreChart extends ConsumerStatefulWidget {
  const MostRequestedStoreChart({Key? key}) : super(key: key);

  @override
  ConsumerState<MostRequestedStoreChart> createState() => _MostRequestedStoreChartState();
}

class _MostRequestedStoreChartState extends ConsumerState<MostRequestedStoreChart> {
  ///Init
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  ///Dispose
  @override
  void dispose() {
    super.dispose();
  }

  ///Build
  @override
  Widget build(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    // final storeWatch = ref.watch(storeController);

    return  FadeBoxTransition(
      child: CommonBackGroundWidget(
        // height: context.height * 0.704,
        backGroundColor: AppColors.white,

        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: context.height * 0.01,
            ),
            CommonText(
              title: LocaleKeys.keyMostRequestedStore.localized,
              textStyle: TextStyles.bold.copyWith(color: AppColors.clr11263C, fontSize: 18.sp),
            ),
            SizedBox(
              height: context.height * 0.01,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r,),
                        border: Border.all(color: AppColors.grayA5A5A5)
                    ),
                    child: const Row(
                      children: [
                        // TableHeaderTextWidget(
                        //   text: storeWatch.selectedStoreData == null ? LocaleKeys.keyCategoryName.localized : storeWatch.selectedStoreData?.name ?? '',textStyle: TextStyles.medium.copyWith(fontSize: 14.sp,color: AppColors.grey8D8C8C),),
                        // SizedBox(
                        //   width: context.height*0.01,
                        // ),
                        // CategoryFilterWidget(
                        //   controller: dashboardWatch.tooltipControllerCategory,
                        //   onTap: () async {
                        //     showLog(storeWatch.selectedStoreData?.name ?? '');
                        //     // dashboardWatch.updateDestination(destinationWatch.selectedDestination);
                        //     // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                        //   },
                        // ),
                      ],
                    ).paddingSymmetric(vertical: 5.h,horizontal: 10.w),
                  ).paddingOnly(right: 20.w),

              CommonDropdownDashboard(
                menuItems: monthDynamicList,
                onTap: (id) async {
                  dashboardWatch.updateMonthYear(monthDynamicList[id]);
                  // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                },
                selectedIndex: dashboardWatch.selectedMonth != null ? monthDynamicList.indexWhere((e) => e == dashboardWatch.selectedMonth) : null,
                isFrontWidgetRequired: true,
                isColorIndicatorRequired: true,
                frontWidget: CommonText(
                  title: LocaleKeys.keyMonth.localized,
                  textStyle: TextStyles.regular.copyWith(color: AppColors.grey8F8F8F, fontSize: 16.sp),
                ),
              ).paddingOnly(right: 20.w),

              /// Year dropdown
              CommonDropdownDashboard(
                menuItems: dashboardWatch.yearsDynamicList,
                onTap: (id) async {
                  dashboardWatch.updateYearIndex(context, id);
                  // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                },
                selectedIndex: dashboardWatch.selectedYearIndex,
                isFrontWidgetRequired: true,
                isColorIndicatorRequired: true,
                frontWidget: CommonText(
                  title: LocaleKeys.keyYear.localized,
                  textStyle: TextStyles.regular.copyWith(color: AppColors.grey8F8F8F, fontSize: 16.sp),
                ),
              ).paddingOnly(right: 20.w),

                  Container(
                    height: context.height*0.04,
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20.r)),
                    child: Row(
                      children: [
                        Icon(Icons.refresh_outlined,color: Colors.white,size: 16.h,).paddingOnly(right: 6.w),
                        CommonText(title: 'Reset',textStyle: TextStyles.regular.copyWith(color: Colors.white,fontSize: 12.sp),)
                      ],
                    ).paddingSymmetric(horizontal: 10.w),
                  )
            ]),
            SizedBox(
              height: context.height * 0.01,
            ),
             Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CommonText(
                    title: 'Sr. No',
                    textStyle: TextStyles.medium.copyWith(fontSize: 14.sp,color: AppColors.black.withOpacity(0.62)),
                  ),
                ),
                SizedBox(
                  width: context.height * 0.036,
                ),
                Expanded(
                  child: CommonText(
                    title: 'Ad Count',
                    textStyle: TextStyles.medium.copyWith(fontSize: 14.sp,color: AppColors.black.withOpacity(0.62)),

                  ),
                ),
                SizedBox(
                  width: context.height * 0.036,
                ),
                Expanded(
                  flex: 4,
                  child: CommonText(
                    title: 'Store Name',
                    textStyle: TextStyles.medium.copyWith(fontSize: 16.sp,color: AppColors.black.withOpacity(0.62)),

                  ),
                ),
              ],
            ),

            SizedBox(
              height: context.height * 0.01,
            ),
            SizedBox(
              height: 350.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      100,
                          (index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(width: 1.5, color: AppColors.white495B6E.withOpacity(0.20)),
                                    // bottom: BorderSide(width: 1.5, color: AppColors.white495B6E.withOpacity(0.20)),
                                  ),
                                ),
                                child: CommonText(title: "${index + 1}",
                                  textStyle: TextStyles.medium.copyWith(fontSize: 15.sp,color: AppColors.black),
                                ).paddingSymmetric(vertical: 16.h),
                              ),
                            ),
                            SizedBox(
                              width: context.height * 0.036,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(width: 1.5, color: AppColors.white495B6E.withOpacity(0.20)),
                                    // bottom: BorderSide(width: 1.5, color: AppColors.white495B6E.withOpacity(0.20)),
                                  ),
                                ),
                                child: CommonText(
                                  title: "${index * 1.5}",
                                  textStyle: TextStyles.medium.copyWith(fontSize: 15.sp,color: AppColors.black),
                                ).paddingSymmetric(vertical: 16.h),
                              ),
                            ),
                            SizedBox(
                              width: context.height * 0.036,
                            ),
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(width: 1.5, color: AppColors.white495B6E.withOpacity(0.20)),
                                    // bottom: BorderSide(width: 1.5, color: AppColors.white495B6E.withOpacity(0.20)),
                                  ),
                                ),
                                child: CommonText(
                                  title: 'Store Name',
                                  textStyle: TextStyles.medium.copyWith(fontSize: 15.sp,color: AppColors.black),
                                ).paddingSymmetric(vertical: 16.h),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
