import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/package/web/helper/show_date_picker_widget_web.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/calendar_controller.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ServiceHistoryDateDialog extends ConsumerWidget {
  final DateTime? initialDate;
  final GlobalKey? globalKey;
  DateTime? startDate;
  DateTime? endDate;
  final Function(DateTime? startDate,DateTime? endDate) onClearCallBack;
  final Function(DateTime? selectedDate, bool isStartDate, {bool? isOkPressed}) getDateCallback;
  final Function() onApplyClick;

  final Function updateIsDatePickerVisible;

  ServiceHistoryDateDialog( {
    super.key,
    this.initialDate,
    this.globalKey,
    required this.startDate,
    required this.endDate,
    required this.updateIsDatePickerVisible,
    required this.onClearCallBack,
    required this.getDateCallback,
    required this.onApplyClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<SampleItem>(
      tooltip: '',
      surfaceTintColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.expand(
        width: context.width * 0.4,
        height: context.height * 0.2,
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.r),
        ),
      ),
      color: AppColors.white,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          key: globalKey,
          padding: EdgeInsets.zero,
          value: SampleItem.itemOne,
          mouseCursor: MouseCursor.defer,
          child: Consumer(
            builder: (context,ref,child) {
              final calendarWatch = ref.watch(calendarController);
            //  final orderHistoryWatch = ref.watch(orderHistoryController);
              return Container(
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          title: LocaleKeys.keySelectCustomDate.localized,
                          textStyle: TextStyles.medium.copyWith(
                            color: AppColors.black,
                            fontSize: 17.sp,
                          ),
                        ).paddingOnly(bottom: 25.h),
                        InkWell(
                          onTap: ()
                          {
                            onClearCallBack(startDate,endDate);
                            startDate=null;
                            endDate=null;
                            calendarWatch.notifyListeners();

                          },
                          child: CommonText(
                            title: LocaleKeys.keyClearAll.localized,
                            textStyle: TextStyles.medium.copyWith(
                              color: AppColors.red,
                              fontSize: 17.sp,
                            ),
                          ).paddingOnly(bottom: 25.h),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _widgetCommonSelectDateTappable(context, isStartDate: true),
                        SizedBox(
                          width: 20.w,
                        ),
                        _widgetCommonSelectDateTappable(context, isStartDate: false),
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          height: 0.05.sh,
                          width: 0.05.sh,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: startDate != null && endDate != null? AppColors.black171717 : AppColors.black171717.withOpacity(0.2),
                          ),
                          child: AbsorbPointer(
                            absorbing: startDate == null && endDate == null,
                            child: InkWell(
                              onTap:onApplyClick,
                              child:   CommonSVG(
                                strIcon: Assets.svgs.svgRightArrow.keyName,
                                svgColor: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20.w, vertical: 15.h),
              );
            }
          ),
        ),
      ],
      offset: Offset(-1.w, 60.h),
      child: CommonSVG(
       // strIcon: AppAssets.svgCalenderIcon,
        strIcon: Assets.svgs.svgFilter.keyName,
        height: 25.h,
        width: 25.h,),
    );
  }

  Widget _widgetCommonSelectDateTappable(BuildContext context, {required bool isStartDate}) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final calendarWatch = ref.watch(calendarController);
       // final orderHistoryWatch = ref.watch(orderHistoryController);
        return Expanded(
          child: Opacity(
            opacity: 1,
            child: ShowDatePicketWidgetWeb(
              dateWidget: _widgetCommonSelectDate(isStartDate: isStartDate, context: context),
              getDateCallback: (DateTime? selectedDate, {bool? isOkPressed}) {
                getDateCallback.call(selectedDate, isStartDate, isOkPressed: isOkPressed);
                if (isStartDate) {
                  startDate = selectedDate;
                } else {
                  endDate = selectedDate;
                }
                calendarWatch.notifyListeners();
               // orderHistoryWatch.notifyListeners();
              },
              isStartDate: isStartDate,
              startDate: startDate,
              endDate: endDate,
              updateIsDatePickerVisible: updateIsDatePickerVisible,
            ),
          ),
        );
      },
    );
  }

  Widget _widgetCommonSelectDate({required bool isStartDate, required BuildContext context}) {
    return Consumer(builder: (context, ref, child) {
      return Container(
        height: 0.07.sh,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.lightPinkF7F7FC),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: getDateTextIconColor(isStartDate, startDate, endDate),
            ),
            SizedBox(
              width: 10.w,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: CommonText(
                title: getDateFromDateTime(isStartDate),
                clrfont: getDateTextIconColor(isStartDate, startDate, endDate),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 5.w),
      );
    });
  }

  Color getDateTextIconColor(bool isStartDate, DateTime? startDate, DateTime? endDate) {
    return isStartDate
        ? (startDate != null)
            ? AppColors.black272727
            : AppColors.grey8F8F8F
        : (endDate != null)
            ? AppColors.black272727
            : AppColors.grey8F8F8F;
  }

  String getDateFromDateTime(bool isStartDate) {
    if (isStartDate) {
      if (startDate != null) {
        return dateFormatFromDateTime(startDate, dateFormat);
      } else {
        return LocaleKeys.keyStartDate.localized;
      }
    } else {
      if (endDate != null) {
        return dateFormatFromDateTime(endDate, dateFormat);
      } else {
        return LocaleKeys.keyEndDate.localized;
      }
    }
  }

  openDatePicker({required BuildContext context, required bool isStartDate, required DateTime? initialDate, required DateTime? firstDate, required DateTime? lastDate}) async {
    final datePick = await showDatePicker(context: context, initialDate: initialDate ?? DateTime.now(), firstDate: firstDate ?? DateTime(7), lastDate: lastDate ?? DateTime.now());
    return datePick;
  }
}
