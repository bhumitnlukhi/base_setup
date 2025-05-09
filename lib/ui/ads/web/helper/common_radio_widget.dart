import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonRadioWidget extends StatelessWidget {
  final String name;
  final bool isSelect;
  final Function()? onTap;
  const CommonRadioWidget({super.key, required this.name, required this.isSelect, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isSelect ? selectedRadio(context) : unSelectedRadio(context),
          SizedBox(width: context.width * 0.005,),
          CommonText(title: name,fontSize: 18.sp,clrfont: AppColors.black),
        ],
      ),
    );
  }

  Widget selectedRadio(BuildContext context){
    return Container(
      height: context.height *0.03,width: context.width *0.03,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.clr009AF1)
      ),
      child: Container(
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.clr009AF1
        ),
      ).paddingAll(context.height * 0.003),
    );
  }

  Widget unSelectedRadio(BuildContext context){
    return Container(
      height: context.height *0.03,width: context.width *0.03,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.clrDEDEDE)
      ),
    );
  }
}
