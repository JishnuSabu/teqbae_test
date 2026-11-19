import 'package:flutter/cupertino.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:teqbae_test/controller/provider/common_provider.dart';
import 'package:provider/provider.dart';
import '../themes/color/color_theme_genarator.dart';
import '../utils/ui_utils.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    this.height,
    this.width,
    required this.title,
    required this.onTap,
    this.bottonColor,
    this.titleColor,
    this.borderColor,
    this.isLoading = false,
    this.fontSize,
    this.fontWeight,
    this.checkConnectivity = true,
    this.borderRadius,
    this.borderWidth,
    this.useIcon = false,
    this.buttonIcon,
    this.buttonIconColor,
    this.iconSize,
  });
  final double? iconSize;
  final double? height;
  final double? width;
  final String title;
  final VoidCallback onTap;
  final Color? bottonColor;
  final Color? titleColor;
  final Color? borderColor;
  final bool isLoading;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool checkConnectivity;
  final double? borderRadius;
  final double? borderWidth;
  final String? buttonIcon;
  final bool useIcon;
  final Color? buttonIconColor;

  @override
  Widget build(BuildContext context) {
    // When [checkConnectivity] is false, do not [watch] CommonProvider: otherwise
    // these buttons rebuild on every search/typing and other global updates, which
    // can look like the control is constantly “changing” or fighting input.
    if (!checkConnectivity) {
      return GestureDetector(
        onTap: () {
          if (isLoading) return;
          onTap();
        },
        child: _buildButtonSurface(context),
      );
    }

    final commonViewModel = context.watch<CommonProvider>();
    final isChecking = commonViewModel.isCheckingConnectivity;
    final isCurrentlyLoading = isLoading || isChecking;
    return GestureDetector(
      onTap: () async {
        if (isCurrentlyLoading) return;

        commonViewModel.setIsCheckingConnectivity(true);
        try {
          final isOnline = await InternetConnection().hasInternetAccess;
          if (!isOnline) {
            if (context.mounted) {
              UiUtils.showSnackBarMessage(
                context,
                "No internet connection",
                isSuccess: false,
              );
            }
            return;
          }
        } finally {
          commonViewModel.setIsCheckingConnectivity(false);
        }
        onTap();
      },
      child: _buildButtonSurface(context),
    );
  }

  Widget _buildButtonSurface(BuildContext context) {
    return Container(
      height: height ?? 43.rh(context),
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: bottonColor ?? context.buttonColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.rf(context)),
      ),
      child: Center(
        child: isLoading
            ? LoadingAnimationWidget.progressiveDots(
                color: context.buttonTextColor,
                size: 30.rf(context),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  useIcon
                      ? Row(
                          children: [
                            UiUtils.getSvg(
                              buttonIcon!,
                              color: buttonIconColor ?? context.buttonColor,
                              height: iconSize ?? 13.rh(context),
                              width: iconSize ?? 13.rw(context),
                            ),
                            SizedBox(width: 8.rw(context)),
                          ],
                        )
                      : const SizedBox(),
                  UiUtils.textWidgetCard(
                    title: title,
                    context: context,
                    color: titleColor ?? context.buttonTextColor,
                    fw: fontWeight ?? FontWeight.bold,
                    fz: fontSize ?? 15.rf(context),
                  ),
                ],
              ),
      ),
    );
  }
}
