import 'package:odigo_vendor/ui/utils/anim/animation_extension.dart';
import 'package:odigo_vendor/ui/utils/helper/base_widget.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/helper/day_name_list.dart';
import 'package:odigo_vendor/ui/utils/helper/date_picker/helper/week_wise_list.dart';
import 'package:odigo_vendor/ui/utils/theme/theme.dart';

class CustomDateDayWidget extends StatefulWidget {
  final bool selectDateOnTap;
  final Function(DateTime? selectedDate, {bool? isOkPressed}) getDateCallback;

  const CustomDateDayWidget({
    super.key,
    required this.selectDateOnTap,
    required this.getDateCallback,
  });

  @override
  State<CustomDateDayWidget> createState() => _CustomDateDayWidgetState();
}

class _CustomDateDayWidgetState extends State<CustomDateDayWidget> with SingleTickerProviderStateMixin, BaseStatefulWidget {
  AnimationController? _animController;
  late Animation<Offset> _offSetAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    if (_animController != null) {
      final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController!);
      _offSetAnim = Tween<Offset>(begin: const Offset(0, -0.1), end: const Offset(0, 0)).animate(curve);
      if (mounted) {
        if (!(_animController?.isDisposed ?? false)) {
          _animController?.forward().orCancel;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController?.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return _animController != null
        ? FadeTransition(
            opacity: _animController!,
            child: SlideTransition(
              position: _offSetAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DayNameList(),
                  SizedBox(height: 0.02.sh),
                  WeekWiseList(selectDateOnTap: widget.selectDateOnTap, getDateCallback: widget.getDateCallback),
                ],
              ),
            ),
          )
        : const Offstage();
  }
}
