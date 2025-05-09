import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/common_background_widget.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/store_filter_widget.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/table_header_text_widget_master.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ShopperStoreChart extends ConsumerWidget with BaseConsumerWidget{
  const ShopperStoreChart({super.key});

  @override
  Widget buildPage(BuildContext context,ref) {
    final dashboardWatch = ref.watch(dashboardController);
    final storeWatch = ref.watch(storesController);
    return  Column(
          children: [
            FadeBoxTransition(
              child: CommonBackGroundWidget(
                height: context.height*0.704,
                backGroundColor: AppColors.white,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: context.height*0.01,
                    ),
                    CommonText(
                      title: LocaleKeys.keyShopperStoreTitle.localized,
                      textStyle: TextStyles.bold.copyWith(color: AppColors.clr11263C, fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: context.height*0.02,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r,),
                        border: Border.all(color: AppColors.grayA5A5A5)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                              child: TableHeaderTextWidget(
                                  text: storeWatch.selectedStoreData == null ? LocaleKeys.keyStoreName.localized : storeWatch.selectedStoreData?.name ?? '',textStyle: TextStyles.medium.copyWith(fontSize: 14.sp,color: AppColors.grey8D8C8C),)),
                          SizedBox(
                            width: context.height*0.01,
                          ),
                          StoreFilterWidget(
                            controller: dashboardWatch.tooltipControllerStore,
                            onTap: () async {
                              showLog(storeWatch.selectedStoreData?.name ?? '');
                              // dashboardWatch.updateDestination(destinationWatch.selectedDestination);
                              // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                            },
                          ),
                        ],
                      ).paddingSymmetric(vertical: 5.h,horizontal: 10.w),
                    ),
                    SizedBox(
                      height: context.height*0.15,
                    ),
                    SizedBox(
                      height: context.height * 0.3,
                      // width: context.width * 0.25,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            showLabels: false,
                            pointers: <GaugePointer>[
                              RangePointer(
                                value: 70,
                                cornerStyle: CornerStyle.bothCurve,
                                width: 0.3,
                                sizeUnit: GaugeSizeUnit.factor,
                                // color: AppColors.black,
                                gradient: SweepGradient(colors: [
                                  AppColors.primary2,
                                  AppColors.primary2,
                                  AppColors.primary2,
                                  AppColors.primary2.withOpacity(0.5)
                                ]),
                              )
                            ],
                            showTicks: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.3,
                              cornerStyle: CornerStyle.bothCurve,
                              color: AppColors.black.withOpacity(0.2),
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                positionFactor: 0.1,
                                angle: 90,
                                widget: Text(
                                  '${60.toStringAsFixed(0)}%',
                                  style: TextStyles.bold.copyWith(fontSize: 16.sp,color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: context.height*0.01,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
  }
}
