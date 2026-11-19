import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.text,
    this.iconText,
    this.iconImg,
    this.showLeading = false,
    this.onTap,
    this.iconOnTap,
    this.actions,
  });

  final String? text;
  final String? iconText;
  final String? iconImg;
  final bool showLeading;
  final VoidCallback? onTap;
  final void Function()? iconOnTap;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap:
              onTap ??
              () {
                context.pop();
              },
          borderRadius: BorderRadius.circular(8.rf(context)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5.rh(context),
              horizontal: 2.rw(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: context.textColor2,
                  size: 20.rf(context),
                ),
                UiUtils.textWidgetCard(
                  title: text ?? "",
                  context: context,
                  styleType: TextStyleType.mediumSemiBold,
                  fz: 18.rf(context),
                  color: context.textColor2,
                ),
              ],
            ),
          ),
        ),

        if (actions != null)
          Row(children: actions!)
        else if (showLeading)
          GestureDetector(
            onTap: iconOnTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14.rw(context),
                vertical: 6.rh(context),
              ),
              decoration: BoxDecoration(
                color: context.mainCardColor,
                borderRadius: BorderRadius.circular(20.rf(context)),
              ),
              child: Row(
                children: [
                  UiUtils.getSvg(
                    iconImg ?? "",
                    color: context.textColor2,
                    height: 14.rh(context),
                    width: 14.rw(context),
                  ),
                  SizedBox(width: 5.rw(context)),
                  UiUtils.textWidgetCard(
                    context: context,
                    title: iconText ?? "",
                    styleType: TextStyleType.smallSemiBold,
                    fz: 10.rf(context),
                    color: context.textColor2,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
