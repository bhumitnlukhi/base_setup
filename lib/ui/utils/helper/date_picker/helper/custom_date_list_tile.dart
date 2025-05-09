import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/calendar_controller.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class CustomDateListTile extends ConsumerWidget with BaseConsumerWidget {
  final DateTime? currentDate;
  final bool selectDateOnTap;
  final Function(DateTime? selectedDate, {bool? isOkPressed})? getDateCallback;

  const CustomDateListTile({
    super.key,
    this.selectDateOnTap = false,
    this.getDateCallback,
    required this.currentDate,
  });

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final calendarWatch = ref.watch(calendarController);
    bool isDateSelected = (calendarWatch.selectedDate.day == currentDate?.day) && (calendarWatch.selectedDate.month == currentDate?.month) && (calendarWatch.selectedDate.year == currentDate?.year);
    return InkWell(
      onTap: () {
        if (currentDate != null) {
          calendarWatch.updateSelectedDate(selectedDate: currentDate!);
            // if (selectDateOnTap && calendarWatch.isDateAvailable(currentDate!)) {
            //   getDateCallback?.call(currentDate);
            // }
        }
      },
      child: Opacity(
        opacity: calendarWatch.isDateAvailable(currentDate) ? 1 : 0.4,
        child: Container(
          alignment: Alignment.center,
          height: 0.04.sh,
          width: 0.05.sw,
          decoration: isDateSelected ? const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle) : null,
          child: currentDate != null
              ? Text(
                  currentDate!.day.toString(),
                  style: TextStyles.medium.copyWith(fontSize: 16.5.sp, color: isDateSelected ? AppColors.white : AppColors.black313031),
                ).paddingAll(5.r)
              : const Offstage(),
        ),
      ),
    );
  }
}
