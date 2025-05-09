import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonHeaderTitleWidget extends StatelessWidget {
  final String header;
  final String value;
  const CommonHeaderTitleWidget({super.key, required this.header, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(title: header, textStyle: TextStyles.regular.copyWith(color: AppColors.grey8F8F8F,fontSize: 16.sp),),
        SizedBox(height: context.height*0.008,),
        CommonText(title: value,maxLines: 5, textStyle: TextStyles.regular.copyWith(color: AppColors.black171717,fontSize: 16.sp),),
      ],
    );
  }
}
