import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/vendor_registration_form_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/add_edit_store_controller.dart';
import 'package:odigo_vendor/framework/controller/stores/stores_controller.dart';
import 'package:odigo_vendor/framework/provider/network/api_end_points.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/stores/web/helper/destination_dropdown_widget.dart';
import 'package:odigo_vendor/ui/stores/web/helper/store_dropdown_widget.dart';
import 'package:odigo_vendor/ui/utils/anim/fade_box_transition.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_button.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_text.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_back_widget.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';

class AddEditStoreWeb extends ConsumerStatefulWidget {
  final bool? isEdit;

  const AddEditStoreWeb({Key? key, this.isEdit}) : super(key: key);

  @override
  ConsumerState<AddEditStoreWeb> createState() => _AddEditStoreWebState();
}

class _AddEditStoreWebState extends ConsumerState<AddEditStoreWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget {
  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final addEditStoreWatch = ref.watch(addEditStoreController);
      final storeWatch = ref.read(storesController);
      final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);
      addEditStoreWatch.disposeController(isNotify: true);
      vendorRegistrationFormWatch.disposeStore();
      // storeWatch.disposeController(isNotify: true);
      // await addEditStoreWatch.storeListApi(context, pageSize: 10000);
      await storeWatch.destinationListApi(context, pageSize: pageSize100000, activeRecords: true);
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
    final addEditStoreWatch = ref.watch(addEditStoreController);
    final storeWatch = ref.watch(storesController);
    // final vendorRegistrationFormWatch = ref.watch(vendorRegistrationFormController);

    return Stack(

      children: [


        Form(
                key: addEditStoreWatch.formKey,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.white,
                  ),
                  child: FadeBoxTransition(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonBackTopWidget(
                          title: widget.isEdit ?? false ? LocaleKeys.keyEditStore.localized : LocaleKeys.keyCreateStore.localized,
                          onTap: () {
                            ref.read(navigationStackController).pop();
                          },
                        ).paddingOnly(bottom: context.height * 0.034),

                        SizedBox(height: context.height * 0.030),

                        CommonText(
                          title: LocaleKeys.keyStoreDetail.localized,
                          textStyle: TextStyles.regular.copyWith(fontSize: 22.sp, color: AppColors.black171717.withOpacity(0.5)),
                        ),

                        SizedBox(height: context.height * 0.030),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// select destination dropdown
                            Expanded(
                              child: DestinationDropdownWidget(
                                destinationList: storeWatch.destinationList,
                                onChanged: (selectedDestination) async {
                                  addEditStoreWatch.updateSelectedDestination(selectedDestination);
                                  await addEditStoreWatch.storeListApi(context, pageSize: pageSize100000, destinationUuid: addEditStoreWatch.selectedDestination?.uuid??'');

                                  // await vendorRegistrationFormWatch.storeListApi(context, destinationUuid: addEditStoreWatch.selectedDestination?.uuid??'');

                                },
                                selectedDestination: addEditStoreWatch.selectedDestination,
                              ),
                            ),

                            SizedBox(width: context.width * 0.02),

                            /// select store dropdown
                            Visibility(
                              visible: addEditStoreWatch.storeListState.success?.data?.isNotEmpty??false ||   addEditStoreWatch.storeListState.success?.data!=[],
                              child: Expanded(
                                child: StoreDropdownWidget(
                                  storeList: addEditStoreWatch.storeListState.success?.data ?? [],
                                  onChanged: (selectedStore) {
                                    addEditStoreWatch.updateSelectedStore(selectedStore);
                                  },
                                  selectedStore: addEditStoreWatch.selectedStore,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: context.height * 0.030),

                        const Spacer(),

                        Visibility(
                          visible: addEditStoreWatch.storeListState.success?.data?.isEmpty??false ||   addEditStoreWatch.storeListState.success?.data==[],
                          child: Align(
                            alignment: Alignment.center,
                            child: EmptyStateWidget(
                              imgName: Assets.svgs.svgNoData.keyName,
                              title: LocaleKeys.keyNoStoresFound.localized,
                            ),
                          ),
                        ),

                        const Spacer(),

                        /// save button
                        CommonButton(
                          isButtonEnabled: true,
                          buttonText: LocaleKeys.keySave.localized,
                          buttonEnabledColor: AppColors.blue009AF1,
                          width: context.width * 0.090,
                          height: context.height * 0.049,
                          isLoading: addEditStoreWatch.assignStoreState.isLoading || storeWatch.storeListState.isLoading,
                          buttonTextSize: 14.sp,
                          onTap: () {
                            final bool? result = addEditStoreWatch.formKey.currentState?.validate();
                            if (result == true && (addEditStoreWatch.storeListState.success?.data?.isNotEmpty??false ||   addEditStoreWatch.storeListState.success?.data!=[])) {
                              addEditStoreWatch.assignStoreApi(context).then((value) {
                                if (addEditStoreWatch.assignStoreState.success?.status == ApiEndPoints.apiStatus_200) {
                                  storeWatch.storeListApiCall(context, activeRecords: true).then((value) {
                                    ref.read(navigationStackController).pop();
                                  });
                                }
                              });
                            }
                          },
                        ).alignAtBottomRight().paddingOnly(bottom: context.height * 0.030)
                      ],
                    ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
                  ),
                ),
              ),
        DialogProgressBar(isLoading: (storeWatch.destinationListState.isLoading) || (addEditStoreWatch.storeListState.isLoading)),
      ],
    );
  }
}
