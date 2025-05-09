import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/select_store_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/package/web/helper/store_list_tile_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class SelectStoreListWidget extends ConsumerWidget with BaseConsumerWidget{
  final Function(int index) onTap;
  const SelectStoreListWidget({Key? key,required this.onTap}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,ref) {
    final selectStoreWatch = ref.watch(selectStoreController);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: selectStoreWatch.storeList.length,
            itemBuilder: (BuildContext context, int index) {
              var model = selectStoreWatch.storeList[index];
              return InkWell(
                  onTap:(){
                    onTap(index);
                  },
                  child: StoreListTileWidget(image: model?.odigoStoreImageUrl ?? '', name: model?.odigoStoreName??'', city: model?.destinationName??'',)
              );
            },
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisExtent: context.height*0.28,
              mainAxisSpacing: context.height * 0.02,
              crossAxisSpacing: context.width * 0.02,
            ),
          ),

        ],
      ),
    );
  }
}
