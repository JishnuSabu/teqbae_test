import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide typography types organized by screen roles and visual hierarchy.
enum TextStyleType {
  // ==========================================
  // 1. SCREEN HEADLINES & APP BAR TITLES
  // (Home Screen, Leave Screen, Payroll, Auth, Success Screens)
  // ==========================================
  /// 24sp - w700: Hero titles, large screen banners, prominent payroll totals
  headline1,

  /// 24sp - bold: Large numbers, summary statistics, big highlighted values
  largeBold,

  /// 20sp - w600: Screen app bar titles, modal headers, success/auth titles
  headline2,

  /// 18sp - w500: Standard screen titles, navigation headers
  headlineregular,

  /// 17sp - bold: Home screen section titles, main dashboard headings
  headline0,

  // ==========================================
  // 2. SUBTITLES & SECTION HEADERS
  // (Leave Cards, My Team / Employee Profiles, Announcements, Dialogs)
  // ==========================================
  /// 18sp - w500: Profile screen names, employee card titles, announcement headers
  subtitle1,

  /// 16sp - w500: Alert dialog headers, section subtitles, card group titles
  subtitle2,

  /// 16sp - w600: Semi-bold section headers, expense claim card headers
  subtitle2semibold,

  /// 13sp - w600: Form sub-headings, section category tags, forgot password headers
  subtitleHeading,

  /// 12sp - bold: Compact card section headers, small bold category labels
  subtitle3,

  // ==========================================
  // 3. FORM INPUTS, DROPDOWNS & ACTIONS
  // (Leave Application, Expense Claims, Auth, Filter/Search Sheets)
  // ==========================================
  /// 14sp - w400: Text form field inputs, dropdown options (Leave Type, Category), search input
  mediumRegular,

  /// 14sp - w600: Input field titles, search suggestions, year picker items, profile editable fields
  mediumSemiBold,

  /// 14sp - bold: Emphasized input values, OTP numbers, leave type selectors, applied leave titles
  mediumBold,

  /// 14sp - w600: Primary and secondary action buttons (Submit, Apply Leave, Login)
  button,

  /// 13sp - w500: Form field labels, dropdown labels, input field descriptors
  label,

  // ==========================================
  // 4. BODY TEXT, CARD DETAILS & LIST ITEMS
  // (Attendance Logs, Applied Leaves, Payslip Breakdown, Settings)
  // ==========================================
  /// 14sp - w500: Default primary body text, card content descriptions, dialog messages
  bodyText1,

  /// 12sp - w500: Secondary body text, help ticket descriptions, subtle informational text
  bodyText2,

  /// 12sp - bold: Status badges (Present/Leave/Approved/Pending), active tab labels, settings list titles
  smallBold,

  /// 12sp - w500: Card sub-labels, attendance punch times, profile detail labels, list item secondary text
  smallSemiBold,

  /// 12sp - w400: Input hint text (Leave date hint, search hint), card secondary info, payslip dates
  smallRegular,

  // ==========================================
  // 5. METADATA, BADGES & MICRO-COPY
  // (Home/Manager Grid, File Uploads, Timestamps, Tag Indicators)
  // ==========================================
  /// 10sp - w400: Dashboard grid item titles, timestamp sub-labels, employee ID/role lines, upload metadata
  extraSmallRegular,

  /// 10sp - w500: Compact status tags, ticket priority badges, small status pills
  extraSmallsemiBold,

  /// 10sp - bold: Resend OTP links, micro bold tags, small notification counters
  extraSmalBold,

  /// 11sp - w300: Micro captions, secondary footnote text
  caption,

  /// 10sp - w300: Micro overlines, subtle tracking indicators
  overline,

  // ==========================================
  // 6. VALIDATION & FEEDBACK
  // ==========================================
  /// 12sp - w500 (Failure Color): Validation error messages, form error hints
  errorText,
}

class AppTextStyles {
  static TextStyle getStyle(
    BuildContext context,
    TextStyleType type, {
    Color? color,
    FontWeight? weight,
    double? fontSize,
  }) {
    final defaultColor = color ?? context.textColor;

    TextStyle buildStyle({
      required double size,
      required FontWeight fw,
      required Color clr,
    }) {
      return GoogleFonts.inter(
        textStyle: TextStyle(fontWeight: fw, fontSize: size, color: clr),
      );
    }

    switch (type) {
      // ==========================================
      // 1. SCREEN HEADLINES & APP BAR TITLES
      // ==========================================
      case TextStyleType.headline1:
        return buildStyle(
          size: fontSize ?? 24.rf(context),
          fw: weight ?? FontWeight.w700,
          clr: defaultColor,
        );

      case TextStyleType.largeBold:
        return buildStyle(
          size: fontSize ?? 24.rf(context),
          fw: weight ?? FontWeight.bold,
          clr: defaultColor,
        );

      case TextStyleType.headline2:
        return buildStyle(
          size: fontSize ?? 20.rf(context),
          fw: weight ?? FontWeight.w600,
          clr: defaultColor,
        );

      case TextStyleType.headlineregular:
        return buildStyle(
          size: fontSize ?? 18.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: defaultColor,
        );

      case TextStyleType.headline0:
        return buildStyle(
          size: fontSize ?? 17.rf(context),
          fw: weight ?? FontWeight.bold,
          clr: defaultColor,
        );

      // ==========================================
      // 2. SUBTITLES & SECTION HEADERS
      // ==========================================
      case TextStyleType.subtitle1:
        return buildStyle(
          size: fontSize ?? 18.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: defaultColor,
        );

      case TextStyleType.subtitle2:
        return buildStyle(
          size: fontSize ?? 16.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: defaultColor,
        );

      case TextStyleType.subtitle2semibold:
        return buildStyle(
          size: fontSize ?? 16.rf(context),
          fw: weight ?? FontWeight.w600,
          clr: defaultColor,
        );

      case TextStyleType.subtitleHeading:
        return buildStyle(
          size: fontSize ?? 13.rf(context),
          fw: weight ?? FontWeight.w600,
          clr: defaultColor,
        );

      case TextStyleType.subtitle3:
        return buildStyle(
          size: fontSize ?? 12.rf(context),
          fw: weight ?? FontWeight.bold,
          clr: defaultColor,
        );

      // ==========================================
      // 3. FORM INPUTS, DROPDOWNS & ACTIONS
      // ==========================================
      case TextStyleType.mediumRegular:
        return buildStyle(
          size: fontSize ?? 14.rf(context),
          fw: weight ?? FontWeight.w400,
          clr: defaultColor,
        );

      case TextStyleType.mediumSemiBold:
        return buildStyle(
          size: fontSize ?? 14.rf(context),
          fw: weight ?? FontWeight.w600,
          clr: defaultColor,
        );

      case TextStyleType.mediumBold:
        return buildStyle(
          size: fontSize ?? 14.rf(context),
          fw: weight ?? FontWeight.bold,
          clr: defaultColor,
        );

      case TextStyleType.button:
        return buildStyle(
          size: fontSize ?? 14.rf(context),
          fw: weight ?? FontWeight.w600,
          clr: defaultColor,
        );

      case TextStyleType.label:
        return buildStyle(
          size: fontSize ?? 13.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: defaultColor,
        );

      // ==========================================
      // 4. BODY TEXT, CARD DETAILS & LIST ITEMS
      // ==========================================
      case TextStyleType.bodyText1:
        return buildStyle(
          size: fontSize ?? 14.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: defaultColor,
        );

      case TextStyleType.bodyText2:
        return buildStyle(
          size: fontSize ?? 12.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: defaultColor,
        );

      case TextStyleType.smallBold:
        return buildStyle(
          size: fontSize ?? 12.rf(context),
          fw: weight ?? FontWeight.bold,
          clr: defaultColor,
        );

      case TextStyleType.smallSemiBold:
        return buildStyle(
          size: fontSize ?? 12.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: defaultColor,
        );

      case TextStyleType.smallRegular:
        return buildStyle(
          size: fontSize ?? 12.rf(context),
          fw: weight ?? FontWeight.w400,
          clr: defaultColor,
        );

      // ==========================================
      // 5. METADATA, BADGES & MICRO-COPY
      // ==========================================
      case TextStyleType.extraSmallRegular:
        return buildStyle(
          size: fontSize ?? 10.rf(context),
          fw: weight ?? FontWeight.w400,
          clr: context.primaryGreyColor,
        );

      case TextStyleType.extraSmallsemiBold:
        return buildStyle(
          size: fontSize ?? 10.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: context.primaryGreyColor,
        );

      case TextStyleType.extraSmalBold:
        return buildStyle(
          size: fontSize ?? 10.rf(context),
          fw: weight ?? FontWeight.bold,
          clr: context.primaryGreyColor,
        );

      case TextStyleType.caption:
        return buildStyle(
          size: fontSize ?? 11.rf(context),
          fw: weight ?? FontWeight.w300,
          clr: defaultColor,
        );

      case TextStyleType.overline:
        return buildStyle(
          size: fontSize ?? 10.rf(context),
          fw: weight ?? FontWeight.w300,
          clr: defaultColor,
        );

      // ==========================================
      // 6. VALIDATION & FEEDBACK
      // ==========================================
      case TextStyleType.errorText:
        return buildStyle(
          size: fontSize ?? 12.rf(context),
          fw: weight ?? FontWeight.w500,
          clr: context.failureColor,
        );
    }
  }
}
