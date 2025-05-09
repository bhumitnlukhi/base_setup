import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/framework/controller/notification/notification_screen_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/dashboard_left_data.dart';
import 'package:odigo_vendor/ui/dashboard/web/helper/dashboard_right_data.dart';
import 'package:odigo_vendor/ui/dashboard/web/shimmer/dashboard_shimmer.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_appbar_web.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_functions.dart';

class DashboardWeb extends ConsumerStatefulWidget {
  const DashboardWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardWeb> createState() => _DashboardWebState();
}

class _DashboardWebState extends ConsumerState<DashboardWeb> with  BaseConsumerStatefulWidget , BaseDrawerPageWidget {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {

      final dashboardWatch = ref.read(dashboardController);
      final notificationWatch = ref.watch(notificationScreenController);
      dashboardWatch.disposeController(isNotify : true);
      if(mounted){
        await notificationWatch.notificationUnReadCountAPI(context);
        if(notificationWatch.notificationUnReadCountState.success?.status ==ApiEndPoints.apiStatus_200 ){
          if(mounted){
            await dashboardWatch.vendorDashboardApi(context);
            if(dashboardWatch.vendorDashboardState.success?.status == ApiEndPoints.apiStatus_200){
              if(Session.getOldFCMToken().isEmpty && Session.getNewFCMToken().isNotEmpty){
                if(mounted){
                  await dashboardWatch.registerDeviceFcmToken(context);
                  await Session.saveLocalData(keyOldFCMToken, Session.getNewFCMToken());
                }

              }else if(Session.getNewFCMToken().isNotEmpty &&(Session.getNewFCMToken() != Session.getOldFCMToken())){
                if(mounted){
                  await dashboardWatch.registerDeviceFcmToken(context);
                  await Session.saveLocalData(keyOldFCMToken, Session.getNewFCMToken());
                }

              }
              if(Session.getDeviceID().isEmpty){
                await getDeviceIdPlatformWise();
              }
            }
          }
        }
      }
      if(dashboardWatch.registerDeviceState.success?.status == ApiEndPoints.apiStatus_200){

      }
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
    return  _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final dashboardWatch = ref.watch(dashboardController);
    final notificationWatch = ref.watch(notificationScreenController);
    // final storeWatch = ref.watch(storesController);
    return  GestureDetector(
      onTap: () {
        dashboardWatch.tooltipController.hide();
        dashboardWatch.tooltipControllerCategory.hide();
        dashboardWatch.tooltipControllerStore.hide();
        dashboardWatch.tooltipControllerCategoryWeekend.hide();
        dashboardWatch.tooltipControllerStoreWeekend.hide();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const CommonAppBarWeb(),

          SizedBox(
            height: context.height*0.02,
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  dashboardWatch.vendorDashboardState.isLoading || dashboardWatch.registerDeviceState.isLoading || notificationWatch.notificationUnReadCountState.isLoading ?
                  const DashboardShimmer()
                      :Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// Left Data
                          Expanded(
                            child: const DashboardLeftData().paddingOnly(right: 19.w),
                          ),

                          /// Right Data
                          const Expanded(
                              child: DashboardRightData()),
                        ],
                      ),


                   ///TODO uncomment when needed graph design
                   ///Average time reach graph
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: 16.h,
                  //     ),
                  //     SizedBox(
                  //       height: context.height * 0.5,
                  //       width: context.width,
                  //       child: CommonBackGroundWidget(
                  //         backGroundColor: AppColors.white,
                  //         content: FadeBoxTransition(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               /// Title total sales
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   CommonText(
                  //                     title: LocaleKeys.keyAvgTimeReachStore.localized,
                  //                     textStyle: TextStyles.bold.copyWith(
                  //                       color: AppColors.clr11263C,
                  //                       fontSize: 18.sp,
                  //                     ),
                  //                   ),
                  //                   InkWell(
                  //                     onTap: (){
                  //                       dashboardWatch.disposeGraphData();
                  //                       // destinationWatch.updateSelectedDestination(null);
                  //                       dashboardWatch.updateYearIndex(context, dashboardWatch.yearsDynamicList.indexWhere((element) => element == DateTime.now().year.toString()));
                  //                     },
                  //                     child: Visibility(
                  //                       visible: dashboardWatch.selectedMonth!=null ||  dashboardWatch.selectedYear != DateTime.now().year.toString() || dashboardWatch.selectedDestination!=null || dashboardWatch.selectedEntity!=null,
                  //                       child: CommonText(
                  //                         title: LocaleKeys.keyClearFilters.localized,
                  //                         textStyle: TextStyles.regular.copyWith(
                  //                           decoration: TextDecoration.underline,
                  //                           decorationColor: AppColors.blue009AF1,
                  //                           fontSize: 13.sp,
                  //                           color: AppColors.blue009AF1,
                  //                         ),
                  //                       ).alignAtCenterRight(),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Row(
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     children: [
                  //                       // Row(
                  //                       //   children: [
                  //                       //     TableHeaderTextWidget(text: dashboardWatch.selectedDestination?.name ?? LocaleKeys.keyDestination.localized),
                  //                       //     SizedBox(width: 10.w),
                  //                       //     DestinationFilterWidget(
                  //                       //       controller: dashboardWatch.tooltipController,
                  //                       //       onTap: () async {
                  //                       //         dashboardWatch.updateDestination(destinationWatch.selectedDestination);
                  //                       //         dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                       //       },
                  //                       //     )
                  //                       //   ],
                  //                       // ).paddingOnly(right: 20.w),
                  //                       // CommonDropdownDashboard(
                  //                       //   // menuItems: dashboardWatch.entityType.map((e) => e == 'Client_Master' ? 'Client' : e).toList(),
                  //                       //   menuItems: dashboardWatch.entityType.where((tab) => tab.havePermission == true).toList().map((tab) => tab.tabName)  // Extract tab names
                  //                       //       .toList().map((e) => e == 'Client_Master' ? 'Client' : e).toList(),
                  //                       //   onTap: (id) async {
                  //                       //     print(dashboardWatch.entityType[id].toString());
                  //                       //     dashboardWatch.updateEntity(dashboardWatch.entityType.where((e)=>e.havePermission).toList()[id].tabName);
                  //                       //     // dashboardWatch.updateEntity(dashboardWatch.entityType[id]);
                  //                       //     await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                       //   },
                  //                       //   selectedIndex: dashboardWatch.selectedEntity!=null ? (dashboardWatch.entityType.where((tab) => tab.havePermission == true).toList()).indexWhere((e)=>e.tabName.allInCaps==dashboardWatch.selectedEntity?.allInCaps): null,
                  //                       //   isFrontWidgetRequired: true,
                  //                       //   isColorIndicatorRequired: true,
                  //                       //   frontWidget: CommonText(
                  //                       //     title: LocaleKeys.keyEntity.localized,
                  //                       //     textStyle: TextStyles.regular.copyWith(
                  //                       //         color: AppColors.grey8F8F8F,
                  //                       //         fontSize: 16.sp
                  //                       //     ),
                  //                       //   ),
                  //                       // ).paddingOnly(right: 20.w),
                  //                       CommonDropdownDashboard(
                  //                         menuItems: monthDynamicList,
                  //                         onTap: (id) async {
                  //                           dashboardWatch.updateMonthYear(monthDynamicList[id]);
                  //                           // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                         },
                  //                         selectedIndex: dashboardWatch.selectedMonth!=null ? monthDynamicList.indexWhere((e)=>e==dashboardWatch.selectedMonth): null,
                  //                         isFrontWidgetRequired: true,
                  //                         isColorIndicatorRequired: true,
                  //                         frontWidget: CommonText(
                  //                           title: LocaleKeys.keyMonth.localized,
                  //                           textStyle: TextStyles.regular.copyWith(
                  //                               color: AppColors.grey8F8F8F,
                  //                               fontSize: 16.sp
                  //                           ),
                  //                         ),
                  //                       ).paddingOnly(right: 20.w),
                  //
                  //                       /// Year dropdown
                  //                       CommonDropdownDashboard(
                  //                         menuItems: dashboardWatch.yearsDynamicList,
                  //                         onTap: (id) async {
                  //                           dashboardWatch.updateYearIndex(context, id);
                  //                           // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                         },
                  //                         selectedIndex: dashboardWatch.selectedYearIndex,
                  //                         isFrontWidgetRequired: true,
                  //                         isColorIndicatorRequired: true,
                  //                         frontWidget: CommonText(
                  //                           title: LocaleKeys.keyYear.localized,
                  //                           textStyle: TextStyles.regular.copyWith(
                  //                               color: AppColors.grey8F8F8F,
                  //                               fontSize: 16.sp
                  //                           ),
                  //                         ),
                  //                       ).paddingOnly(right: 20.w),
                  //
                  //                       Container(
                  //                         height: context.height*0.04,
                  //                         decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20.r)),
                  //                         child: Row(
                  //                           children: [
                  //                             Icon(Icons.refresh_outlined,color: Colors.white,size: 16.h,).paddingOnly(right: 6.w),
                  //                             CommonText(title: 'Reset',textStyle: TextStyles.regular.copyWith(color: Colors.white,fontSize: 12.sp),)
                  //                           ],
                  //                         ).paddingSymmetric(horizontal: 10.w),
                  //                       )
                  //                     ]
                  //                 ),
                  //               ),
                  //               /// Total Sales Graph
                  //               Expanded(
                  //                 flex: 10,
                  //                 child: AverageTimeStoreGraph(),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ).paddingOnly(),
                  //     ),
                  //   ],
                  // ),
                  //
                  //
                  //
                  // ///counts and interaction
                  // Row(
                  //   children: [
                  //     Expanded(child: Column(
                  //       children: [
                  //         SizedBox(
                  //           height: 16.h,
                  //         ),
                  //         SizedBox(
                  //           height: context.height * 0.5,
                  //           width: context.width,
                  //           child: CommonBackGroundWidget(
                  //             backGroundColor: AppColors.white,
                  //             content: FadeBoxTransition(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   /// Title total sales
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       CommonText(
                  //                         title: LocaleKeys.keyAdsCounts.localized,
                  //                         textStyle: TextStyles.bold.copyWith(
                  //                           color: AppColors.clr11263C,
                  //                           fontSize: 18.sp,
                  //                         ),
                  //                       ),
                  //                       InkWell(
                  //                         onTap: (){
                  //                           dashboardWatch.disposeGraphData();
                  //                           // destinationWatch.updateSelectedDestination(null);
                  //                           dashboardWatch.updateYearIndex(context, dashboardWatch.yearsDynamicList.indexWhere((element) => element == DateTime.now().year.toString()));
                  //                           // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                         },
                  //                         child: Visibility(
                  //                           visible: dashboardWatch.selectedMonth!=null ||  dashboardWatch.selectedYear != DateTime.now().year.toString() || dashboardWatch.selectedDestination!=null || dashboardWatch.selectedEntity!=null,
                  //                           child: CommonText(
                  //                             title: LocaleKeys.keyClearFilters.localized,
                  //                             textStyle: TextStyles.regular.copyWith(
                  //                               decoration: TextDecoration.underline,
                  //                               decorationColor: AppColors.blue009AF1,
                  //                               fontSize: 13.sp,
                  //                               color: AppColors.blue009AF1,
                  //                             ),
                  //                           ).alignAtCenterRight(),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Expanded(
                  //                     flex: 2,
                  //                     child: Row(
                  //                         mainAxisAlignment: MainAxisAlignment.start,
                  //                         children: [
                  //                           // Row(
                  //                           //   children: [
                  //                           //     TableHeaderTextWidget(text: dashboardWatch.selectedDestination?.name ?? LocaleKeys.keyDestination.localized),
                  //                           //     SizedBox(width: 10.w),
                  //                           //     DestinationFilterWidget(
                  //                           //       controller: dashboardWatch.tooltipController,
                  //                           //       onTap: () async {
                  //                           //         dashboardWatch.updateDestination(destinationWatch.selectedDestination);
                  //                           //         dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                           //       },
                  //                           //     )
                  //                           //   ],
                  //                           // ).paddingOnly(right: 20.w),
                  //                           // CommonDropdownDashboard(
                  //                           //   // menuItems: dashboardWatch.entityType.map((e) => e == 'Client_Master' ? 'Client' : e).toList(),
                  //                           //   menuItems: dashboardWatch.entityType.where((tab) => tab.havePermission == true).toList().map((tab) => tab.tabName)  // Extract tab names
                  //                           //       .toList().map((e) => e == 'Client_Master' ? 'Client' : e).toList(),
                  //                           //   onTap: (id) async {
                  //                           //     print(dashboardWatch.entityType[id].toString());
                  //                           //     dashboardWatch.updateEntity(dashboardWatch.entityType.where((e)=>e.havePermission).toList()[id].tabName);
                  //                           //     // dashboardWatch.updateEntity(dashboardWatch.entityType[id]);
                  //                           //     await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                           //   },
                  //                           //   selectedIndex: dashboardWatch.selectedEntity!=null ? (dashboardWatch.entityType.where((tab) => tab.havePermission == true).toList()).indexWhere((e)=>e.tabName.allInCaps==dashboardWatch.selectedEntity?.allInCaps): null,
                  //                           //   isFrontWidgetRequired: true,
                  //                           //   isColorIndicatorRequired: true,
                  //                           //   frontWidget: CommonText(
                  //                           //     title: LocaleKeys.keyEntity.localized,
                  //                           //     textStyle: TextStyles.regular.copyWith(
                  //                           //         color: AppColors.grey8F8F8F,
                  //                           //         fontSize: 16.sp
                  //                           //     ),
                  //                           //   ),
                  //                           // ).paddingOnly(right: 20.w),
                  //                           CommonDropdownDashboard(
                  //                             menuItems: monthDynamicList,
                  //                             onTap: (id) async {
                  //                               dashboardWatch.updateMonthYear(monthDynamicList[id]);
                  //                               // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                             },
                  //                             selectedIndex: dashboardWatch.selectedMonth!=null ? monthDynamicList.indexWhere((e)=>e==dashboardWatch.selectedMonth): null,
                  //                             isFrontWidgetRequired: true,
                  //                             isColorIndicatorRequired: true,
                  //                             frontWidget: CommonText(
                  //                               title: LocaleKeys.keyMonth.localized,
                  //                               textStyle: TextStyles.regular.copyWith(
                  //                                   color: AppColors.grey8F8F8F,
                  //                                   fontSize: 16.sp
                  //                               ),
                  //                             ),
                  //                           ).paddingOnly(right: 20.w),
                  //
                  //                           /// Year dropdown
                  //                           CommonDropdownDashboard(
                  //                             menuItems: dashboardWatch.yearsDynamicList,
                  //                             onTap: (id) async {
                  //                               dashboardWatch.updateYearIndex(context, id);
                  //                               // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                             },
                  //                             selectedIndex: dashboardWatch.selectedYearIndex,
                  //                             isFrontWidgetRequired: true,
                  //                             isColorIndicatorRequired: true,
                  //                             frontWidget: CommonText(
                  //                               title: LocaleKeys.keyYear.localized,
                  //                               textStyle: TextStyles.regular.copyWith(
                  //                                   color: AppColors.grey8F8F8F,
                  //                                   fontSize: 16.sp
                  //                               ),
                  //                             ),
                  //                           ).paddingOnly(right: 20.w),
                  //
                  //                           Container(
                  //                             height: context.height*0.04,
                  //                             decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20.r)),
                  //                             child: Row(
                  //                               children: [
                  //                                 Icon(Icons.refresh_outlined,color: Colors.white,size: 16.h,).paddingOnly(right: 6.w),
                  //                                 CommonText(title: 'Reset',textStyle: TextStyles.regular.copyWith(color: Colors.white,fontSize: 12.sp),)
                  //                               ],
                  //                             ).paddingSymmetric(horizontal: 10.w),
                  //                           )
                  //                         ]
                  //                     ),
                  //                   ),
                  //                   /// Total Sales Graph
                  //                   const Expanded(
                  //                     flex: 10,
                  //                     child: AverageTimeStoreGraph(),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ).paddingOnly(),
                  //         ),
                  //       ],
                  //     ),),
                  //     SizedBox(
                  //       width: 16.h,
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         children: [
                  //           SizedBox(
                  //             height: 16.h,
                  //           ),
                  //           SizedBox(
                  //             height: context.height * 0.5,
                  //             width: context.width,
                  //             child: CommonBackGroundWidget(
                  //               backGroundColor: AppColors.white,
                  //               content: FadeBoxTransition(
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     /// Title total sales
                  //                     Row(
                  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                       children: [
                  //                         CommonText(
                  //                           title: LocaleKeys.keyInteractions.localized,
                  //                           textStyle: TextStyles.bold.copyWith(
                  //                             color: AppColors.clr11263C,
                  //                             fontSize: 18.sp,
                  //                           ),
                  //                         ),
                  //                         InkWell(
                  //                           onTap: (){
                  //                             dashboardWatch.disposeGraphData();
                  //                             // destinationWatch.updateSelectedDestination(null);
                  //                             dashboardWatch.updateYearIndex(context, dashboardWatch.yearsDynamicList.indexWhere((element) => element == DateTime.now().year.toString()));
                  //                             // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                           },
                  //                           child: Visibility(
                  //                             visible: dashboardWatch.selectedMonth!=null ||  dashboardWatch.selectedYear != DateTime.now().year.toString() || dashboardWatch.selectedDestination!=null || dashboardWatch.selectedEntity!=null,
                  //                             child: CommonText(
                  //                               title: LocaleKeys.keyClearFilters.localized,
                  //                               textStyle: TextStyles.regular.copyWith(
                  //                                 decoration: TextDecoration.underline,
                  //                                 decorationColor: AppColors.blue009AF1,
                  //                                 fontSize: 13.sp,
                  //                                 color: AppColors.blue009AF1,
                  //                               ),
                  //                             ).alignAtCenterRight(),
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     Expanded(
                  //                       flex: 2,
                  //                       child: Row(
                  //                           mainAxisAlignment: MainAxisAlignment.start,
                  //                           children: [
                  //                             CommonDropdownDashboard(
                  //                               menuItems: monthDynamicList,
                  //                               onTap: (id) async {
                  //                                 dashboardWatch.updateMonthYear(monthDynamicList[id]);
                  //                                 // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                               },
                  //                               selectedIndex: dashboardWatch.selectedMonth!=null ? monthDynamicList.indexWhere((e)=>e==dashboardWatch.selectedMonth): null,
                  //                               isFrontWidgetRequired: true,
                  //                               isColorIndicatorRequired: true,
                  //                               frontWidget: CommonText(
                  //                                 title: LocaleKeys.keyMonth.localized,
                  //                                 textStyle: TextStyles.regular.copyWith(
                  //                                     color: AppColors.grey8F8F8F,
                  //                                     fontSize: 16.sp
                  //                                 ),
                  //                               ),
                  //                             ).paddingOnly(right: 20.w),
                  //
                  //                             /// Year dropdown
                  //                             CommonDropdownDashboard(
                  //                               menuItems: dashboardWatch.yearsDynamicList,
                  //                               onTap: (id) async {
                  //                                 dashboardWatch.updateYearIndex(context, id);
                  //                                 // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                               },
                  //                               selectedIndex: dashboardWatch.selectedYearIndex,
                  //                               isFrontWidgetRequired: true,
                  //                               isColorIndicatorRequired: true,
                  //                               frontWidget: CommonText(
                  //                                 title: LocaleKeys.keyYear.localized,
                  //                                 textStyle: TextStyles.regular.copyWith(
                  //                                     color: AppColors.grey8F8F8F,
                  //                                     fontSize: 16.sp
                  //                                 ),
                  //                               ),
                  //                             ).paddingOnly(right: 20.w),
                  //
                  //                             Container(
                  //                               height: context.height*0.04,
                  //                               decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20.r)),
                  //                               child: Row(
                  //                                 children: [
                  //                                   Icon(Icons.refresh_outlined,color: Colors.white,size: 16.h,).paddingOnly(right: 6.w),
                  //                                   CommonText(title: 'Reset',textStyle: TextStyles.regular.copyWith(color: Colors.white,fontSize: 12.sp),)
                  //                                 ],
                  //                               ).paddingSymmetric(horizontal: 10.w),
                  //                             )
                  //                           ]
                  //                       ),
                  //                     ),
                  //                     /// Total Sales Graph
                  //                     const Expanded(
                  //                       flex: 10,
                  //                       child: AverageTimeStoreGraph(),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ).paddingOnly(),
                  //           ),
                  //         ],
                  //       ),),
                  //   ],
                  // ),
                  //
                  //
                  //
                  // ///Navigation Request
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: 16.h,
                  //     ),
                  //     SizedBox(
                  //       height: context.height * 0.5,
                  //       width: context.width,
                  //       child: CommonBackGroundWidget(
                  //         backGroundColor: AppColors.white,
                  //         content: FadeBoxTransition(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               /// Title total sales
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   CommonText(
                  //                     title: LocaleKeys.keyNavigationRequest.localized,
                  //                     textStyle: TextStyles.bold.copyWith(
                  //                       color: AppColors.clr11263C,
                  //                       fontSize: 18.sp,
                  //                     ),
                  //                   ),
                  //                   Row(
                  //                     children: [
                  //                       Row(
                  //                         children: [
                  //                           CommonText(
                  //                             title: LocaleKeys.keyTotal.localized,
                  //                             textStyle: TextStyles.medium.copyWith(
                  //                               color: AppColors.black.withOpacity(0.5),
                  //                               fontSize: 12.sp,
                  //                             ),
                  //                           ),
                  //                           CommonCupertinoSwitch(switchValue: true, onChanged: (value) {},),
                  //                           CommonText(
                  //                             title: LocaleKeys.keyAverage.localized,
                  //                             textStyle: TextStyles.medium.copyWith(
                  //                               color: AppColors.black.withOpacity(0.5),
                  //                               fontSize: 12.sp,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //
                  //                       SizedBox(width: 20.w,),
                  //
                  //                       CommonInfoRow(xAxisLabel: '${LocaleKeys.keyXAxis.localized} Days', yAxisLabel: '${LocaleKeys.keyYAxis.localized} Request'),
                  //
                  //                       SizedBox(width: 20.w,),
                  //
                  //                       Container(
                  //                         decoration: BoxDecoration(
                  //                             color: AppColors.whiteF7F7FC,
                  //                             borderRadius: BorderRadius.circular(22.r)
                  //                         ),
                  //                         child: Row(
                  //                           children: [
                  //                             Row(
                  //                               children: [
                  //                                 Container(
                  //                                   height: 15.h,width: 15.w,
                  //                                   decoration: BoxDecoration(shape: BoxShape.circle,
                  //                                       gradient: LinearGradient(colors: [AppColors.green00AE14,AppColors.white])
                  //                                   ),
                  //                                 ).paddingOnly(right: 5.w),
                  //                                 CommonText(
                  //                                   title: '${LocaleKeys.keyCompleted.localized}',
                  //                                   textStyle: TextStyles.medium.copyWith(
                  //                                     color: AppColors.black.withOpacity(0.5),
                  //                                     fontSize: 12.sp,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                             SizedBox(width: 20.w,),
                  //                             Row(
                  //                               children: [
                  //                                 Container(
                  //                                   height: 15.h,width: 15.w,
                  //                                   decoration: BoxDecoration(shape: BoxShape.circle,
                  //                                       color: AppColors.pinkFF7777
                  //                                   ),
                  //                                 ).paddingOnly(right: 5.w),
                  //                                 CommonText(
                  //                                   title: '${LocaleKeys.keyFailed.localized}',
                  //                                   textStyle: TextStyles.medium.copyWith(
                  //                                     color: AppColors.black.withOpacity(0.5),
                  //                                     fontSize: 12.sp,
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ],
                  //                         ).paddingSymmetric(vertical: 12.h,horizontal: 15.w),
                  //                       ),
                  //                       InkWell(
                  //                         onTap: (){
                  //                           dashboardWatch.disposeGraphData();
                  //                           // destinationWatch.updateSelectedDestination(null);
                  //                           dashboardWatch.updateYearIndex(context, dashboardWatch.yearsDynamicList.indexWhere((element) => element == DateTime.now().year.toString()));
                  //                           // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                         },
                  //                         child: Visibility(
                  //                           visible: dashboardWatch.selectedMonth!=null ||  dashboardWatch.selectedYear != DateTime.now().year.toString() || dashboardWatch.selectedDestination!=null || dashboardWatch.selectedEntity!=null,
                  //                           child: CommonText(
                  //                             title: LocaleKeys.keyClearFilters.localized,
                  //                             textStyle: TextStyles.regular.copyWith(
                  //                               decoration: TextDecoration.underline,
                  //                               decorationColor: AppColors.blue009AF1,
                  //                               fontSize: 13.sp,
                  //                               color: AppColors.blue009AF1,
                  //                             ),
                  //                           ).alignAtCenterRight(),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Row(
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     children: [
                  //                       CommonDropdownDashboard(
                  //                         menuItems: monthDynamicList,
                  //                         onTap: (id) async {
                  //                           dashboardWatch.updateMonthYear(monthDynamicList[id]);
                  //                           // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                         },
                  //                         selectedIndex: dashboardWatch.selectedMonth!=null ? monthDynamicList.indexWhere((e)=>e==dashboardWatch.selectedMonth): null,
                  //                         isFrontWidgetRequired: true,
                  //                         isColorIndicatorRequired: true,
                  //                         frontWidget: CommonText(
                  //                           title: LocaleKeys.keyMonth.localized,
                  //                           textStyle: TextStyles.regular.copyWith(
                  //                               color: AppColors.grey8F8F8F,
                  //                               fontSize: 16.sp
                  //                           ),
                  //                         ),
                  //                       ).paddingOnly(right: 20.w),
                  //
                  //                       /// Year dropdown
                  //                       CommonDropdownDashboard(
                  //                         menuItems: dashboardWatch.yearsDynamicList,
                  //                         onTap: (id) async {
                  //                           dashboardWatch.updateYearIndex(context, id);
                  //                           // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                         },
                  //                         selectedIndex: dashboardWatch.selectedYearIndex,
                  //                         isFrontWidgetRequired: true,
                  //                         isColorIndicatorRequired: true,
                  //                         frontWidget: CommonText(
                  //                           title: LocaleKeys.keyYear.localized,
                  //                           textStyle: TextStyles.regular.copyWith(
                  //                               color: AppColors.grey8F8F8F,
                  //                               fontSize: 16.sp
                  //                           ),
                  //                         ),
                  //                       ).paddingOnly(right: 20.w),
                  //
                  //                       Container(
                  //                         height: context.height*0.04,
                  //                         decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20.r)),
                  //                         child: Row(
                  //                           children: [
                  //                             Icon(Icons.refresh_outlined,color: Colors.white,size: 16.h,).paddingOnly(right: 6.w),
                  //                             CommonText(title: 'Reset',textStyle: TextStyles.regular.copyWith(color: Colors.white,fontSize: 12.sp),)
                  //                           ],
                  //                         ).paddingSymmetric(horizontal: 10.w),
                  //                       )
                  //                     ]
                  //                 ),
                  //               ),
                  //               /// Total Sales Graph
                  //               Expanded(
                  //                 flex: 10,
                  //                 child:/*dashboardWatch.dashboardSalesReportState.isLoading?  Shimmer.fromColors(
                  //                   baseColor: Colors.grey.shade300,
                  //                   highlightColor: Colors.grey.shade100,
                  //                   enabled: true,
                  //                   child: ListView.builder(
                  //                     itemCount:10,
                  //                     shrinkWrap: true,
                  //                     physics: const NeverScrollableScrollPhysics() ,
                  //                     itemBuilder: (context, index) {
                  //                       return Container(
                  //                         height: 280.h,
                  //                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.r)), color: AppColors.white),
                  //                       ).paddingOnly(bottom: 30.h);
                  //                     },
                  //                   ),
                  //                 ) :*/
                  //                 NavigationRequestGraph(),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ).paddingOnly(),
                  //     ),
                  //   ],
                  // ),
                  //
                  // SizedBox(
                  //   height: 16.h,
                  // ),
                  // ///Most requested stores
                  // Row(
                  //   children: [
                  //     Expanded(flex: 5,child: MostRequestedStoreChart()),
                  //     SizedBox(
                  //       width: 16.h,
                  //     ),
                  //     Expanded(flex: 3,child: ShopperStoreChart()),
                  //   ],
                  // ),
                  //
                  //
                  // ///Weekends weekdays
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: 16.h,
                  //     ),
                  //     SizedBox(
                  //       height: context.height * 0.5,
                  //       width: context.width,
                  //       child: CommonBackGroundWidget(
                  //         backGroundColor: AppColors.white,
                  //         content: FadeBoxTransition(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               /// Title total sales
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   CommonText(
                  //                     title: LocaleKeys.keyWeekendWeekdays.localized,
                  //                     textStyle: TextStyles.bold.copyWith(
                  //                       color: AppColors.clr11263C,
                  //                       fontSize: 18.sp,
                  //                     ),
                  //                   ),
                  //                   Row(
                  //                       mainAxisAlignment: MainAxisAlignment.start,
                  //                       children: [
                  //                         Container(
                  //                           decoration: BoxDecoration(
                  //                               borderRadius: BorderRadius.circular(20.r,),
                  //                               border: Border.all(color: AppColors.grayA5A5A5)
                  //                           ),
                  //                           child: Row(
                  //                             children: [
                  //                               // TableHeaderTextWidget(
                  //                               //   text: storeWatch.selectedStoreData == null ? LocaleKeys.keyCategoryName.localized : storeWatch.selectedStoreData?.name ?? '',textStyle: TextStyles.medium.copyWith(fontSize: 14.sp,color: AppColors.grey8D8C8C),),
                  //                               // SizedBox(
                  //                               //   width: context.height*0.01,
                  //                               // ),
                  //                               // CategoryFilterWidget(
                  //                               //   controller: dashboardWatch.tooltipControllerCategoryWeekend,
                  //                               //   onTap: () async {
                  //                               //     showLog(storeWatch.selectedStoreData?.name ?? '');
                  //                               //     // dashboardWatch.updateDestination(destinationWatch.selectedDestination);
                  //                               //     // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                               //   },
                  //                               // ),
                  //                             ],
                  //                           ).paddingSymmetric(vertical: 5.h,horizontal: 10.w),
                  //                         ).paddingOnly(right: 20.w),
                  //                         Container(
                  //                           decoration: BoxDecoration(
                  //                               borderRadius: BorderRadius.circular(20.r,),
                  //                               border: Border.all(color: AppColors.grayA5A5A5)
                  //                           ),
                  //                           child: Row(
                  //                             children: [
                  //                               TableHeaderTextWidget(
                  //                                 text: storeWatch.selectedStoreData == null ? LocaleKeys.keyStoreName.localized : storeWatch.selectedStoreData?.name ?? '', textStyle: TextStyles.medium.copyWith(fontSize: 14.sp,color: AppColors.grey8D8C8C),),
                  //                               SizedBox(
                  //                                 width: context.height*0.01,
                  //                               ),
                  //                               StoreFilterWidget(
                  //                                 controller: dashboardWatch.tooltipControllerStoreWeekend,
                  //                                 onTap: () async {
                  //                                   showLog(storeWatch.selectedStoreData?.name ?? '');
                  //                                   // dashboardWatch.updateDestination(destinationWatch.selectedDestination);
                  //                                   // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                                 },
                  //                               ),
                  //                             ],
                  //                           ).paddingSymmetric(vertical: 5.h,horizontal: 10.w),
                  //                         ).paddingOnly(right: 20.w),
                  //                         Consumer(builder: (context, ref, child) {
                  //                           final ticketManagementWatch = ref.watch(ticketManagementController);
                  //                           return Column(
                  //                             children: [
                  //                               InkWell(
                  //                                 onTap: () {
                  //                                   /// Start Date Calender Picker
                  //                                   showCommonWebDialog(
                  //                                       keyBadge: ticketManagementWatch.startDateDialogKey,
                  //                                       width: 0.5,
                  //                                       // height:0.5,
                  //                                       context: context, dialogBody: CustomDatePicker(
                  //                                     selectDateOnTap: true,
                  //
                  //                                     bubbleDirection: true,
                  //                                     bubbleColor: AppColors.white,
                  //                                     initialDate: ticketManagementWatch.startDate,
                  //                                     firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 365),
                  //                                     lastDate: DateTime.now(),
                  //                                     getDateCallback: (DateTime? selectedDate, {bool? isOkPressed}) {
                  //                                       ticketManagementWatch.updateStartEndDate(true, selectedDate);
                  //                                       // = DateFormat('dd/MM/yyyy').format(selectedDate ?? DateTime.now());
                  //                                     },
                  //                                     onOkTap: () {
                  //                                       ticketManagementWatch.clearEndDate();
                  //                                       // updateIsDatePickerVisible();
                  //                                       // orderListWatch.updateIsDatePickerVisible(false);
                  //                                     },
                  //                                     onCancelTap: () {
                  //                                       // updateIsDatePickerVisible();
                  //                                       // orderListWatch.updateIsDatePickerVisible(false);
                  //                                     },
                  //                                   ));
                  //                                 },
                  //                                 child: Container(
                  //                                   height: context.height*0.05,
                  //                                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.lightPinkF7F7FC),
                  //                                   alignment: Alignment.center,
                  //                                   child: Row(
                  //                                     crossAxisAlignment: CrossAxisAlignment.center,
                  //                                     mainAxisAlignment: MainAxisAlignment.center,
                  //                                     mainAxisSize: MainAxisSize.min,
                  //                                     children: [
                  //                                       Icon(
                  //                                         Icons.calendar_today_outlined,
                  //                                         size: 20.h,
                  //                                       ),
                  //
                  //                                       if(ticketManagementWatch.startDate != null)
                  //                                         Row(
                  //                                           children: [
                  //                                             SizedBox(
                  //                                               width: context.width*0.010,
                  //                                             ),
                  //                                             FittedBox(
                  //                                               fit: BoxFit.contain,
                  //                                               child: CommonText(
                  //                                                 title: dateFormatFromDateTime(ticketManagementWatch.startDate, 'dd/MM/yyyy'),
                  //                                                 fontSize: 12.sp,
                  //                                               ),
                  //                                             ),
                  //                                           ],
                  //                                         ),
                  //                                     ],
                  //                                   ).paddingSymmetric(horizontal: context.width*0.007),
                  //                                 ),
                  //                               ),
                  //                               Visibility(visible: ticketManagementWatch.startDateError != null, child: CommonText(title: ticketManagementWatch.startDateError.toString(), textStyle: TextStyles.regular.copyWith(color: AppColors.red), maxLines: 3,))
                  //                             ],
                  //                           );
                  //                         }).paddingOnly(right: 20.w),
                  //
                  //                         Container(
                  //                           height: context.height*0.04,
                  //                           decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20.r)),
                  //                           child: Row(
                  //                             children: [
                  //                               Icon(Icons.refresh_outlined,color: Colors.white,size: 16.h,).paddingOnly(right: 6.w),
                  //                               CommonText(title: 'Reset',textStyle: TextStyles.regular.copyWith(color: Colors.white,fontSize: 12.sp),)
                  //                             ],
                  //                           ).paddingSymmetric(horizontal: 10.w),
                  //                         ),
                  //                         InkWell(
                  //                           onTap: (){
                  //                             dashboardWatch.disposeGraphData();
                  //                             // destinationWatch.updateSelectedDestination(null);
                  //                             dashboardWatch.updateYearIndex(context, dashboardWatch.yearsDynamicList.indexWhere((element) => element == DateTime.now().year.toString()));
                  //                             // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                           },
                  //                           child: Visibility(
                  //                             visible: dashboardWatch.selectedMonth!=null ||  dashboardWatch.selectedYear != DateTime.now().year.toString() || dashboardWatch.selectedDestination!=null || dashboardWatch.selectedEntity!=null,
                  //                             child: CommonText(
                  //                               title: LocaleKeys.keyClearFilters.localized,
                  //                               textStyle: TextStyles.regular.copyWith(
                  //                                 decoration: TextDecoration.underline,
                  //                                 decorationColor: AppColors.blue009AF1,
                  //                                 fontSize: 13.sp,
                  //                                 color: AppColors.blue009AF1,
                  //                               ),
                  //                             ).alignAtCenterRight(),
                  //                           ),
                  //                         ),
                  //
                  //                       ]
                  //                   ),
                  //                 ],
                  //               ),
                  //               /// Total Sales Graph
                  //               Expanded(
                  //                 flex: 10,
                  //                 child: /*dashboardWatch.dashboardSalesReportState.isLoading?  Shimmer.fromColors(
                  //                   baseColor: Colors.grey.shade300,
                  //                   highlightColor: Colors.grey.shade100,
                  //                   enabled: true,
                  //                   child: ListView.builder(
                  //                     itemCount:10,
                  //                     shrinkWrap: true,
                  //                     physics: const NeverScrollableScrollPhysics() ,
                  //                     itemBuilder: (context, index) {
                  //                       return Container(
                  //                         height: 280.h,
                  //                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.r)), color: AppColors.white),
                  //                       ).paddingOnly(bottom: 30.h);
                  //                     },
                  //                   ),
                  //                 ) :*/
                  //
                  //                 const WeekendWeekdayGraph(),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ).paddingOnly(),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 16.h,
                  // ),
                  // ///per day Reports
                  // Column(
                  //   children: [
                  //     SizedBox(
                  //       height: context.height*0.704,
                  //       width: context.width,
                  //       child: CommonBackGroundWidget(
                  //         backGroundColor: AppColors.white,
                  //         content: FadeBoxTransition(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               /// Uptime graph
                  //               Row(
                  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   CommonText(
                  //                     title: LocaleKeys.keyPeakUsageTime.localized,
                  //                     textStyle: TextStyles.bold.copyWith(
                  //                       color: AppColors.clr11263C,
                  //                       fontSize: 18.sp,
                  //                     ),
                  //                   ),
                  //                   InkWell(
                  //                     onTap: (){
                  //                       dashboardWatch.disposeGraphData();
                  //                       // destinationWatch.updateSelectedDestination(null);
                  //                       dashboardWatch.updateYearIndex(context, dashboardWatch.yearsDynamicList.indexWhere((element) => element == DateTime.now().year.toString()));
                  //                       // dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                     },
                  //                     child: Visibility(
                  //                       visible: dashboardWatch.selectedMonth!=null ||  dashboardWatch.selectedYear != DateTime.now().year.toString() || dashboardWatch.selectedDestination!=null || dashboardWatch.selectedEntity!=null,
                  //                       child: CommonText(
                  //                         title: LocaleKeys.keyClearFilters.localized,
                  //                         textStyle: TextStyles.regular.copyWith(
                  //                           decoration: TextDecoration.underline,
                  //                           decorationColor: AppColors.blue009AF1,
                  //                           fontSize: 13.sp,
                  //                           color: AppColors.blue009AF1,
                  //                         ),
                  //                       ).alignAtCenterRight(),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Expanded(
                  //                 flex: 2,
                  //                 child: Row(
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     children: [
                  //                       CommonDropdownDashboard(
                  //                         menuItems: monthDynamicList,
                  //                         onTap: (id) async {
                  //                           dashboardWatch.updateMonthYear(monthDynamicList[id]);
                  //                           // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                         },
                  //                         selectedIndex: dashboardWatch.selectedMonth!=null ? monthDynamicList.indexWhere((e)=>e==dashboardWatch.selectedMonth): null,
                  //                         isFrontWidgetRequired: true,
                  //                         isColorIndicatorRequired: true,
                  //                         frontWidget: CommonText(
                  //                           title: LocaleKeys.keyMonth.localized,
                  //                           textStyle: TextStyles.regular.copyWith(
                  //                               color: AppColors.grey8F8F8F,
                  //                               fontSize: 16.sp
                  //                           ),
                  //                         ),
                  //                       ).paddingOnly(right: 20.w),
                  //
                  //                       /// Year dropdown
                  //                       CommonDropdownDashboard(
                  //                         menuItems: dashboardWatch.yearsDynamicList,
                  //                         onTap: (id) async {
                  //                           dashboardWatch.updateYearIndex(context, id);
                  //                           // await dashboardWatch.getDashboardSalesReportApi(context, selectedYear: dashboardWatch.yearsDynamicList[dashboardWatch.selectedYearIndex]);
                  //                         },
                  //                         selectedIndex: dashboardWatch.selectedYearIndex,
                  //                         isFrontWidgetRequired: true,
                  //                         isColorIndicatorRequired: true,
                  //                         frontWidget: CommonText(
                  //                           title: LocaleKeys.keyYear.localized,
                  //                           textStyle: TextStyles.regular.copyWith(
                  //                               color: AppColors.grey8F8F8F,
                  //                               fontSize: 16.sp
                  //                           ),
                  //                         ),
                  //                       ).paddingOnly(right: 20.w),
                  //
                  //                       Container(
                  //                         height: context.height*0.04,
                  //                         decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20.r)),
                  //                         child: Row(
                  //                           children: [
                  //                             Icon(Icons.refresh_outlined,color: Colors.white,size: 16.h,).paddingOnly(right: 6.w),
                  //                             CommonText(title: 'Reset',textStyle: TextStyles.regular.copyWith(color: Colors.white,fontSize: 12.sp),)
                  //                           ],
                  //                         ).paddingSymmetric(horizontal: 10.w),
                  //                       )
                  //                     ]
                  //                 ),
                  //               ),
                  //               /// Peak usage time graph
                  //               Expanded(
                  //                 flex: 10,
                  //                 child: /*dashboardWatch.dashboardSalesReportState.isLoading?  Shimmer.fromColors(
                  //                   baseColor: Colors.grey.shade300,
                  //                   highlightColor: Colors.grey.shade100,
                  //                   enabled: true,
                  //                   child: ListView.builder(
                  //                     itemCount:10,
                  //                     shrinkWrap: true,
                  //                     physics: const NeverScrollableScrollPhysics() ,
                  //                     itemBuilder: (context, index) {
                  //                       return Container(
                  //                         height: 280.h,
                  //                         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.r)), color: AppColors.white),
                  //                       ).paddingOnly(bottom: 30.h);
                  //                     },
                  //                   ),
                  //                 ) :*/
                  //
                  //                 const PeakUsageTimeGraph(),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ).paddingOnly(),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ).paddingAll(20.h),
    );
  }


}