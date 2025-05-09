import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/signup_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/auth/web/helper/cms_widget.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class CommonTitleBackWidget extends ConsumerWidget {
  final String title;
  final bool isShowMoreVert;
  final void Function()? onBackTap;

  const CommonTitleBackWidget({super.key, required this.title, this.isShowMoreVert = false, this.onBackTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        InkWell(
            onTap: onBackTap ?? () {
              ref.read(navigationStackController).pop();
            },
            child: CommonSVG(
              strIcon: Assets.svgs.svgBackButtonWithoutBg.keyName,
              height: context.height * 0.025,
              width: context.width * 0.025,
              isRotate: true,
            )),
        CommonText(
          title: title,
          textStyle: TextStyles.regular.copyWith(color: AppColors.black171717, fontSize: 22.sp),
        ).paddingOnly(left: 19.h),
        const Spacer(),
        isShowMoreVert
            ? PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 30.h,
                ),
                onSelected: (value) async {
                  if (value == CmsType.aboutUs.name) {
                    callCMSAPI(ref: ref, context: context, cmsType: CmsType.aboutUs, title: 'About us');
                  } else if (value == CmsType.termsAndCondition.name) {
                    callCMSAPI(ref: ref, context: context, cmsType: CmsType.termsAndCondition, title: 'Terms And Condition');
                  } else {
                    callCMSAPI(ref: ref, context: context, cmsType: CmsType.privacyPolicy, title: 'Privacy Policy');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: CmsType.privacyPolicy.name,
                    child: Text(LocaleKeys.keyPrivacyPolicy.localized),
                  ),
                  PopupMenuItem(
                    value: CmsType.termsAndCondition.name,
                    child: Text(LocaleKeys.keyTermsAndCondition.localized),
                  ),
                  PopupMenuItem(
                    value: CmsType.aboutUs.name,
                    child: Text(LocaleKeys.keyAboutUs.localized),
                  ),
                ],
              )
            : const SizedBox()
      ],
    );
  }

  void callCMSAPI({required WidgetRef ref, required BuildContext context, required CmsType cmsType, required String title}) async {
    final signUpWatch = ref.read(signUpController);
    await signUpWatch.cmsAPI(context, cmsType: cmsType.name).then((value) {
      if (value.success?.status == ApiEndPoints.apiStatus_200) {
        showCMSDialog(
            context,
            SizedBox(
              height: 600.h,
              width: 800.w,
              child: SingleChildScrollView(
                child: CMSWidget(
                  title: title,
                  content: value.success?.data?.fieldValue ?? '',
                ),
              ),
            ),
            () {});
      }
    });
  }
}
