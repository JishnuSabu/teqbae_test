import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeStyle {
  static ThemeData appThemeStyle(BuildContext context, bool isDarkTheme) {
    final colors = AppThemeColors(isDarkTheme);
    return ThemeData(
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: colors.primaryColor,
      cardColor: colors.mainCardColor,
      canvasColor: colors.mainCardColor,
      popupMenuTheme: PopupMenuThemeData(
        color: colors.mainCardColor,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        // backgroundColor: colors.cardColor,
        iconTheme: IconThemeData(
          size: 14.rf(context),
          color: colors.primaryColor,
        ),
        centerTitle: false,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          textStyle: AppTextStyles.getStyle(
            context,
            TextStyleType.headline1,
            color: colors.textColor,
          ),
        ),
      ),
      dialogTheme: DialogTheme(backgroundColor: colors.mainCardColor),
    );
  }
}
