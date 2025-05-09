import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class TableHeaderTextWidget extends StatelessWidget with BaseStatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  const TableHeaderTextWidget({super.key, required this.text,this.textAlign,this.textStyle});

  @override
  Widget buildPage(BuildContext context) {
    return CommonText(
      title: text,
      textAlign: textAlign ?? (Session.isRTL ? TextAlign.right : TextAlign.left),
      maxLines: 2,
      textStyle:textStyle?? TextStyles.regular.copyWith(fontSize: 16.sp, color: AppColors.grey8D8C8C),
    );
  }
}
