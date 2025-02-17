import 'package:flutter_base_setup/framework/utility/extension/string_extension.dart';
import 'package:flutter_base_setup/ui/utils/widgets/common_button.dart';
import 'package:flutter_base_setup/ui/utils/theme/theme.dart';

/// Confirmation dialog  message
showConfirmationDialog(BuildContext context, String title, String message,
    String btn1Name, String btn2Name, Function(bool isPositive) didTakeAction) {
  return showDialog(
      barrierDismissible: true,
      context: context,
      barrierColor: AppColors.bg1A2D3170,
      builder: (context) => Dialog(
            backgroundColor: AppColors.white,
            insetPadding: EdgeInsets.all(16.sp),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(ScreenUtil().setWidth(15.r))),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.w, right: 16.w, top: 22.h, bottom: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      message == '' ? SizedBox(height: 20.h) : const SizedBox(),
                      Text(title,
                          textAlign: TextAlign.center,
                          style: TextStyles.medium.copyWith(
                              color: AppColors.black, fontSize: 16.sp)),
                      message != ''
                          ? SizedBox(
                              height: 30.h,
                            )
                          : const SizedBox(),
                      Text(message,
                          textAlign: TextAlign.center,
                          style: TextStyles.regular.copyWith(
                              color: AppColors.black, fontSize: 12.sp)),
                      SizedBox(
                        height: 33.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonButton(
                              width: 139.w,
                              height: 49.h,
                              borderRadius: BorderRadius.circular(10.r),
                              buttonText: btn1Name.localized,
                              onTap: () {
                                Navigator.pop(context);
                                Future.delayed(const Duration(milliseconds: 80),
                                    () {
                                  didTakeAction(true);
                                });
                              },
                              borderColor: AppColors.green3A4161,
                              backgroundColor: AppColors.white,
                              buttonTextColor: AppColors.primary),
                          SizedBox(
                            width: 15.w,
                          ),
                          CommonButton(
                              buttonText: btn2Name.localized,
                              width: 139.w,
                              height: 49.h,
                              borderRadius: BorderRadius.circular(10.r),
                              onTap: () {
                                Navigator.pop(context);
                                Future.delayed(const Duration(milliseconds: 80),
                                    () {
                                  didTakeAction(false);
                                });
                              },
                              backgroundColor: AppColors.primary,
                              buttonTextColor: AppColors.white),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
}

/// Message Dialog
showMessageDialog(
    BuildContext context, String message, Function()? didDismiss) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: AppColors.bg1A2D3170,
      builder: (context) => Dialog(
            backgroundColor: AppColors.white,
            insetPadding: EdgeInsets.all(16.sp),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5))),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  // height: ScreenUtil().setHeight(220),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.primary,
                                // fontWeight: TextStyles.medium,
                                fontFamily: TextStyles.fontFamily),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CommonButton(
                          buttonTextColor: AppColors.white,
                          backgroundColor: AppColors.primary,
                          borderColor: AppColors.primary,
                          width: 150.w,
                          buttonText: 'Key_Ok'.localized,
                          onTap: () {
                            Navigator.pop(context);
                            if (didDismiss != null) {
                              Future.delayed(const Duration(milliseconds: 80),
                                  () {
                                didDismiss();
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
}
