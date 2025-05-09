import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/ticket_management/web/helper/common_check_box.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonOrderFilterTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;
  const CommonOrderFilterTile({Key? key, required this.value, required this.onChanged, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonCheckBox(value: value, onChanged: onChanged, checkColor: AppColors.white, activeColor: AppColors.black,).paddingOnly(right: 5.h),
        Expanded(
          child: CommonText(
            title: title.toLowerCase().capsFirstLetterOfSentence,
            textStyle: TextStyles.regular.copyWith(
                fontSize: 12.sp,
                color: AppColors.black171717
            ),
          ),
        )
      ],
    );
  }
}