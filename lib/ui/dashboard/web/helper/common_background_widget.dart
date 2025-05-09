import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class CommonBackGroundWidget extends StatelessWidget with BaseStatelessWidget {
  final Color? backGroundColor;
  final Widget content;
  final double? width;
  final double? height;
  const CommonBackGroundWidget({super.key, this.backGroundColor, required this.content,  this.width, this.height});


  @override
  Widget buildPage(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding:EdgeInsets.only(top: 25.h,bottom: 25.h,left:25.w,right: 25.w) ,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color:backGroundColor?? AppColors.clrF7F9FB,
      ),
      child: content,
    );
  }
}
