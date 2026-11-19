import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:provider/provider.dart';
import 'package:teqbae_test/controller/provider/theme/theme_provider.dart';
import 'package:teqbae_test/controller/service/theme/theme_service.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';

void showThemeMenu(BuildContext context) {
  UiUtils.showCustomBottomSheet(
    height: 250.rh(context),
    context: context,
    widget: Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              value: ThemeService.SYSTEM_MODE,
              groupValue: themeProvider.themeMode,
              activeColor: context.themeColor,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value, context);
                  Navigator.pop(context);
                }
              },
              title: UiUtils.textWidgetCard(
                title: "System Default",
                context: context,
                styleType: TextStyleType.smallBold,
                fw: FontWeight.w600,
                color: context.textColor2,
              ),
            ),
            RadioListTile<int>(
              value: ThemeService.LIGHT_MODE,
              groupValue: themeProvider.themeMode,
              activeColor: context.themeColor,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value, context);
                  Navigator.pop(context);
                }
              },
              title: UiUtils.textWidgetCard(
                title: "Light Mode",
                context: context,
                styleType: TextStyleType.smallBold,
                fw: FontWeight.w600,
                color: context.textColor2,
              ),
            ),
            RadioListTile<int>(
              value: ThemeService.DARK_MODE,
              groupValue: themeProvider.themeMode,
              activeColor: context.themeColor,
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setThemeMode(value, context);
                  Navigator.pop(context);
                }
              },
              title: UiUtils.textWidgetCard(
                title: "Dark Mode",
                context: context,
                styleType: TextStyleType.smallBold,
                fw: FontWeight.w600,
                color: context.textColor2,
              ),
            ),
          ],
        );
      },
    ),
  );
}
