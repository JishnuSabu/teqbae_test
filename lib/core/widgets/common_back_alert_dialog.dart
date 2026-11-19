import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';

class CommonBackAlertDialog extends StatelessWidget {
  const CommonBackAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.mainCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.rf(context)),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 28.rh(context)),
        width: 320.rw(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiUtils.textWidgetCard(
              context: context,
              title: "Going Back ?",
              styleType: TextStyleType.subtitle2,
              color: context.textColor2,
              fz: 18.rf(context),
              fw: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.rh(context)),
            UiUtils.textWidgetCard(
              context: context,
              title: "Are you sure Cancel and Going Back ?",
              styleType: TextStyleType.smallSemiBold,
              color: context.textColor2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.rh(context)),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 16.rh(context)),
                        child: UiUtils.textWidgetCard(
                          context: context,
                          title: "Cancel",
                          styleType: TextStyleType.subtitle2,
                          color: context.textColor2,
                          fw: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0.rh(context),
                      bottom: 8.0.rh(context),
                    ),
                    child: VerticalDivider(
                      color: context.gridSvgColor,
                      thickness: 2.rh(context),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pop(context);
                        context.pop(context);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 16.rh(context)),
                        child: UiUtils.textWidgetCard(
                          context: context,
                          title: "Back",
                          styleType: TextStyleType.subtitle2,
                          color: context.failureColor,
                          fw: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
