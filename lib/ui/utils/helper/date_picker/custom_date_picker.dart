import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/calendar_controller.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/helper/custom_date_day_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/helper/custom_date_month_list.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/helper/custom_date_picket_action_buttons.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/helper/custom_date_year_list.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/helper/previous_next_button_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/dropdown/common_bubble_widgets.dart';

class CustomDatePicker extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final GestureTapCallback? onCancelTap;
  final GestureTapCallback? onOkTap;
  final bool selectDateOnTap;
  final double? height;
  final double? width;
  final Function(DateTime? selectedDate, {bool? isOkPressed}) getDateCallback;
  final bool? bubbleDirection;
  final Color? bubbleColor;
  const CustomDatePicker({
    super.key,
    this.height,
    this.width,
    this.selectDateOnTap = false,
    this.bubbleDirection,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onCancelTap,
    this.onOkTap,
    this.bubbleColor,
    required this.getDateCallback,
  });

  @override
  ConsumerState<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends ConsumerState<CustomDatePicker> with SingleTickerProviderStateMixin, BaseConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final calendarWatch = ref.watch(calendarController);
      calendarWatch.disposeController(context, this, initialDate: widget.initialDate, firstDate: (widget.firstDate ?? DateTime(1900)), lastDate: widget.lastDate ?? DateTime(DateTime.now().year + 50));
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    return CommonBubbleWidget(
      height: widget.height ?? 0.5.sh,
      width: widget.width,
      bubbleColor:widget.bubbleColor,
      isBubbleFromLeft: widget.bubbleDirection ?? true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.025.sh),
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    final calendarWatch = ref.watch(calendarController);
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              calendarWatch.updateWidgetDisplayed();
                            },
                            child: calendarWatch.widgetDisplayed == WidgetDisplayed.day
                                ? Text(
                                    '${calendarWatch.getMonth(ref.watch(calendarController).displayDate.month)} ${ref.watch(calendarController).displayDate.year}',
                                    style: TextStyles.bold.copyWith(fontSize: 16.5.sp, color: AppColors.black313031),
                                  )
                                : calendarWatch.widgetDisplayed == WidgetDisplayed.month
                                    ? Text(
                                        '${ref.watch(calendarController).displayDate.year}',
                                        style: TextStyles.bold.copyWith(fontSize: 16.5.sp, color: AppColors.black313031),
                                      )
                                    : Text(
                                        'Select Year',
                                        style: TextStyles.bold.copyWith(fontSize: 16.5.sp, color: AppColors.black313031),
                                      ),
                          ),
                        ),
                        calendarWatch.widgetDisplayed == WidgetDisplayed.day ? const PreviousNextButtonWidget() : const Offstage(),
                      ],
                    );
                  },
                ).paddingOnly(left: 5.w),
                SizedBox(height: 0.035.sh),
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    final calendarWatch = ref.watch(calendarController);
                    switch (calendarWatch.widgetDisplayed) {
                      case WidgetDisplayed.day:
                        return CustomDateDayWidget(selectDateOnTap: widget.selectDateOnTap, getDateCallback: widget.getDateCallback);
                      case WidgetDisplayed.month:
                        return const CustomDateMonthList();
                      case WidgetDisplayed.year:
                        return const Expanded(child: CustomDateYearList());
                    }
                  },
                ),
              ],
            ),
          ),
          ref.watch(calendarController).widgetDisplayed == WidgetDisplayed.day ? CustomDatePicketActionButtons(getDateCallback: widget.getDateCallback, onCancelTap: widget.onCancelTap, onOkTap: widget.onOkTap).paddingOnly(bottom: 0.01.sh) : const Offstage(),
        ],
      ).paddingOnly(left: 10.w, right: 10.w),
    );
  }
}
