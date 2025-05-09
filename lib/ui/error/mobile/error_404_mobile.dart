


import 'package:odigo_vendor/framework/provider/network/network.dart';
import 'package:odigo_vendor/ui/utils/theme/app_colors.dart';

class Error404Mobile extends StatelessWidget {
  const Error404Mobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Text('404 Not Found'),
      ),
    );
  }
}

