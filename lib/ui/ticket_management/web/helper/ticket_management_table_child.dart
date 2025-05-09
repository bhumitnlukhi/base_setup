import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class TableChildWidget extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  const TableChildWidget({super.key, required this.text, this.textAlign, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          text,
          textAlign: textAlign ?? (Session.isRTL ? TextAlign.right : TextAlign.left),
          maxLines: 10,
          style: textStyle ?? TextStyles.regular.copyWith(fontSize: 16.sp, color: AppColors.black),
        ),
      ],
    );
  }
}