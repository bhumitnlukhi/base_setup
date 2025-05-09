import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/ui/utils/anim/animation_extension.dart';
import 'package:odigo_vendor/ui/utils/anim/custom_animation_controller.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class AverageTimeStoreGraph extends ConsumerStatefulWidget {
  const AverageTimeStoreGraph({Key? key}) : super(key: key);

  @override
  ConsumerState<AverageTimeStoreGraph> createState() => _AverageTimeStoreGraphState();
}

class _AverageTimeStoreGraphState extends ConsumerState<AverageTimeStoreGraph> with BaseStatefulWidget, TickerProviderStateMixin {
  List<AnimationController> barGraphAnimationControllerList = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final customAnimationWatch = ref.watch(customAnimationController);
      final dashBoardWatch = ref.watch(dashboardController);

      barGraphAnimationControllerList = List.generate(dashBoardWatch.monthGraphDataList.length, (index) => AnimationController(vsync: this, duration: const Duration(milliseconds: 150)));
      customAnimationWatch.notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
    });
  }

  @override
  void dispose() {
    for (var element in barGraphAnimationControllerList) {
      element.stop();
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    return  barGraphAnimationControllerList.isNotEmpty
        ? Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(
              right: 20.sp,
              left: 0,
              top: 30.h,
            ),
            child: BarChart(
              BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.white,
                      tooltipRoundedRadius: 6.r,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          (rod.toY).abs().toString().split('.').first,
                          TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        );
                      },
                      tooltipBorder: const BorderSide(color: Colors.grey),
                      fitInsideHorizontally: true,
                      tooltipHorizontalAlignment: FLHorizontalAlignment.center,
                    ),
                    enabled: true,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 30,
                        getTitlesWidget: bottomTitles,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval:/* dashboardWatch.dashboardSalesReportState.isLoading ? 100 :*/ ((dashboardWatch.monthGraphDataList.map((e) => e).toList().max + 100)/4).round().toDouble(),
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: Colors.grey,
                      strokeWidth: 0.2,
                    ),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: true, border: const Border(bottom: BorderSide(color: Colors.grey))),
                  groupsSpace: 10,
                  barGroups: getDataStatic(),
                  maxY:/* dashboardWatch.dashboardSalesReportState.isLoading ? 16000 : */ dashboardWatch.monthGraphDataList.map((e) => e).toList().max + 100,
                  backgroundColor: AppColors.transparent),
              swapAnimationCurve: Curves.linear,
              swapAnimationDuration: const Duration(milliseconds: 750),
            ),
          ),
        ),
      ],
    )
        : const Offstage();
  }

  /// List of the data for the Graph
  List<BarChartGroupData> getDataStatic() {
    final dashBoardWatch = ref.watch(dashboardController);

    return [
      ...List.generate(
        dashBoardWatch.monthGraphDataList.length,
            (index) {
          final customAnimationWatch = ref.watch(customAnimationController);
          if (barGraphAnimationControllerList[index].isDisposed == false) {
            barGraphAnimationControllerList[index].forward();
            barGraphAnimationControllerList[index].addListener(() {
              customAnimationWatch.notifyListeners();
            });
          }
          return BarChartGroupData(
            x: index,
            barsSpace: 4,
            groupVertically: false,
            barRods: [
              barChartData(dashBoardWatch.monthGraphDataList.map((e) => e).toList()[index] * (barGraphAnimationControllerList[index].value)),
            ],
          );
        },
      )
    ];
  }

  barChartData(double toYValue) {
    ref.watch(dashboardController);
    return BarChartRodData(
      toY: toYValue,
      width: 5.w,
      // color: AppColors.clrFF5858,
      gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
        AppColors.primary2,
        AppColors.whiteFAFDFF
      ]),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(6.r), topRight: Radius.circular(6.r)),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final dashBoardWatch = ref.watch(dashboardController);

    TextStyle style = TextStyles.medium.copyWith(fontSize: 12.sp, color: Colors.grey);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(dashBoardWatch.xTitles[value.toInt()], style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyles.medium.copyWith(fontSize: 12.sp, color: Colors.grey);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text('${value.abs().toStringAsFixed(0)} ', style: style),
    );
  }
}
