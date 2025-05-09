import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/dropdown/common_bubble_widgets.dart';

class MyOrderFilterActionWidgetWeb extends StatelessWidget with BaseStatelessWidget {
  const MyOrderFilterActionWidgetWeb({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final ticketManagementWatch = ref.watch(ticketManagementController);
        return Consumer(
          builder: (context, ref, child) {
            return PopupMenuButton(
              elevation: 0,
              tooltip: '',
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.expand(
                width: context.width * 0.14,
                height: context.height * 0.35,
              ),
              onOpened: () {
                ticketManagementWatch.updateIsMenuEnable(true);
              },
              onCanceled: () async{
                ticketManagementWatch.updateIsMenuEnable(false);
              },
              color: AppColors.transparent,
              clipBehavior: Clip.hardEdge,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              position: PopupMenuPosition.under,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CommonBubbleWidget(
                        positionFromTop: 0.015.sh,
                        width: context.width * 0.12,
                        height: context.height * 0.2,
                        borderRadius: 20.r,
                        positionFromRight: 0.02.sw,
                        isBubbleFromLeft: false,
                        child: Material(
                          color: AppColors.white,
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: ticketManagementWatch.orderStatusFilterList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    mainAxisExtent: (context.height * 0.04),
                                    mainAxisSpacing: 5.h,
                                    crossAxisSpacing: context.width*0.020,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    OrderStatusFilterModel orderStatusModel = ticketManagementWatch.orderStatusFilterList[index];

                                    return InkWell(
                                      onTap: (){
                                        ticketManagementWatch.clearAlFilter();
                                        ticketManagementWatch.updateSelectedOrderStatusFilterList(context, orderStatusModel);
                                        Navigator.pop(context);

                                        ticketManagementWatch.ticketListApi(context, false, status: ticketManagementWatch.selectedFilterList.first);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Consumer(
                                              builder: (context, ref, child) {
                                                final ticketManagementWatch = ref.watch(ticketManagementController);
                                                return CommonSVG(strIcon: ticketManagementWatch.getIfFilterIsInList(orderStatusModel)? Assets.svgs.svgRadioSelected.keyName :Assets.svgs.svgRadioUnselected.keyName).paddingOnly(right: context.width * 0.010);
                                                // return CommonCheckBox(
                                                //   value: ticketManagementWatch.getIfFilterIsInList(orderStatusModel),
                                                //   onChanged: (value){
                                                //   ticketManagementWatch.clearAlFilter();
                                                //   ticketManagementWatch.updateSelectedOrderStatusFilterList(context, orderStatusModel);
                                                //   ticketManagementWatch.updateUi();
                                                //   ticketManagementWatch.ticketListApi(context, false, status: ticketManagementWatch.selectedFilterList.first);
                                                //
                                                // }, checkColor: AppColors.white, activeColor: AppColors.black,).paddingOnly(right: 5.h);
                                              }
                                          ),
                                          Expanded(
                                            child: CommonText(
                                              title: orderStatusModel.name.toLowerCase().capsFirstLetterOfSentence,
                                              textStyle: TextStyles.regular.copyWith(
                                                  fontSize: 16.sp,
                                                  color: AppColors.black171717
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ).paddingOnly(left: 15.w, top: 20.h),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgFilter.keyName,
                width: context.width*0.020,
                height: context.height*0.020,
              ),
            );
          },
        );
      },
    );
  }
}