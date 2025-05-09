import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class TabWidgetTile extends StatelessWidget {
  final String name;
  final bool value;
  const TabWidgetTile({super.key, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        final loginWatch = ref.watch(loginController);
        return InkWell(
          onTap: (){
            loginWatch.updateLogin(value);
          },
          child: Container(
            height: context.height * 0.065,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: loginWatch.isLogin == value ? AppColors.transparent : AppColors.clrD6D6D6),
              color: loginWatch.isLogin == value ? AppColors.clr009AF1 : AppColors.clrF7F7FC,
            ),
            alignment: Alignment.center,
            child: CommonText(
              title: name,
              fontSize: 16.sp,
              clrfont: loginWatch.isLogin == value ? AppColors.clrF7F7FC : AppColors.clr626262,
            ).paddingSymmetric(horizontal: context.width * 0.03),
          ),
        );
      }
    );
  }
}
