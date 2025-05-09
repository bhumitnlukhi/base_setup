import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/auth/web/helper/agency_registration_form_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_title_back_widget.dart';

class EditAgencyProfileDetailWeb extends ConsumerStatefulWidget {
  const EditAgencyProfileDetailWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<EditAgencyProfileDetailWeb> createState() => _EditAgencyProfileDetailWebState();
}

class _EditAgencyProfileDetailWebState extends ConsumerState<EditAgencyProfileDetailWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final agencyRegistrationFormWatch = ref.read(agencyRegistrationFormController);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      agencyRegistrationFormWatch.disposeController(isNotify: true);
      await _apiCall();
    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
    final profileWatch = ref.watch(profileController);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ///Top Widget
        CommonTitleBackWidget(
          title: LocaleKeys.keyEditProfile.localized,
        ),

        SizedBox(
          height: context.height * 0.03,
        ),

        ///Agency Form
        Expanded(
            child: agencyRegistrationFormWatch.getAgencyDetailState.isLoading || profileWatch.getAgencyDocumentsState.isLoading || agencyRegistrationFormWatch.countryState.isLoading || agencyRegistrationFormWatch.cityState.isLoading || agencyRegistrationFormWatch.state.isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.black,
              ),
            )
                : const AgencyRegistrationFormWidget(isEdit: true))
      ],
    ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.035);
  }

  _apiCall() async {
    final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
    final profileWatch = ref.watch(profileController);
    await profileWatch.getAgencyDocumentsApi(context);
    await agencyRegistrationFormWatch.addCloudImage(ref);
    if(mounted){
      await agencyRegistrationFormWatch.getAgencyDetailApi(context);
    }
  }


}
