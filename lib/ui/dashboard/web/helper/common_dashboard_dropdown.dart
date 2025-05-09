import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonDropdownDashboard extends ConsumerStatefulWidget {
  final List? menuItems;
  final Widget? frontWidget;
  final Function(int id) onTap;
  final int? selectedIndex;
  final Color? containerColor;
  final bool? isColorIndicatorRequired;
  final bool? isFrontWidgetRequired;
  final double? dropDownIconSize;
  final Offset? offSet;

  const CommonDropdownDashboard({
    super.key,
    this.menuItems,
    this.frontWidget,
    required this.onTap,
    this.isColorIndicatorRequired,
     this.selectedIndex,
    this.containerColor,
    this.dropDownIconSize,
    this.isFrontWidgetRequired,
    this.offSet,
  });

  @override
  ConsumerState<CommonDropdownDashboard> createState() => _CommonDropdownDashboardState();
}

class _CommonDropdownDashboardState extends ConsumerState<CommonDropdownDashboard> with BaseConsumerStatefulWidget {
  @override
  Widget buildPage(BuildContext context) {
    final dashboardWatch = ref.watch(dashboardController);
    return Row(
      children: [
        /// front title widget
       widget.isFrontWidgetRequired??false?widget.frontWidget!.paddingOnly(right: 6.w):const Offstage(),

        /// Selected widget
        (widget.isFrontWidgetRequired??false) ?
        CommonText(
          title:widget.selectedIndex==null? '' : (widget.menuItems?.isNotEmpty??false) ? (widget.menuItems?[widget.selectedIndex??0]).toString().replaceAll('_', ' ') : '',
          textStyle: TextStyles.regular.copyWith(
              color: AppColors.black,
              fontSize: 16.sp
          ),
        ):const Offstage(),
        PopupMenuButton(
          onOpened: () {
            if(dashboardWatch.tooltipController.isShowing) {
              dashboardWatch.tooltipController.toggle();
            }
          },

          popUpAnimationStyle: AnimationStyle.noAnimation,
          iconSize: 15,
          icon: RotatedBox(quarterTurns: 3,
              child: Icon(
                  Icons.arrow_back_ios_new_sharp,
                  size: widget.dropDownIconSize??15.sp,
                  color: AppColors.black292929)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0),
            ),
          ),
          tooltip: '',
          constraints: BoxConstraints(
            maxHeight: context.height * 0.3,
          ),
          padding :  EdgeInsets.zero,
          itemBuilder: (context) => [
            ...List.generate(widget.menuItems?.length??0, (index) {
              return PopupMenuItem(
                value: index,
                onTap: (){
                  widget.onTap(index);
                },
                // row with 2 children
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible:widget.isColorIndicatorRequired??true,
                      replacement: Container(
                        decoration:  const BoxDecoration(shape: BoxShape.circle),
                        margin: EdgeInsets.only(right: 6.w),
                        height: 10.h,
                        width: 10.w,
                      ),
                      child: Container(
                        decoration:  BoxDecoration(shape: BoxShape.circle,
                            color:  widget.containerColor==null?
                           ( widget.menuItems?[index]) == LocaleKeys.keyDelivered
                                ? AppColors.clrBAEDBD
                                : (widget.menuItems?[index]) ==LocaleKeys.keyCanceled
                                ? AppColors.partiallyDeliveredTextColor
                                : (widget.menuItems?[index]) == LocaleKeys.keyRejected
                                ? AppColors.clrFF5858
                                :AppColors.clr009AF1
                                :AppColors.clr009AF1
                        ),

                        margin: EdgeInsets.only(right: 6.w),
                        height: 10.h,
                        width: 10.w,
                      ),
                    ),
                    Text(
                      (widget.menuItems?.elementAt(index).toString().localized??'').replaceAll('_', ' '),
                      style: TextStyles.regular.copyWith(
                          fontSize: 16.sp,color: AppColors.black
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          offset: widget.offSet??const Offset(10, 35),
          color: Colors.white,
          elevation: 5,
        )
      ],
    );
  }
}