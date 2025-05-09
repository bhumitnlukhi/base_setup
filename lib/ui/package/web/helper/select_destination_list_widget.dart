import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigo_vendor/framework/controller/package/select_destination_controller.dart';
import 'package:odigo_vendor/framework/utils/extension/context_extension.dart';
import 'package:odigo_vendor/ui/package/web/helper/common_select_destination_tile.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';


class SelectDestinationListWidget extends ConsumerWidget with BaseConsumerWidget{
  final bool? isIconRequired;
  final Function(int index) onTap;
  const SelectDestinationListWidget({Key? key,this.isIconRequired,required this.onTap}) : super(key: key);

  @override
  Widget buildPage(BuildContext context,ref) {
    final selectDestinationWatch = ref.watch(selectDestinationController);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: selectDestinationWatch.destinationList.length,
            itemBuilder: (BuildContext context, int index) {
              var model = selectDestinationWatch.destinationList[index];
              return InkWell(
                  onTap:(){
                    onTap(index);
                  },
                  child: CommonPurchaseAdsTile(isIconRequired:isIconRequired,destinationData: model));
            },
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisExtent: isIconRequired??false?context.height * 0.30:context.height*0.28,
              mainAxisSpacing: context.height * 0.02,
              crossAxisSpacing: context.width * 0.02,
            ),
          ),
      
        ],
      ),
    );
  }
}
