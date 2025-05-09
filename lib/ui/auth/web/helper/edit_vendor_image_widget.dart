import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/auth/edit_registration_form_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/ads/web/helper/upload_document_list_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class EditVendorImageWidget extends StatelessWidget {
  const EditVendorImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final editRegistrationFormWatch = ref.watch(editRegistrationFormController);
      return UploadDocumentListWidget(
        // height: context.height*0.250,
        width: context.width*0.250,
        imageList: editRegistrationFormWatch.imageList,
       /* xRation: 300,
        yRatio: 600,*/
        onTap: (index,file)async{
          await editRegistrationFormWatch.updateImage(index,file);
        },
        onRemoveTap: (index)async{
          await editRegistrationFormWatch.removeImage(index);
        },
      );
    },);
  }
}
