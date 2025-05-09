import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/helper/custom_date_list_tile.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class CustomDateList extends StatelessWidget with BaseStatelessWidget {
  final List<DateTime?> dateList;
  final Function(DateTime? selectedDate, {bool? isOkPressed})? getDateCallback;
  final bool selectDateOnTap;

  const CustomDateList({
    super.key,
    required this.dateList,
    this.getDateCallback,
    this.selectDateOnTap = false,
  });

  @override
  Widget buildPage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        dateList.length,
        (index) {
          return CustomDateListTile(currentDate: dateList[index], getDateCallback: getDateCallback, selectDateOnTap: selectDateOnTap);
        },
      ),
    );
  }
}
