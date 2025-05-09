import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/const/form_validations.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class LoginFormWeb extends ConsumerStatefulWidget {
  const LoginFormWeb({super.key});

  @override
  ConsumerState<LoginFormWeb> createState() => _LoginFormWebState();
}

class _LoginFormWebState extends ConsumerState<LoginFormWeb> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final loginWatch = ref.read(loginController);
      loginWatch.disposeController(isNotify: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginWatch = ref.watch(loginController);
    return FadeBoxTransition(
      child: Form(
        key: loginWatch.formKey,
        child: SingleChildScrollView(
          child: Theme(
            data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent, hoverColor: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Enter Email Field
                CommonInputFormField(
                  textEditingController: loginWatch.emailController,
                  hintText: LocaleKeys.keyEmailId.localized,
                  textInputType: TextInputType.emailAddress,
                  // fieldHeight: context.height * 04,
                  onChanged: (value) {
                    loginWatch.checkIfAllFieldsValid();
                  },
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    return validateEmail(value);
                  },
                  textInputFormatter: [
                    FilteringTextInputFormatter.deny(constEmailRegex),
                    convertInputToSmallCase()
                  ],
                  onFieldSubmitted: (value) {
                    context.nextField;
                  },
                ),
                SizedBox(
                  height: 30.h,
                ),

                ///Enter Password Text Field
                CommonInputFormField(
                  textEditingController: loginWatch.passwordController,
                  hintText: LocaleKeys.keyPassword.localized,
                  textInputAction: TextInputAction.done,
                  obscureText: loginWatch.isPasswordHidden,
                  maxLength: 16,
                  validator: (value) {
                    return validatePassword(value);
                  },
                  onChanged: (value) {
                    loginWatch.checkIfAllFieldsValid();
                  },
                  suffixWidget: InkWell(
                    onTap: () {
                      loginWatch.changePasswordVisibility();
                    },
                    child: CommonSVG(
                      height: context.height * 0.024,
                      width: context.width * 0.024,
                      boxFit: BoxFit.scaleDown,
                      strIcon: loginWatch.isPasswordHidden ? Assets.svgs.svgPasswordUnhide.keyName : Assets.svgs.svgPasswordHide.keyName,
                      svgColor: AppColors.black272727,
                    ),
                  ).paddingOnly(right: 20.w),
                  onFieldSubmitted: (value) async {
                    if(loginWatch.isAllFieldsValid) {
                      await _loginApi(ref, context);
                    }
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),

                ///Forget Password Tappable Text (Navigate to forgot Password Screen)
                InkWell(
                  onTap: () {
                    loginWatch.disposeController(isNotify: true);
                    ref.read(navigationStackController).push(const NavigationStackItem.forgotPassword());
                  },
                  child: Row(
                    children: [
                      CommonText(
                        title: LocaleKeys.keyForgotPassword.localized,
                        textStyle: TextStyles.regular.copyWith(
                          fontSize: 24.sp,
                          color: AppColors.black,
                        ),
                      ),
                      CommonText(
                        title: '?',
                        textStyle: TextStyles.regular.copyWith(
                          fontSize: 24.sp,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loginApi(WidgetRef ref, BuildContext context) async {
    final loginWatch = ref.watch(loginController);
    await loginWatch.loginApi(context, ref: ref);
  }
}
