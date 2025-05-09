import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CMSWidget extends StatelessWidget {
  final String content;
  final String title;

  const CMSWidget({super.key, required this.content, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CommonText(
              title: title,
              textStyle: TextStyles.regular.copyWith(
                color: AppColors.black,
                fontSize: 22.sp,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgClose.path,
              ),
            ),
          ],
        ),
        HtmlWidget(
          content,
          textStyle: TextStyles.regular.copyWith(fontSize: 14.sp, color: AppColors.black),
        ).paddingOnly(top: 16.h),
      ],
    ).paddingAll(20.h);
  }
}
