import 'package:flutter_offline/flutter_offline.dart';
import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/ui/utils/const/app_constants.dart';
import 'package:odigo_vendor/ui/utils/theme/assets.gen.dart';
import 'package:odigo_vendor/ui/utils/widgets/empty_state_widget.dart';

class NoInternetBuilder extends StatelessWidget {
  final Widget child;
  final bool showInternetWidget;

  const NoInternetBuilder({Key? key, required this.child, this.showInternetWidget = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(debounceDuration: Duration.zero,
        connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child,) {
          isInternetConnectionOn = !(connectivity == ConnectivityResult.none);
          // print("Is internet connection on - ${isInternetConnectionOn}");
          if (connectivity == ConnectivityResult.none) {
            // print("NO INTERNET AVAILABLE ");
            if(!showInternetWidget){
              return child;
            }
            else{
              return noInterNetWidget(context);
            }
          }
          // print("INTERNET IS AVAILABLE ");
          return child;
        },
        child: child
    );
  }

  Widget noInterNetWidget(BuildContext context){
    return Center(child: EmptyStateWidget(imgName:Assets.svgs.svgNoData.keyName,));
  }
}