import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/dashbaord/dashboard_controller.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/profile/shimmer/profile_detail_shimmer.dart';
import 'package:odigo_vendor/ui/profile/web/helper/profile_center_info_widget.dart';
import 'package:odigo_vendor/ui/profile/web/helper/profile_verified_docments_widget.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_title_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/language_selection_dropdown.dart';

class ProfileWeb extends ConsumerStatefulWidget {
  const ProfileWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileWeb> createState() => _ProfileWebState();
}

class _ProfileWebState extends ConsumerState<ProfileWeb> with BaseConsumerStatefulWidget,BaseDrawerPageWidget{

  ///Init Override
  @override
  void initState() {
    super.initState();
    final profileWatch = ref.read(profileController);
    profileWatch.disposeController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      await _apiCall();

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
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final profileWatch = ref.watch(profileController);
    final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
    return Column(
      children: [
        ///Top Widget
       Row(
         children: [
           Expanded(flex: 5,child: CommonTitleBackWidget(onBackTap: () {
             ref.read(dashboardController).notify();
             ref.read(navigationStackController).pop();
           }, title: LocaleKeys.keyProfile.localized,isShowMoreVert: true)),
           SizedBox(width: 14.w,),
           const Expanded(flex: 1,child: LanguageSelectionDropdown())
         ],
       ),
        SizedBox(
            height: context.height*0.04
        ),
         Expanded(
          child: agencyRegistrationFormWatch.getAgencyDetailState.isLoading|| profileWatch.profileDetailState.isLoading || profileWatch.getVendorDocumentsState.isLoading || profileWatch.getAgencyDocumentsState.isLoading?const ProfileDetailShimmer():const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Profile Info Widget (Initial,Change Password)
              ProfileCenterInfoWidget(),
              ///Profile Verified Document Widget
              Expanded(child: ProfileVerifiedDocmentsWidget())
            ],
          ),
        ),

      ],
    ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.035);
  }

  ///Api Call
  _apiCall() async{
    final profileWatch = ref.watch(profileController);
    final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
    await profileWatch.getProfileDetail(context);
    if(profileWatch.profileDetailState.success?.status==ApiEndPoints.apiStatus_200){
      if(mounted){
        Session.getUserType() == UserType.VENDOR.name
            ? await profileWatch.getVendorDocumentsApi(context)
            : await profileWatch.getAgencyDocumentsApi(context);
      }
      if(Session.getUserType()==UserType.AGENCY.name){
        if(mounted){
          await agencyRegistrationFormWatch.getAgencyDetailApi(context);
        }
      }
    }

  }

}
