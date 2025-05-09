import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/clients/clients_controller.dart';
import 'package:odigo_vendor/framework/controller/package/select_client_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/framework/utils/extension/extension.dart';
import 'package:odigo_vendor/framework/utils/extension/string_extension.dart';
import 'package:odigo_vendor/ui/clients/web/helper/clients_list_widget.dart';
import 'package:odigo_vendor/ui/routing/navigation_stack_item.dart';
import 'package:odigo_vendor/ui/routing/stack.dart';
import 'package:odigo_vendor/ui/utils/helper/base_drawer_page_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/app_strings.g.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';
import 'package:odigo_vendor/ui/utils/widgets/common_top_row_web.dart';
import 'package:odigo_vendor/ui/utils/widgets/dialog_progressbar.dart';

class ClientsWeb extends ConsumerStatefulWidget {
  final String? clientUuid;
  const ClientsWeb({Key? key, this.clientUuid}) : super(key: key);

  @override
  ConsumerState<ClientsWeb> createState() => _ClientsWebState();
}

class _ClientsWebState extends ConsumerState<ClientsWeb> with BaseConsumerStatefulWidget, BaseDrawerPageWidget{

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final clientsWatch = ref.watch(clientsController);
      clientsWatch.disposeController(isNotify : true);
      final selectClientWatch = ref.watch(selectClientController);
      selectClientWatch.disposeController(isNotify : true);
      await selectClientWatch.clientListApi(context, false);

      selectClientWatch.scrollController.addListener(() async{
        if (selectClientWatch.clientListState.success?.hasNextPage == true) {
          if (selectClientWatch.scrollController.position.maxScrollExtent == selectClientWatch.scrollController.position.pixels) {
            if(!selectClientWatch.clientListState.isLoadMore) {
              await selectClientWatch.clientListApi(context,true);
            }
          }
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
    return _bodyWidget();
  }

  ///Body Widget
  Widget _bodyWidget() {
    final clientsWatch = ref.watch(clientsController);
    final selectClientWatch = ref.watch(selectClientController);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: AppColors.white,
          ),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// common top widget
              CommonTopRowWeb(
                masterTitle: LocaleKeys.keyClients.localized,
                searchController: clientsWatch.clientSearchCtr,
                searchPlaceHolder: LocaleKeys.keySearchClientName.localized,
                onChanged: (value){

                  if (clientsWatch.debounce?.isActive ?? false)clientsWatch.debounce!.cancel();
                  clientsWatch.debounce = Timer(const Duration(milliseconds: 500), () async {
                    await selectClientWatch.clientListApi(context, false,searchText: value);
                  });

                },
                onCreateTap: (){
                  ref.read(navigationStackController).push(const NavigationStackItem.addEditClients());
                },
                showExport: false,
                showImport: false,
                onClearSearch: () async{
                  clientsWatch.clearSearchCtr();
                  await selectClientWatch.clientListApi(context, false);
                },
              ).paddingOnly(bottom: context.height * 0.040),

              const Expanded(child: ClientsListWidget()),

            ],
          ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
        ).paddingAll(context.height*0.025),
        DialogProgressBar(isLoading: clientsWatch.clientDetailsState.isLoading),
      ],
    );
  }





}
