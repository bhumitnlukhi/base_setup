import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/clients/mobile/add_edit_clients_mobile.dart';
import 'package:odigo_vendor/ui/clients/web/add_edit_clients_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddEditClients extends StatelessWidget with BaseStatelessWidget {
  final bool? isEdit;
  final String clientId;
  final int? index;
  const AddEditClients({Key? key,this.index, required this.isEdit, required this.clientId}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),

      mobile: (BuildContext context) {
        return const AddEditClientsMobile();
      },
      desktop: (BuildContext context) {
        return AddEditClientsWeb(isEdit: isEdit,clientId: clientId,index: index,);
      },
      // tablet: (BuildContext context) {
      //   return OrientationBuilder(
      //     builder: (BuildContext context, Orientation orientation) {
      //       return orientation == Orientation.landscape
      //           ? AddEditClientsWeb(isEdit: isEdit)
      //           : const AddEditClientsMobile();
      //     },
      //   );
      // },
    );
  }
}

