import 'package:flutter/material.dart';
import 'package:odigo_vendor/ui/stores/mobile/add_edit_store_mobile.dart';
import 'package:odigo_vendor/ui/stores/web/add_edit_store_web.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddEditStore extends StatelessWidget with BaseStatelessWidget {
  final bool? isEdit;

  const AddEditStore({Key? key, this.isEdit}) : super(key: key);

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(desktop: 600, tablet: 600, watch: 0),
      mobile: (BuildContext context) {
        return const AddEditStoreMobile();
      },
      desktop: (BuildContext context) {
        return AddEditStoreWeb(isEdit: isEdit);
      },
    );
  }
}
