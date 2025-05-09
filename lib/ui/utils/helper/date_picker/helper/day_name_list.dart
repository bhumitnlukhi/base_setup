import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/calendar_controller.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class DayNameList extends ConsumerWidget with BaseConsumerWidget {
  const DayNameList({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final calendarWatch = ref.watch(calendarController);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        calendarWatch.day.length,
        (index) => Container(
          height: 0.04.sh,
          width: 0.05.sw,
          alignment: Alignment.center,
          child: Text(
            calendarWatch.day[index].weekDayName.substring(0, 3),
            style: TextStyles.medium.copyWith(fontSize: 16.sp, color: AppColors.black313031),
          ),
        ),
      ),
    );
  }
}
