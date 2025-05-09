import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odigo_vendor/framework/controller/ads/ads_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/repository/registration/model/response_model/destination_list_response_model.dart';
import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/framework/controller/ads/add_edit_ads_controller.dart';
import 'package:odigo_vendor/framework/utils/session.dart';
import 'package:odigo_vendor/ui/ads/web/helper/ads_for_widget.dart';
import 'package:odigo_vendor/ui/ads/web/helper/content_length_widget.dart';
import 'package:odigo_vendor/ui/ads/web/helper/upload_document_list_widget.dart';
import 'package:odigo_vendor/ui/ads/web/helper/upload_video_list_widget.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_dialogs.dart';
import 'package:odigo_vendor/framework/controller/auth/vendor_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/framework/repository/package/model/client_list_response_model.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/const/app_enums.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/text_style.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_form_field_dropdown.dart';
import 'package:odigo_vendor/ui/ads/web/helper/header_child_widget.dart';
import 'package:odigo_vendor/ui/ads/web/helper/image_size_radio_widget.dart';
import 'package:odigo_vendor/ui/ads/web/helper/media_type_widget.dart';

class CreateAdsWebForm extends ConsumerWidget with BaseConsumerWidget {
  const CreateAdsWebForm({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final addEditAdsWatch = ref.watch(addEditAdsController);

    return Form(
      key: addEditAdsWatch.formKey,
      child: Consumer(builder: (context, ref, child) {
        final addEditAdsWatch = ref.watch(addEditAdsController);
        final adWatch = ref.watch(adsController);
        // final selectDestinationWatch = ref.watch(selectDestinationController);
        final selectClientWatch = ref.watch(selectClientController);
        final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
        final selectStoreWatch = ref.watch(selectStoreController);

        // final destinationData = vendorRegistrationFormWatch.destinationState.success?.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// select destination dropdown
            SizedBox(
              width: context.width * 0.3,
              child: CommonDropdownInputFormField<DestinationData?>(
                hintText: LocaleKeys.keySelectDestination.localized,
                menuItems: vendorRegistrationFormWatch.destinationState.success?.data,
                items: (vendorRegistrationFormWatch.destinationState.success?.data)
                    ?.map(
                      (item) => DropdownMenuItem<DestinationData>(
                        value: item,
                        child: Text((item.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                      ),
                    )
                    .toList(),
                // height: context.height * 0.049,
                validator: (value) {
                  if (value == null) {
                    return LocaleKeys.keyDestinationRequired.localized;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) async {
                  addEditAdsWatch.updateDestination(value);
                  addEditAdsWatch.updateStore(null);

                  selectStoreWatch.disposeController(isNotify: true);

                  if (Session.getUserType() == UserType.VENDOR.name) {
                    await selectStoreWatch.storeListApi(context, false, destinationUuid: addEditAdsWatch.selectedDestination?.uuid ?? '', dataSize: pageSize100000).then((value) {
                      if (selectStoreWatch.storeListState.success?.status == ApiEndPoints.apiStatus_200) {
                        addEditAdsWatch.updateStoreList(selectStoreWatch.storeListState.success?.data ?? []);
                      }
                    });

                  }
                  // addEditAdsWatch.destinationWiseStoreListApi(context, addEditAdsWatch.selectedDestination?.uuid??'');
                  // addEditAdsWatch.updateStore(null);
                },
              ),
            ),
            SizedBox(
              height: context.height * 0.03,
            ),

            Session.getUserType() == userTypeValue.reverse[UserType.AGENCY]
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// content length second
                      HeaderChildWidget(headerName: LocaleKeys.keyAdsFor.localized, child: const AdsForWidget()),

                      SizedBox(
                        height: context.height * 0.03,
                      ),

                      /// select destination dropdown
                      Visibility(
                        visible: addEditAdsWatch.selectedAdsFor == AdsForEnum.client,
                        child: SizedBox(
                          width: context.width * 0.3,
                          child: CommonDropdownInputFormField<ClientData>(
                            defaultValue: addEditAdsWatch.selectedClient,
                            menuItems: selectClientWatch.clientList,
                            hintText: LocaleKeys.keySelectClients.localized,
                            items: (selectClientWatch.clientList)
                                .map(
                                  (item) => DropdownMenuItem<ClientData>(
                                    value: item,
                                    child: Text((item?.name ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                                  ),
                                )
                                .toList(),
                            // height: context.height * 0.049,
                            validator: (value) {
                              if (value == null) {
                                return LocaleKeys.keyClientRequired.localized;
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              addEditAdsWatch.updateClient(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                :

                // CommonText(title: selectStoreWatch.storeList.length.toString()),

                /// select store dropdown
                SizedBox(
                    width: context.width * 0.3,
                    child: CommonDropdownInputFormField<StoreListData?>(
                      isEnabled: addEditAdsWatch.selectedDestination != null,
                      defaultValue: addEditAdsWatch.selectedStore,
                      menuItems: addEditAdsWatch.storeList,
                      hintText: LocaleKeys.keySelectStore.localized,
                      items: (addEditAdsWatch.storeList)
                          .map(
                            (item) => DropdownMenuItem<StoreListData?>(
                              value: item,
                              child: Text((item?.odigoStoreName ?? '').capsFirstLetterOfSentence, style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 18.sp)),
                            ),
                          )
                          .toList(),
                      // height: context.height * 0.049,
                      validator: (value) {
                        if (value == null) {
                          return LocaleKeys.keyStoreRequired.localized;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        addEditAdsWatch.updateStore(value);
                      },
                    ),
                  ),

            SizedBox(
              height: context.height * 0.03,
            ),

            HeaderChildWidget(headerName: LocaleKeys.keyMediaType.localized, child: const MediaTypeWidget()),

            SizedBox(
              height: context.height * 0.03,
            ),

            /// image size, content length
            addEditAdsWatch.selectedMediaType == MediaTypeEnum.image ? HeaderChildWidget(headerName: LocaleKeys.keyImageCount.localized, child: const ImageCountRadioWidget()) : HeaderChildWidget(headerName: LocaleKeys.keyContentLengthSecond.localized, child: const ContentLengthWidget()),

            SizedBox(
              height: context.height * 0.03,
            ),

            /// upload required documents
            HeaderChildWidget(
                headerName: LocaleKeys.keyUploadImageVideo.localized,
                child: addEditAdsWatch.selectedMediaType == MediaTypeEnum.image
                    ? UploadDocumentListWidget(
                        imageList: addEditAdsWatch.imageList,
                        onTap: (index, file) async {
                          await addEditAdsWatch.updateImage(index, file);
                        },
                        onRemoveTap: (index) async {
                          await addEditAdsWatch.removeImage(index);
                        },
                        isAds: true,
                      )
                    : const UploadVideoListWidget()),

            SizedBox(
              height: context.height * 0.05,
            ),

            /// submit Button
            CommonButton(
              isLoading: addEditAdsWatch.createAdState.isLoading || addEditAdsWatch.uploadDocumentState.isLoading,
              height: context.height * 0.08,
              buttonText: LocaleKeys.keySubmit.localized,
              buttonEnabledColor: AppColors.black,
              buttonDisabledColor: AppColors.clrF7F7FC,
              isButtonEnabled: addEditAdsWatch.isAllFieldValid,
              buttonTextStyle: TextStyles.regular.copyWith(fontSize: 18.sp, color: addEditAdsWatch.isAllFieldValid ? AppColors.white : AppColors.black),
              rightIcon: Icon(
                Icons.arrow_forward,
                color: addEditAdsWatch.isAllFieldValid ? AppColors.white : AppColors.black,
                size: 20.h,
              ),
              onTap: () async {
                final bool? result = addEditAdsWatch.formKey.currentState?.validate();

                if (result == true) {
                  if (Session.getUserType() == userTypeValue.reverse[UserType.AGENCY]) {
                    await addEditAdsWatch.createAdApi(context, destinationUuid: addEditAdsWatch.selectedDestination?.uuid ?? '', agencyUuid: addEditAdsWatch.selectedAdsFor == AdsForEnum.yourself ? Session.getUuid() : Session.getUuid(), clientMasterUuid: addEditAdsWatch.selectedAdsFor == AdsForEnum.client ? addEditAdsWatch.selectedClient?.uuid ?? '' : null).then((value) async {
                      if (addEditAdsWatch.createAdState.success?.status == ApiEndPoints.apiStatus_200) {
                        showCommonSwitchingDialog(
                          context: context,
                          height: 0.4,
                          width: 0.4,
                          key: addEditAdsWatch.percentageLoadingDialogKey,
                          showProgress: true,
                        );
                        await addEditAdsWatch.addAdContentApi(context, adUuid: addEditAdsWatch.createAdState.success?.data?.uuid ?? '');
                        if (addEditAdsWatch.uploadDocumentState.success?.status == ApiEndPoints.apiStatus_200) {
                          ref.read(navigationStackController).pop();
                          if (addEditAdsWatch.selectedAdsFor == AdsForEnum.client) {
                            adWatch.disposeData(isNotify: true);
                            adWatch.updateAgencyOwnAds(false);
                            // await adWatch.adsListApi(context, false, isGetOnlyClient: true);
                                if(context.mounted){
                              await selectClientWatch
                                  .clientListApi(
                                context,
                                false,
                                isAdsAvailable: true,
                              )
                                  .then((value) {
                                if (selectClientWatch
                                        .clientListState.success?.status ==
                                    ApiEndPoints.apiStatus_200) {
                                  adWatch.updateClientList(selectClientWatch
                                          .clientListState.success?.data ??
                                      []);
                                }
                              });
                            }
                          } else {
                            adWatch.disposeData(isNotify: true);
                            adWatch.updateAgencyOwnAds(true);
                            final storesWatch = ref.read(storesController);
                            if(context.mounted){
                              await storesWatch.destinationListApi(context,
                                  pageSize: pageSize100000,
                                  hasAds: true,
                                  activeRecords: true);
                            }
                            if(context.mounted){
                              await adWatch.adsListApi(context, false);
                            }
                          }
                        }
                      }
                    });
                  } else {
                    addEditAdsWatch.createAdApi(context, destinationUuid: addEditAdsWatch.selectedDestination?.uuid ?? '', vendorUuid: Session.getUuid(), storeUuid: addEditAdsWatch.selectedStore?.odigoStoreUuid ?? '').then((value) async {
                      if (addEditAdsWatch.createAdState.success?.status == ApiEndPoints.apiStatus_200) {
                        showCommonSwitchingDialog(
                          context: context,
                          height: 0.4,
                          width: 0.4,
                          key: addEditAdsWatch.percentageLoadingDialogKey,
                          showProgress: true,
                        );
                        await addEditAdsWatch.addAdContentApi(context, adUuid: addEditAdsWatch.createAdState.success?.data?.uuid ?? '');
                        if (addEditAdsWatch.uploadDocumentState.success?.status == ApiEndPoints.apiStatus_200) {
                          // adWatch.adsListApi(context, false);
                          // final storeListWatch = ref.watch(storeListController);
                          final selectStoreWatch = ref.watch(selectStoreController);
                          selectStoreWatch.disposeController(isNotify: true);
                          ref.read(navigationStackController).pop();

                          adWatch.disposeController(isNotify: true);
                          if(context.mounted){
                            await selectStoreWatch
                                .storeListApi(context, false,
                                    destinationUuid: '',
                                    dataSize: pageCount,
                                    isAdsAvailable: true)
                                .then((value) {
                              if (selectStoreWatch
                                      .storeListState.success?.status ==
                                  ApiEndPoints.apiStatus_200) {
                                adWatch.updateStoreList(selectStoreWatch
                                        .storeListState.success?.data ??
                                    []);
                              }
                            });
                          }
                        }
                      }
                    });
                  }
                }
              },
              /*onValidateTap: () {
                bool? result = addEditAdsWatch.formKey.currentState?.validate();

                if (result != null && result) {
                } else {
                  showMessageDialog(
                    context,
                    getErrorMessage(ref),
                    () {
                      Navigator.of(context).pop();
                    },
                  );
                }
              },*/
            ),
          ],
        );
      }),
    );
  }

  String getErrorMessage(WidgetRef ref) {
    final addEditAdsWatch = ref.watch(addEditAdsController);
    String error = '';
    if (addEditAdsWatch.selectedDestination == null) {
      error = LocaleKeys.keyDestinationRequired.localized;
    } else if (addEditAdsWatch.selectedAdsFor == AdsForEnum.client && addEditAdsWatch.selectedClient == null) {
      error = LocaleKeys.keyClientRequired.localized;
    } else if (Session.getUserType() == UserType.VENDOR.name && addEditAdsWatch.selectedDestination != null && addEditAdsWatch.selectedStore == null) {
      error = LocaleKeys.keyStoreRequired.localized;
    }
    return error;
  }
}
