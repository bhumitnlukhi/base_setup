

import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class TableChildTextWidget extends StatelessWidget with BaseStatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final Color? textColor;
  final TextStyle? textStyle;
  final TextDecoration? textDecoration;
  const TableChildTextWidget({super.key, required this.text,this.textAlign, this.textColor,this.textStyle, this.textDecoration});

  @override
  Widget buildPage(BuildContext context) {
    return CommonText(
      title: text,
      textAlign: textAlign ?? (Session.isRTL ? TextAlign.right : TextAlign.left),
      textOverflow: TextOverflow.ellipsis,

      textStyle: textStyle ?? TextStyles.regular.copyWith(
          fontSize: 14.sp,
          color: textColor ?? AppColors.black,
          decoration: textDecoration,
      ),
      maxLines: 5,
    );
  }
}
