import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/login_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/otp_verification_controller.dart';
import 'package:odigo_vendor/framework/controller/auth/signup_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/auth/web/helper/agency_registration_form_widget.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_svg.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class AgencyRegistrationFormWeb extends ConsumerStatefulWidget {
  const AgencyRegistrationFormWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<AgencyRegistrationFormWeb> createState() => _AgencyRegistrationFormWebState();
}

class _AgencyRegistrationFormWebState extends ConsumerState<AgencyRegistrationFormWeb> with BaseConsumerStatefulWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final agencyRegistrationFormWatch = ref.read(agencyRegistrationFormController);
      final loginWatch = ref.read(loginController);
      final otpVerificationWatch = ref.watch(otpVerificationController);

      agencyRegistrationFormWatch.disposeController(isNotify: true);
      await agencyRegistrationFormWatch.countryListApi(context).then((value) async {
        if (agencyRegistrationFormWatch.countryState.success?.status == ApiEndPoints.apiStatus_200) {
          agencyRegistrationFormWatch.selectedCountry = agencyRegistrationFormWatch.countryState.success?.data?.firstWhere((element) => (element.uuid == (loginWatch.loginState.success?.data?.countryUuid) || (element.uuid == otpVerificationWatch.verifyOtpForSignUpState.success?.data?.countryUuid)));
          await agencyRegistrationFormWatch.stateListApi(context, countryUuid: agencyRegistrationFormWatch.selectedCountry?.uuid);
        }
      });
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final loginWatch = ref.watch(loginController);
    final signUpWatch = ref.watch(signUpController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// Back Button
        InkWell(
          child: CommonSVG(strIcon: Assets.svgs.svgBackRounded.keyName, height: context.height * 0.077, width: context.width * 0.077),
          onTap: () {
            ref.read(navigationStackController).pop();
            signUpWatch.disposeController(isNotify: true);
            loginWatch.disposeController(isNotify: true);

            ///For Clear Token
            Session.userBox.clear();
            Session.saveLocalData(keyUserType, UserType.AGENCY);
          },
        ),

        SizedBox(
          height: context.height * 0.03,
        ),

        ///Registration Form Title
        CommonText(
          title: LocaleKeys.keyRegistrationForm.localized,
          textStyle: TextStyles.semiBold.copyWith(fontSize: 26.sp, color: AppColors.black),
        ),

        SizedBox(
          height: context.height * 0.01,
        ),

        ///Fill Up The Registration Form To Create The Account Title
        CommonText(
          title: LocaleKeys.keyFillUpTheRegistrationFormToCreateTheAccount.localized,
          textStyle: TextStyles.regular.copyWith(fontSize: 21.sp, color: AppColors.black),
        ),

        SizedBox(
          height: context.height * 0.03,
        ),

        const Expanded(child: AgencyRegistrationFormWidget())
      ],
    ).paddingSymmetric(horizontal: context.width * 0.05, vertical: context.height * 0.05);
  }
}
