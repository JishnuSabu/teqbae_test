import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.value,
    this.unit,
    required this.label,
    required this.img,
    this.showUnit = false,
    this.width,
    this.height,
    this.valueFz,
    this.labelClr,
  });

  final String value;
  final String? unit;
  final String label;
  final String img;
  final bool showUnit;
  final double? width;
  final double? height;
  final double? valueFz;
  final Color? labelClr;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 70.rh(context),
      width: width ?? 158.rh(context),
      padding: EdgeInsets.symmetric(
        horizontal: 18.rw(context),
        vertical: 10.rh(context),
      ),
      decoration: BoxDecoration(
        color: context.mainCardColor,
        borderRadius: BorderRadius.circular(10.rf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  UiUtils.textWidgetCard(
                    title: value,
                    context: context,
                    styleType: TextStyleType.mediumSemiBold,
                    fz: valueFz ?? 20.rf(context),
                    color: context.mainTextColor,
                  ),
                  if (unit != null && unit!.isNotEmpty) ...[
                    SizedBox(width: 2.rw(context)),
                    UiUtils.textWidgetCard(
                      title: unit!,
                      context: context,
                      styleType: TextStyleType.overline,
                      fw: FontWeight.w600,
                      fz: 10.rf(context),
                      color: context.primaryGreyColor,
                    ),
                  ],
                ],
              ),
              UiUtils.getSvg(img, color: context.gridSvgColor),
            ],
          ),
          UiUtils.textWidgetCard(
            title: label,
            context: context,
            styleType: TextStyleType.extraSmallRegular,
            color: labelClr ?? context.primaryGreyColor,
          ),
        ],
      ),
    );
  }
}
