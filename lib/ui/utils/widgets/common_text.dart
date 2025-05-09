import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class CommonText extends StatelessWidget with BaseStatelessWidget{
  final String title;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? fontSize;
  final Color? clrfont;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final TextStyle? textStyle;
  final TextOverflow? textOverflow;
  final String? fontFamily;

  const CommonText(
      {Key? key,
        required this.title,
        this.fontWeight,
        this.fontStyle,
        this.fontSize,
        this.clrfont,
        this.maxLines,
        this.textAlign,
        this.textDecoration,
        this.textStyle, this.textOverflow,this.fontFamily})
      : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    return Text(
      title,
      textScaler: const TextScaler.linear(1.0),
      //-- will not change if system fonts size changed
      maxLines: maxLines ?? 1,
      textAlign: textAlign ?? (Session.isRTL ? TextAlign.right : TextAlign.left),
      // textDirection: Session.isRTL ? TextDirection.rtl : TextDirection.ltr,
      overflow: textOverflow ??TextOverflow.ellipsis,
      style: textStyle ?? TextStyle(
          fontFamily: fontFamily ?? TextStyles.fontFamily,
          fontWeight: fontWeight ?? TextStyles.fwRegular,
          fontSize: fontSize ?? 14.sp,
          color: clrfont ?? AppColors.clr1c1c1c,
          fontStyle: fontStyle ?? FontStyle.normal,
          decoration: textDecoration ?? TextDecoration.none),
    );
  }
}
