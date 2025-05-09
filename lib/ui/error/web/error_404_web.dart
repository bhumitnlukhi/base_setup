import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';

class ErrorWeb extends ConsumerStatefulWidget {
  final ErrorType? errorType;

  const ErrorWeb({Key? key, this.errorType}) : super(key: key);

  @override
  ConsumerState<ErrorWeb> createState() => _ErrorWebState();
}

class _ErrorWebState extends ConsumerState<ErrorWeb> {
  String errorAsset = '';
  String buttonText = '';

  @override
  void initState() {
    super.initState();
    switch (widget.errorType) {
      case null:
        break;
      case ErrorType.error403:
        errorAsset = Assets.anim.animError403.keyName;
        buttonText = LocaleKeys.keyBackToLogin.localized;
        break;
      case ErrorType.error404:
        if (Session.getUserAccessToken().isNotEmpty) {
          errorAsset = Assets.anim.animError404.keyName;
          buttonText = LocaleKeys.keyBackToHome.localized;
        } else {
          buttonText = LocaleKeys.keyBackToLogin.localized;
        }
        break;
      case ErrorType.noInternet:
        errorAsset = Assets.anim.animError404.keyName;
        buttonText = LocaleKeys.keyRefresh.localized;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Lottie.asset(errorAsset, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 10.h,
            child: CommonButton(
              width: context.width * 0.15,
              buttonEnabledColor: AppColors.white.withOpacity(0.18),
              isButtonEnabled: true,
              height: context.height * 0.08,
              // prefixIcon: Icon(CupertinoIcons.chevron_back, color: AppColors.white, size: 30.r).paddingOnly(left: 10.w),
              buttonText: buttonText,
              onTap: () {
                switch (widget.errorType) {
                  case null:
                  case ErrorType.error403:
                    ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.startJourney());
                    ref.read(navigationStackController).push(const NavigationStackItem.login());
                  case ErrorType.error404:
                    if (Session.getUserAccessToken().isNotEmpty) {
                      ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.dashBoard());
                    } else {
                      ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.startJourney());
                      ref.read(navigationStackController).push(const NavigationStackItem.login());
                    }
                  case ErrorType.noInternet:
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
