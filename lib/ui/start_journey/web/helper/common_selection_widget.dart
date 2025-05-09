import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonSelectionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final UserType type;
  const CommonSelectionWidget({super.key, required this.icon, required this.title, required this.description, required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        return InkWell(
          onTap: (){
            Session.saveLocalData(keyUserType, type.name);
            ref.read(navigationStackController).push(const NavigationStackItem.login());
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.clr009AF1),
              color: AppColors.clrF7F7FC
            ),
            child: Row(
              children: [
                CommonSVG(
                    strIcon: icon,
                    height: context.height * 0.075,
                    width: context.width * 0.075,
                ),
                SizedBox(width: context.width * 0.01,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(title: title,fontSize: 18.sp,fontWeight: TextStyles.fwMedium,),

                      SizedBox(height: context.height * 0.003,),

                      CommonText(title: description,maxLines: 3,fontSize: 16.sp,fontWeight: TextStyles.fwLight,),

                    ],
                  ),
                )
              ],
            ).paddingAll(context.height * 0.03),
          ),
        );
      }
    );
  }
}
