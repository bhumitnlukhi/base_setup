import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/agency_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/profile/profile_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/profile/web/helper/change_email_dialog.dart';
import 'package:odigo_vendor/ui/profile/web/helper/change_email_or_mobile_verify_otp_dialog.dart';
import 'package:odigo_vendor/ui/profile/web/helper/change_mobile_dialog.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/cache_image.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';

class ProfileVerifiedDocmentsWidget extends StatelessWidget {
  const ProfileVerifiedDocmentsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final profileWatch = ref.watch(profileController);
        final agencyRegistrationFormWatch = ref.watch(agencyRegistrationFormController);
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Left Widget
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///User info
                  CommonText(
                    title: LocaleKeys.keyUserInformation.localized,
                    textStyle: TextStyles.regular.copyWith(fontSize: 22.sp),
                  ).paddingOnly(bottom: context.height * 0.025),

                  ///owner name
                  Visibility(
                    visible: profileWatch.profileDetailState.success?.data?.entityType != UserType.VENDOR.name,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                          title: LocaleKeys.keyOwnerName.localized,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.grey8F8F8F,
                            fontSize: 16.sp,
                          ),
                        ).paddingOnly(bottom: context.height * 0.007),

                        ///owner Value
                        CommonText(
                          title: agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.ownerName ?? '-',
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.black171717,
                            fontSize: 18.sp,
                          ),
                        ),

                        Divider(
                          color: AppColors.clr707070.withOpacity(0.2),
                        ).paddingSymmetric(vertical: context.height * 0.008),
                      ],
                    ),
                  ),

                  ///Email Field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            title: LocaleKeys.keyEmaiID.localized,
                            textStyle: TextStyles.regular.copyWith(
                              color: AppColors.grey8F8F8F,
                              fontSize: 16.sp,
                            ),
                            maxLines: 3,
                          ).paddingOnly(bottom: context.height * 0.008),

                          ///Email Value
                          SizedBox(
                            width: context.width * 0.250,
                            child: CommonText(
                              title: '${profileWatch.profileDetailState.success?.data?.email}',
                              textStyle: TextStyles.regular.copyWith(
                                color: AppColors.black171717,
                                fontSize: 18.sp,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),

                      ///Change Email Dialog
                      InkWell(
                        onTap: () {
                          profileWatch.clearFormData();
                          showCommonWebDialog(
                              keyBadge: profileWatch.changeEmailDialogKey,
                              context: context,
                              dialogBody: ChangeEmailDialog(
                                onTap: () async {
                                  ///Send Otp
                                  await sendOTPApi(context, ref);
                                },
                              ),
                              height: 0.6,
                              width: 0.5);
                        },
                        child: CommonText(
                          title: LocaleKeys.keyChangeEmail.localized,
                          textStyle: TextStyles.regular.copyWith(color: AppColors.blue0083FC, fontSize: 18.sp, decorationColor: AppColors.blue0083FC, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    color: AppColors.clr707070.withOpacity(0.2),
                  ).paddingSymmetric(vertical: context.height * 0.008),

                  /// Number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            title: LocaleKeys.keyMobileNumber.localized,
                            textStyle: TextStyles.regular.copyWith(
                              color: AppColors.grey8F8F8F,
                              fontSize: 16.sp,
                            ),
                            maxLines: 3,
                          ).paddingOnly(bottom: context.height * 0.007),

                          ///Number Value
                          CommonText(
                            title: '${profileWatch.profileDetailState.success?.data?.contactNumber}',
                            textStyle: TextStyles.regular.copyWith(
                              color: AppColors.black171717,
                              fontSize: 18.sp,
                            ),
                            maxLines: 3,
                          )
                        ],
                      ),

                      ///Change Mobile Number Dialog
                      InkWell(
                        onTap: () {
                          showCommonWebDialog(
                            context: context,
                            keyBadge: profileWatch.changeEmailDialogKey,
                            dialogBody: const ChangeMobileDialog(),
                            width: 0.5,
                          );
                        },
                        child: CommonText(
                          title: LocaleKeys.keyChangeMobile.localized,
                          textStyle: TextStyles.regular.copyWith(color: AppColors.blue0083FC, fontSize: 18.sp, decorationColor: AppColors.blue0083FC, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),

                  ///Address
                  Visibility(
                    visible: profileWatch.profileDetailState.success?.data?.entityType != UserType.VENDOR.name,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: AppColors.clr707070.withOpacity(0.2),
                        ).paddingSymmetric(vertical: context.height * 0.008),

                        CommonText(
                          title: LocaleKeys.keyAddress.localized,
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.grey8F8F8F,
                            fontSize: 16.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.007),

                        ///Address Value
                        CommonText(
                          title: '${agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.houseNumber?.capsFirstLetterOfSentence}, ${agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.streetName?.capsFirstLetterOfSentence}, ${agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.addressLine1?.capsFirstLetterOfSentence}, ${agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.addressLine2?.capsFirstLetterOfSentence}, ${agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.countryName?.capsFirstLetterOfSentence}, ${agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.stateName?.capsFirstLetterOfSentence}, ${agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.cityName?.capsFirstLetterOfSentence}, ${agencyRegistrationFormWatch.getAgencyDetailState.success?.data?.postalCode?.capsFirstLetterOfSentence}.',
                          textStyle: TextStyles.regular.copyWith(
                            color: AppColors.black171717,
                            fontSize: 18.sp,
                          ),
                          maxLines: 3,
                        ).paddingOnly(bottom: context.height * 0.02),
                      ],
                    ),
                  ),
                ],
              ).paddingOnly(right: context.width * 0.03),
            ),

            ///Right Widget
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText(
                  title: LocaleKeys.keyDocument.localized,
                  textStyle: TextStyles.regular.copyWith(fontSize: 22.sp),
                ).paddingOnly(bottom: context.height * 0.025),

                ///Documents List
                Expanded(
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: Session.getUserType() == UserType.VENDOR.name ? profileWatch.getVendorDocumentsState.success?.data?.vendorDocuments?.length ?? 0 : profileWatch.getAgencyDocumentsState.success?.data?.agencyDocuments?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        if ((profileWatch.getVendorDocumentsState.success != null && profileWatch.getVendorDocumentsState.success?.data != null && profileWatch.getVendorDocumentsState.success?.data?.vendorDocuments != null) || (profileWatch.getAgencyDocumentsState.success != null && profileWatch.getAgencyDocumentsState.success?.data != null && profileWatch.getAgencyDocumentsState.success?.data?.agencyDocuments != null)) {
                          if ((profileWatch.getVendorDocumentsState.success?.data?.vendorDocuments?[index].bytes != null && profileWatch.getVendorDocumentsState.success?.data?.vendorDocuments?[index].url?.contains('.pdf') == true) || (profileWatch.getAgencyDocumentsState.success?.data?.agencyDocuments?[index].bytes != null && profileWatch.getAgencyDocumentsState.success?.data?.agencyDocuments?[index].url?.contains('.pdf') == true)) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: InkWell(
                                onTap: () {
                                  String url = Session.getUserType() == UserType.VENDOR.name ? (profileWatch.getVendorDocumentsState.success?.data?.vendorDocuments?[index].url ?? '') : (profileWatch.getAgencyDocumentsState.success?.data?.agencyDocuments?[index].url ?? '');
                                  profileWatch.openPdf(url);
                                },
                                child: Container(
                                  width: context.width * 0.19,
                                  height: context.height * 0.28,
                                  color: AppColors.grey7E7E7E.withOpacity(0.2),
                                  child: Icon(
                                    Icons.picture_as_pdf_outlined,
                                    size: 50.h,
                                    color: AppColors.grey8A8A8A,
                                  ),
                                ),
                              ),
                            );
                          } else if ((profileWatch.getVendorDocumentsState.success?.data?.vendorDocuments?[index].url?.contains('.pdf') == false) || (profileWatch.getAgencyDocumentsState.success?.data?.agencyDocuments?[index].url?.contains('.pdf') == false)) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: CacheImage(
                                imageURL: Session.getUserType() == UserType.VENDOR.name ? profileWatch.getVendorDocumentsState.success?.data?.vendorDocuments![index].url ?? '' : profileWatch.getAgencyDocumentsState.success?.data?.agencyDocuments?[index].url ?? '',
                                width: context.width * 0.19,
                                height: context.height * 0.28,
                                placeholderImage: Assets.svgs.svgDocumentPlaceholder.keyName,
                                contentMode: BoxFit.fill,
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: context.height * 0.3,
                        mainAxisSpacing: context.height * 0.02,
                        crossAxisSpacing: context.width * 0.01,
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        );
      },
    );
  }

  ///Send Otp
  sendOTPApi(BuildContext context, WidgetRef ref) async {
    final profileWatch = ref.watch(profileController);
    if (profileWatch.profileDetailState.success?.data?.email == profileWatch.newEmailController.text) {
      showCommonErrorDialogNew(context: context, message: LocaleKeys.keyOldEmailAndNewValidation.localized);
    } else {
      ///Check Password Api
      await profileWatch.checkPassword(context, profileWatch.emailPasswordController.text);
      if (profileWatch.checkPasswordState.success?.status == ApiEndPoints.apiStatus_200 && context.mounted) {
        ///Send Otp Api
        await profileWatch.sendOtpApi(context, email: profileWatch.newEmailController.text);
        if (profileWatch.sendOtpState.success?.status == ApiEndPoints.apiStatus_200) {
          if (profileWatch.changeEmailDialogKey.currentContext != null) {
            Navigator.of(profileWatch.changeEmailDialogKey.currentContext!).pop();
            profileWatch.startCounter();
            if (context.mounted) {
              showCommonWebDialog(
                context: context,
                keyBadge: profileWatch.sendOtpDialogKey,
                height: 0.65,
                width: 0.5,
                dialogBody: ChangeEmailOrPhoneVerifyOtpDialog(
                  isEmail: true,
                  onEditTap: () {
                    profileWatch.counter?.cancel();
                    profileWatch.changeEmailOrMobileOtpController.clear();
                    if (profileWatch.sendOtpDialogKey.currentContext != null) {
                      Navigator.pop(profileWatch.sendOtpDialogKey.currentContext!);

                      showCommonWebDialog(
                          keyBadge: profileWatch.changeEmailDialogKey,
                          context: context,
                          dialogBody: ChangeEmailDialog(
                            onTap: () async {
                              ///Send Otp
                              await sendOTPApi(context, ref);
                            },
                          ),
                          height: 0.65,
                          width: 0.5);
                    }
                  },
                ).paddingSymmetric(
                  horizontal: context.width * 0.03,
                  vertical: context.height * 0.03,
                ),
              );
            }
          }
        }
      }
    }
  }
}
