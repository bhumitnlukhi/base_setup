import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonImportWidget extends StatelessWidget with BaseStatelessWidget{
  final GestureTapCallback? onTap;
  const CommonImportWidget({Key? key, this.onTap}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    return  InkWell(
      onTap:onTap??(){},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.width*0.02,vertical: context.height*0.017,),
        decoration: BoxDecoration(
          color:AppColors.clrF7F7FC,
          border: Border.all(color:AppColors.greyD6D6D6 ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            CommonSVG(strIcon:Assets.svgs.svgImport.keyName).paddingOnly(right: 6.w),
            CommonText(
              title:LocaleKeys.keyImport.localized,
              textStyle: TextStyles.regular.copyWith(color:AppColors.clr828282,fontSize: 14.sp),
            ).paddingOnly(right: 6.w),
          ],
        ),
      ),
    );
  }
}
