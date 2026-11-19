import 'package:teqbae_test/core/themes/color/app_colors.dart';
import 'package:flutter/material.dart';

//! get colors as per the theme

class AppThemeColors {
  final bool isDark;

  AppThemeColors(this.isDark);

  Color get primaryColor => isDark ? kDarkPrimaryColor : kLightPrimaryColor;
  Color get secondaryColor => isDark ? kPrimaryGrey : kLightsecondaryColor;
  Color get textColor => isDark ? kLightTextColor : kDarkTextColor;
  Color get textColor2 => isDark ? kDarkTextColor : kLightTextColor;
  Color get mainTextColor =>
      isDark ? kLightMainCardColor : kLightsecondaryColor;
  Color get hintTextColor => isDark ? kLightMainCardColor : kPrimaryGrey;
  Color get borderColor => isDark ? kLightPrimaryColor : kDarkPrimaryColor;
  Color get buttonColor => isDark ? kDarkSecondaryColor : kLightsecondaryColor;
  Color get buttonTextColor =>
      isDark ? kLightsecondaryColor : kLightMainCardColor;
  Color get bottomBarColor => isDark ? kDarkMainCardColor : kDarkTextColor;
  Color get bottomBarSvgColor => isDark ? kLightMainCardColor : kPrimaryGrey;
  Color get mainCardColor => isDark ? kDarkMainCardColor : kLightMainCardColor;
  Color get secondCardColor =>
      isDark ? kDarkSecondCardColor : kLightSecondCardColor;
  Color get homeGridTextColor => isDark ? kLightMainCardColor : kPrimaryGrey;
  Color get homeGridImgColor => isDark ? kPrimaryGrey : kLightsecondaryColor;
  Color get whiteColor => isDark ? kLightMainCardColor : kLightMainCardColor;
  Color get primaryGreyColor => isDark ? kPrimaryGrey : kPrimaryGrey;
  Color get lightGreyColor => isDark ? kLightGrey : kLightGrey;
  Color get themeColor => isDark ? kLightsecondaryColor : kLightsecondaryColor;
  Color get lightTextColor => isDark ? kDarkTextColor : kDarkTextColor;
  Color get blueColor => isDark ? kBlueColor : kBlueColor;
  Color get blueColor2 => isDark ? kBlueColor2 : kBlueColor2;
  Color get greenColor => isDark ? kGreenColor : kGreenColor;
  Color get greenColor2 => isDark ? kGreenColor2 : kGreenColor2;
  Color get orangeColor => isDark ? kOrangeColor : kOrangeColor;
  Color get secondaryGreyColor =>
      isDark ? kSecondaryGreyColor : kSecondaryGreyColor;
  Color get gridSvgColor => isDark ? kLightsecondaryColor : kSecondaryGreyColor;
  Color get attendanceGridTextColor =>
      isDark ? kPrimaryGrey : kLightsecondaryColor;
  Color get redColor => isDark ? kRedColor2 : kRedColor2;
  Color get lightRedColor => isDark ? kLightRedColor : kLightRedColor;
  Color get redColor2 => isDark ? kRedColor3 : kRedColor3;
  Color get failureColor => isDark ? kRedColor : kRedColor;
  Color get successColor => isDark ? kGreenColor : kGreenColor;
  Color get skyBlueColor => isDark ? kSkyBlueColor : kSkyBlueColor;
  Color get calendarCurrentDateBgClr =>
      isDark ? kLightMainCardColor : kLightsecondaryColor;
  Color get progressBarBalanceClr =>
      isDark ? kLightsecondaryColor : kSecondaryGreyColor;
  Color get notificationContainerColor =>
      isDark ? kDarkMainCardColor : kLightsecondaryColor;
  Color get shimmerBaseColor =>
      isDark ? kDarkShimmerBaseColor : kLightshimmerBaseColor;
  Color get shimmerHighlightColor =>
      isDark ? kDarkShimmerHighlightColor : kLightshimmerHighlightColor;
  Color get shimmerContentColor =>
      isDark ? kLightContainerGrayColor : kLightContainerGrayColor;
  Color get timePickerCardColor =>
      isDark ? kDarkSecondCardColor : kLightPrimaryColor;
}

extension GetColorThemeServices on BuildContext {
  //! Check if current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  //! Get the theme colors helper
  AppThemeColors get _themeColors => AppThemeColors(isDarkMode);

  //* frame colors
  Color get primaryColor => _themeColors.primaryColor;
  Color get secondaryColor => _themeColors.secondaryColor;
  Color get textColor => _themeColors.textColor;
  Color get textColor2 => _themeColors.textColor2;
  Color get mainTextColor => _themeColors.mainTextColor;
  Color get hintTextColor => _themeColors.hintTextColor;
  Color get borderColor => _themeColors.borderColor;
  Color get buttonColor => _themeColors.buttonColor;
  Color get buttonTextColor => _themeColors.buttonTextColor;
  Color get bottomBarColor => _themeColors.bottomBarColor;
  Color get bottomBarSvgColor => _themeColors.bottomBarSvgColor;
  Color get mainCardColor => _themeColors.mainCardColor;
  Color get secondCardColor => _themeColors.secondCardColor;
  Color get homeGridTextColor => _themeColors.homeGridTextColor;
  Color get homeGridImgColor => _themeColors.homeGridImgColor;
  Color get whiteColor => _themeColors.whiteColor;
  Color get primaryGreyColor => _themeColors.primaryGreyColor;
  Color get lightGreyColor => _themeColors.lightGreyColor;
  Color get themeColor => _themeColors.themeColor;
  Color get lightTextColor => _themeColors.lightTextColor;
  Color get blueColor => _themeColors.blueColor;
  Color get blueColor2 => _themeColors.blueColor2;
  Color get greenColor => _themeColors.greenColor;
  Color get greenColor2 => _themeColors.greenColor2;
  Color get orangeColor => _themeColors.orangeColor;
  Color get secondaryGreyColor => _themeColors.secondaryGreyColor;
  Color get gridSvgColor => _themeColors.gridSvgColor;
  Color get attendanceGridTextColor => _themeColors.attendanceGridTextColor;
  Color get redColor => _themeColors.redColor;
  Color get lightRedColor => _themeColors.lightRedColor;
  Color get redColor2 => _themeColors.redColor2;
  Color get failureColor => _themeColors.failureColor;
  Color get successColor => _themeColors.successColor;
  Color get skyBlueColor => _themeColors.skyBlueColor;
  Color get calendarCurrentDateBgClr => _themeColors.calendarCurrentDateBgClr;
  Color get progressBarBalanceClr => _themeColors.progressBarBalanceClr;
  Color get notificationContainerColor =>
      _themeColors.notificationContainerColor;
  Color get shimmerBaseColor => _themeColors.shimmerBaseColor;
  Color get shimmerHighlightColor => _themeColors.shimmerHighlightColor;
  Color get shimmerContentColor => _themeColors.shimmerContentColor;
  Color get timePickerCardColor => _themeColors.timePickerCardColor;
}
