import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonBackTopWidget extends StatelessWidget {
  final String title;
  final Function() onTap;

  const CommonBackTopWidget({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: CommonSVG(
            strIcon: Assets.svgs.svgLeftArrow.keyName,
            height: context.height * 0.025,
            width: context.width * 0.025,
            isRotate: true,
          ).paddingOnly(right: context.width*0.02),
        ),
        CommonText(
          title: title,
          textStyle: TextStyles.regular.copyWith(
            color: AppColors.black,
            fontSize: 22.sp,
          ),
        )
      ],
    );
  }



}
