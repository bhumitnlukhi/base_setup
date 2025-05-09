import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

String getInitials(String text) {
  String initials = '';
  for (int i = 0; i < text.length; i++) {
    if (i == 0 || text[i-1] == ' ') {
      initials += text[i];
    }
  }

  if(initials.length>2){
    return initials.substring(0,2);
  }else{
    return initials;
  }
}

class CommonInitialText extends StatelessWidget with BaseStatelessWidget{
  final String text;
  final FontStyle? fontStyle;
  final double? fontSize;
  final Color? containerColor;
  final TextStyle? textStyle;
  final double? height;
  final double? width;

  const CommonInitialText(
      {super.key,
        required this.text,
        this.fontStyle,
        this.fontSize,
        this.containerColor,
        this.textStyle,
        this.height,
        this.width
      });

  @override
  Widget buildPage(BuildContext context) {
    String name = getInitials(text);
    return Container(
      decoration:  BoxDecoration(
          color: containerColor ?? AppColors.blue0083FC,
          shape: BoxShape.circle
      ),
      height: height??84.h,
      width: width??84.h,
      child: Center(
        child: CommonText(
          title:  name,
          textStyle: textStyle ?? TextStyles.medium.copyWith(
            fontSize: fontSize??33.sp,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}