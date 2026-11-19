// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'dart:io';
import 'package:teqbae_test/controller/provider/theme/theme_provider.dart';
import 'package:teqbae_test/core/widgets/custom_shimmer_loading_widget.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/routes/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'dart:ui' as ui;

class UiUtils {
  static String formatDate(String? startDate, String? endDate) {
    if (startDate == null || startDate.isEmpty) return "";
    if (endDate == null || endDate.isEmpty || startDate == endDate) {
      try {
        final parsed = DateTime.tryParse(startDate);
        if (parsed != null) {
          return DateFormat("EEE, dd MMM yyyy").format(parsed);
        }
      } catch (_) {}
      return startDate;
    }
    try {
      final parsedStart = DateTime.tryParse(startDate);
      final parsedEnd = DateTime.tryParse(endDate);
      if (parsedStart != null && parsedEnd != null) {
        return "${DateFormat("dd MMM").format(parsedStart)} - ${DateFormat("dd MMM yyyy").format(parsedEnd)}";
      }
    } catch (_) {}
    return "$startDate - $endDate";
  }

  //! for svg image
  static SvgPicture getSvg(
    String path, {
    Color? color,
    BoxFit? fit,
    double? width,
    double? height,
    Key? key,
  }) {
    return SvgPicture.asset(
      path,
      key: key ?? ValueKey(path),
      color: color,
      fit: fit ?? BoxFit.contain,
      width: width,
      height: height,
    );
  }

  //! get images from asset folder
  static Image getAssetimage(
    String path, {
    Color? color,
    BoxFit? fit,
    double? width,
    double? height,
  }) {
    return Image.asset(
      path,
      color: color,
      fit: fit ?? BoxFit.contain,
      width: width,
      height: height,
    );
  }

  //! network image
  //! get images from network
  static Widget getNetworkImage(
    String imageUrl, {
    Color? color,
    BoxFit? fit,
    double? width,
    double? height,
  }) {
    return Image.network(
      imageUrl,
      color: color,
      fit: fit ?? BoxFit.contain,
      width: width,
      height: height,

      //! loading
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return CustomShimmer(
              borderRadius: 100.rf(context),
              height: 86.rf(context),
              width: 86.rf(context),
            );
          },

      //! error
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: UiUtils.getSvg(
            ConstSvgIcons.errorImage,
            color: context.primaryColor,
            width: 60.rh(context),
            height: 60.rh(context),
          ),
        );
      },
    );
  }

  //! test style
  static Text textWidgetCard({
    required String title,
    required BuildContext context,
    TextStyleType styleType = TextStyleType.bodyText1,
    FontWeight? fw,
    double? fz,
    Color? color,
    int? maxLines,
    TextAlign? textAlign,
    TextOverflow? overflow,
  }) {
    final baseStyle = AppTextStyles.getStyle(context, styleType);
    final mergedStyle = baseStyle.copyWith(
      fontWeight: fw ?? baseStyle.fontWeight,
      fontSize: fz ?? baseStyle.fontSize,
      color: color ?? baseStyle.color,
    );

    return Text(
      title,
      style: mergedStyle,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }

  static Text richTextWidgetCard({
    required List<InlineSpan> children,
    required BuildContext context,
    TextStyleType styleType = TextStyleType.bodyText1,
    FontWeight? fw,
    double? fz,
    Color? color,
    int? maxLines,
    TextAlign? textAlign,
    TextOverflow? overflow,
  }) {
    final baseStyle = AppTextStyles.getStyle(context, styleType);
    final mergedStyle = baseStyle.copyWith(
      fontWeight: fw ?? baseStyle.fontWeight,
      fontSize: fz ?? baseStyle.fontSize,
      color: color ?? baseStyle.color,
    );

    return Text.rich(
      TextSpan(children: children),
      style: mergedStyle,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }

  static TextStyle textStyles(
    BuildContext context, {
    TextStyleType styleType = TextStyleType.bodyText1,
    FontWeight? fw,
    double? fz,
    Color? color,
  }) {
    TextStyle baseStyle = AppTextStyles.getStyle(context, styleType);
    TextStyle mergedStyle = baseStyle.copyWith(
      fontWeight: fw ?? baseStyle.fontWeight,
      fontSize: fz ?? baseStyle.fontSize,
      color: color ?? baseStyle.color,
    );
    return mergedStyle;
  }

  //! snackbar
  static void showSnackBarMessage(
    BuildContext context,
    String title, {
    bool isSuccess = true,
    Duration? duration,
    TextStyle? textStyle,
    bool announceForAccessibility = true,
    SnackBarBehavior? behavior,
    VoidCallback? onRetry,
  }) {
    if (!context.mounted) return;
    try {
      if (announceForAccessibility) {
        //* Fix: Use Flutter's TextDirection.ltr explicitly
        SemanticsService.announce(title, ui.TextDirection.ltr);
      }
      final scaffoldContext =
          GoRouter.of(context).routerDelegate.navigatorKey.currentContext ??
          context;
      ScaffoldMessenger.of(scaffoldContext).removeCurrentSnackBar();
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style:
                      textStyle ??
                      TextStyle(
                        color: context.primaryColor,
                        fontSize: 14.rf(context),
                      ),
                ),
              ),
              if (onRetry != null)
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    onRetry();
                  },
                  child: Icon(
                    Icons.refresh,
                    size: 23.rf(context),
                    color: context.primaryColor,
                  ),
                ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.rf(context)),
          ),
          backgroundColor: isSuccess
              ? context.successColor
              : context.failureColor,
          //* duration: duration ?? const Duration(seconds: 2),
          duration: onRetry != null
              ? const Duration(
                  seconds: 6,
                ) //* Auto-dismiss after 6s even with retry
              : (duration ?? const Duration(seconds: 2)),
          behavior: behavior ?? SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      //* Optional logging
    }
  }

  static Future<void> selectDate({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? startDate,
    DateTime? endDate,
    bool? isStartDate,
    required Function(DateTime) onDateSelected,
    bool allowFutureDates = false,
  }) async {
    DateTime effectiveInitialDate = initialDate;

    // For delivery date selection, minimum date should be from create date
    DateTime minimumDate;
    DateTime maximumDate;

    if (allowFutureDates) {
      // For delivery date: allow from create date to future
      minimumDate = startDate ?? DateTime.now();
      maximumDate = DateTime(2100);
    } else {
      // For other cases: existing logic
      minimumDate = isStartDate! ? DateTime(2000) : startDate ?? DateTime.now();
      maximumDate = isStartDate ? DateTime.now() : DateTime.now();
    }

    if (Platform.isAndroid) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: effectiveInitialDate,
        firstDate: minimumDate,
        lastDate: maximumDate,
        builder: (BuildContext context, Widget? child) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: context.textColor,
                displayColor: context.textColor,
              ),
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: context.textColor),
                hintStyle: TextStyle(color: context.textColor),
              ),
              colorScheme: themeProvider.darkTheme
                  ? ColorScheme.dark(
                      primary: context.primaryColor,
                      onPrimary: context.textColor,
                      surface: context.textColor,
                      onSurface: context.textColor,
                    )
                  : ColorScheme.light(
                      primary: context.primaryColor,
                      onPrimary: context.primaryColor,
                      surface: context.primaryColor,
                      onSurface: context.textColor,
                    ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        onDateSelected(picked);
      }
    } else if (Platform.isIOS) {
      DateTime tempSelectedDate = effectiveInitialDate;
      showModalBottomSheet(
        backgroundColor: Colors.yellow[100],
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 300.rh(context),
            color: Colors.yellow[100],
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.rw(context),
                    vertical: 8.rh(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(builder).pop(),
                        child: UiUtils.textWidgetCard(
                          title: "Cancel",
                          context: context,
                          styleType: TextStyleType.bodyText2,
                          fw: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          onDateSelected(tempSelectedDate);
                          Navigator.of(builder).pop();
                        },
                        child: UiUtils.textWidgetCard(
                          title: "Done",
                          context: context,
                          styleType: TextStyleType.bodyText2,
                          fw: FontWeight.w600,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: effectiveInitialDate,
                    minimumDate: minimumDate,
                    maximumDate: maximumDate,
                    onDateTimeChanged: (DateTime picked) {
                      tempSelectedDate = picked;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  static Future<void> selectTime({
    required BuildContext context,
    required TimeOfDay initialTime,
    required Function(TimeOfDay) onTimeSelected,
    bool use24HourFormat = false,
  }) async {
    if (Platform.isAndroid) {
      final TimeOfDay? picked = await showTimePicker(
        barrierColor: Colors.black.withOpacity(0.9),
        context: context,
        initialTime: initialTime,
        builder: (BuildContext context, Widget? child) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: context.textColor,
                displayColor: context.textColor,
              ),
              colorScheme: themeProvider.darkTheme
                  ? ColorScheme.dark(
                      primary: context.primaryColor,
                      onPrimary: context.textColor,
                      surface: context.primaryColor,
                      onSurface: context.textColor,
                    )
                  : ColorScheme.light(
                      primary: context.primaryColor,
                      onPrimary: context.primaryColor,
                      surface: context.primaryColor,
                      onSurface: context.textColor,
                    ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: use24HourFormat),
              child: child!,
            ),
          );
        },
      );
      if (picked != null) {
        onTimeSelected(picked);
      }
    } else if (Platform.isIOS) {
      DateTime tempSelectedTime = DateTime(
        2000,
        1,
        1,
        initialTime.hour,
        initialTime.minute,
      );

      showModalBottomSheet(
        backgroundColor: Colors.yellow[100],
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 300.rh(context),
            color: Colors.yellow[100],
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.rw(context),
                    vertical: 8.rh(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(builder).pop(),
                        child: UiUtils.textWidgetCard(
                          title: "Cancel",
                          context: context,
                          styleType: TextStyleType.bodyText2,
                          fw: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          onTimeSelected(
                            TimeOfDay(
                              hour: tempSelectedTime.hour,
                              minute: tempSelectedTime.minute,
                            ),
                          );
                          Navigator.of(builder).pop();
                        },
                        child: UiUtils.textWidgetCard(
                          title: "Done",
                          context: context,
                          styleType: TextStyleType.bodyText2,
                          fw: FontWeight.w600,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: use24HourFormat,
                    initialDateTime: tempSelectedTime,
                    onDateTimeChanged: (DateTime picked) {
                      tempSelectedTime = picked;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  //! logout process
  static Future<void> logoutProcess(BuildContext context) async {
    context.goNamed(RouteNames.dashboard);
  }

  //! delete confirmation dialogue
  static Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required Future<void> Function() onConfirm,
    Future<void> Function()? onCancel,
    String? buttonText,
    String? description,
    String? titile,
    bool? isLoading = false,

    /// When true, closes the dialog before [onConfirm] runs. Use when [onConfirm]
    /// opens another modal (e.g. bottom sheet) so the dialog does not block it.
    bool dismissDialogBeforeConfirm = false,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        bool isDeleting = isLoading ?? false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void popDialogIfMounted() {
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            }

            if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: UiUtils.textWidgetCard(
                  title: titile ?? "Confirm Deletion",
                  context: dialogContext,
                  styleType: TextStyleType.subtitle2,
                  fw: FontWeight.w600,
                  color: dialogContext.textColor2,
                ),
                content: UiUtils.textWidgetCard(
                  title:
                      description ??
                      'Are you sure you want to delete this leave request?',
                  context: dialogContext,
                  styleType: TextStyleType.bodyText1,
                  fw: FontWeight.w400,
                  color: dialogContext.textColor2,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: isDeleting
                        ? null
                        : () async {
                            if (onCancel != null) {
                              await onCancel();
                            }
                            popDialogIfMounted();
                          },
                    child: UiUtils.textWidgetCard(
                      title: "Cancel",
                      context: dialogContext,
                      styleType: TextStyleType.bodyText1,
                      fw: FontWeight.w600,
                      color: dialogContext.textColor2,
                    ),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: isDeleting
                        ? null
                        : () async {
                            if (dismissDialogBeforeConfirm) {
                              popDialogIfMounted();
                              WidgetsBinding.instance.addPostFrameCallback((
                                _,
                              ) async {
                                await onConfirm();
                              });
                            } else {
                              setState(() {
                                isDeleting = true;
                              });
                              try {
                                await onConfirm();
                              } finally {
                                popDialogIfMounted();
                              }
                            }
                          },
                    child: isDeleting
                        ? CupertinoActivityIndicator(
                            color: dialogContext.textColor2,
                          )
                        : UiUtils.textWidgetCard(
                            title: buttonText ?? "Delete",
                            context: dialogContext,
                            styleType: TextStyleType.bodyText1,
                            fw: FontWeight.w600,
                            color: dialogContext.redColor,
                          ),
                  ),
                ],
              );
            } else {
              return AlertDialog(
                backgroundColor: dialogContext.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: UiUtils.textWidgetCard(
                  title: titile ?? "Confirm Deletion",
                  context: dialogContext,
                  styleType: TextStyleType.subtitle2,
                  fw: FontWeight.w600,
                  color: dialogContext.textColor2,
                ),
                content: UiUtils.textWidgetCard(
                  title:
                      description ??
                      'Are you sure you want to delete this leave request?',
                  context: dialogContext,
                  styleType: TextStyleType.bodyText1,
                  fw: FontWeight.w400,
                  color: dialogContext.textColor2,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () async {
                            if (onCancel != null) {
                              await onCancel();
                            }
                            popDialogIfMounted();
                          },
                    child: UiUtils.textWidgetCard(
                      title: "Cancel",
                      context: dialogContext,
                      styleType: TextStyleType.bodyText1,
                      fw: FontWeight.w600,
                      color: dialogContext.textColor2,
                    ),
                  ),
                  TextButton(
                    onPressed: isDeleting
                        ? null
                        : () async {
                            if (dismissDialogBeforeConfirm) {
                              popDialogIfMounted();
                              WidgetsBinding.instance.addPostFrameCallback((
                                _,
                              ) async {
                                await onConfirm();
                              });
                            } else {
                              setState(() {
                                isDeleting = true;
                              });
                              try {
                                await onConfirm();
                              } finally {
                                popDialogIfMounted();
                              }
                            }
                          },
                    child: isDeleting
                        ? CupertinoActivityIndicator(
                            color: dialogContext.textColor2,
                          )
                        : UiUtils.textWidgetCard(
                            title: buttonText ?? "Delete",
                            context: dialogContext,
                            styleType: TextStyleType.bodyText1,
                            fw: FontWeight.w600,
                            color: dialogContext.redColor,
                          ),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  //! common show bottom sheet
  static void showCustomBottomSheet({
    required BuildContext context,
    required Widget widget,
    double? height,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedPadding(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 60.rh(context),
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.rh(context)),
                height: height ?? MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.rf(context)),
                  ),
                ),
                child: widget,
              ),
            ),
            Positioned(
              top: -5,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: UiUtils.getSvg(ConstSvgIcons.closeRound),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //! image source bottom sheet single
  static void showImageSourceSingleSheet(
    BuildContext context,
    dynamic provider,
  ) {
    return UiUtils.showCustomBottomSheet(
      height: 100.rh(context),
      context: context,
      widget: Padding(
        padding: EdgeInsets.all(16.rf(context)),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: UiUtils.textWidgetCard(
                title: "Camera",
                context: context,
                styleType: TextStyleType.bodyText1,
              ),
              onTap: () => provider.pickFromCamera(context),
            ),
          ],
        ),
      ),
    );
  }

  //! image source bottom sheet
  static Future<List<String>> showImageSourceSheet(
    BuildContext context,
    dynamic provider, {
    bool allowMultiple = false,
    bool showCamera = true,
    bool showGallery = true,
    double? height = 120,
    bool clearExistingImages = true,
  }) async {
    if (clearExistingImages) {
      try {
        provider.clearAllImages();
      } catch (_) {}
    }

    final String? source = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.rh(context)),
                height: height ?? MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showCamera)
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: UiUtils.textWidgetCard(
                          title: "Camera",
                          context: sheetContext,
                          styleType: TextStyleType.mediumRegular,
                        ),
                        onTap: () => Navigator.pop(sheetContext, 'camera'),
                      ),
                    if (showGallery)
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: UiUtils.textWidgetCard(
                          title: "Gallery",
                          context: sheetContext,
                          styleType: TextStyleType.mediumRegular,
                        ),
                        onTap: () => Navigator.pop(sheetContext, 'gallery'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return <String>[];

    if (source == 'camera') {
      await provider.pickFromCamera(
        context,
        allowMultiple: allowMultiple,
        closeSheet: false,
      );
    } else {
      await provider.pickFromGallery(
        context,
        allowMultiple: allowMultiple,
        closeSheet: false,
      );
    }

    try {
      return (provider.selectedImages as List)
          .map((e) => e.path.toString())
          .toList();
    } catch (_) {
      return <String>[];
    }
  }

  //! custom bottom sheet for payment section
  static Future<Object?> showCustomBottomSheetForPayment({
    required BuildContext context,
    required Widget Function(BuildContext rootContext) widget,
    final VoidCallback? closingFunctiom,

    /// When the sheet closes without a pop value (close icon, swipe, back).
    /// Not called when closed with e.g. [Navigator.pop] and a Save payload.
    final VoidCallback? onDismissedWithoutResult,
    double? height,
    bool preventDismiss = false,
  }) {
    return showModalBottomSheet<Object?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: !preventDismiss,
      enableDrag: !preventDismiss,
      builder: (context) {
        return PopScope(
          canPop: !preventDismiss,
          child: WillPopScope(
            // For older Flutter versions
            onWillPop: () async => !preventDismiss,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 60.rh(context),
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.rh(context)),
                    height: height ?? MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.rf(context)),
                      ),
                    ),
                    child: widget(context),
                  ),
                ),
                Positioned(
                  top: -5,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap:
                          closingFunctiom ?? () => Navigator.of(context).pop(),
                      child: UiUtils.getSvg(ConstSvgIcons.closeRound),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((Object? value) {
      if (value == null) {
        onDismissedWithoutResult?.call();
      }
      return value;
    });
  }

  //! overlaw snackbar for payment section
  static void showOverlaySnackbar(
    BuildContext context,
    String message, {
    double? bottomPadding,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: bottomPadding ?? 60.rh(context),
        left: 20.rw(context),
        right: 20.rw(context),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.rf(context)),
          ),
          color: context.failureColor,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.rw(context),
              vertical: 12.rf(context),
            ),
            decoration: BoxDecoration(
              color: context.failureColor,
              borderRadius: BorderRadius.circular(12.rf(context)),
            ),
            child: Text(
              message,
              style: TextStyle(color: context.primaryColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  //! show user rolls
  static String showUserRoleName({String? userRole}) {
    return userRole ?? "Employee";
  }

  static String showUserRoll({String? userRole}) {
    return userRole ?? "Employee";
  }

  /// High / Low / Medium — used on assigned job cards for priority text color.
  static Color jobPriorityLabelColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFCC0000);
      case 'low':
        return const Color(0xFF1B6B3A);
      case 'medium':
        return const Color(0xFFE07B00);
      default:
        return Colors.grey;
    }
  }

  //! purpose of vist show
  static String getPurposeText(dynamic status) {
    switch (status.toString()) {
      case '1':
        return 'Payment';
      case '2':
        return 'Sales Order';
      case '3':
        return 'Payment Call';
      case '4':
        return 'Sales Call';
      case '5':
        return 'Delivered';
      case '6':
        return 'Feedback';
      default:
        return 'N/A';
    }
  }

  //!! time and date format functions //!!

  static String formatTime12Hour(String dateTime) {
    final raw = dateTime.trim();
    if (raw.isEmpty || raw.toLowerCase() == "null") return "";
    try {
      // Supports full ISO-8601 datetimes (e.g., 2026-04-09T14:42:00Z)
      final parsedDate = DateTime.parse(raw);
      return DateFormat('hh:mm a').format(parsedDate);
    } catch (_) {
      // Supports time-only strings from API (e.g., 14:42:00 or 14:42)
      try {
        final normalized = raw
            .split('.')
            .first; // drop fractional seconds if any
        final now = DateTime.now();
        DateTime parsedTime;

        if (normalized.split(':').length >= 3) {
          parsedTime = DateFormat('HH:mm:ss').parseStrict(normalized);
        } else {
          parsedTime = DateFormat('HH:mm').parseStrict(normalized);
        }

        final combined = DateTime(
          now.year,
          now.month,
          now.day,
          parsedTime.hour,
          parsedTime.minute,
          parsedTime.second,
        );
        return DateFormat('hh:mm a').format(combined);
      } catch (_) {
        // Last resort: don't crash UI if backend sends unexpected format.
        return raw;
      }
    }
  }

  //! Format ISO datetime → relative time (e.g., "10 hours ago", "1 week ago")
  static String formatTimeAgo(String? dateTime) {
    if (dateTime == null || dateTime.trim().isEmpty) return '';
    try {
      final DateTime parsed = DateTime.parse(dateTime).toLocal();
      final Duration diff = DateTime.now().difference(parsed);

      if (diff.isNegative || diff.inSeconds < 60) return 'just now';

      final minutes = diff.inMinutes;
      if (minutes < 60) {
        return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
      }

      final hours = diff.inHours;
      if (hours < 24) {
        return hours == 1 ? '1 hour ago' : '$hours hours ago';
      }

      final days = diff.inDays;
      if (days < 7) {
        return days == 1 ? '1 day ago' : '$days days ago';
      }

      final weeks = days ~/ 7;
      if (days < 30) {
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      }

      final months = days ~/ 30;
      if (days < 365) {
        return months == 1 ? '1 month ago' : '$months months ago';
      }

      final years = days ~/ 365;
      return years == 1 ? '1 year ago' : '$years years ago';
    } catch (_) {
      return dateTime;
    }
  }

  //! Format: dd-MM-yyyy (e.g., 05-06-2025)
  static String formatDateddMMyyyy(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  //! Format: dd-MM-yyyy (e.g., 05-06-2025)
  static String formatDateddMMyyyyhifon(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  //! Format: d EEEE MMMM yyyy (e.g., 5 Thursday June 2025)
  static String formatDateReadable(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return "${parsedDate.day} "
        "${DateFormat('EEEE').format(parsedDate)} "
        "${DateFormat('MMMM').format(parsedDate)} "
        "${parsedDate.year}";
  }

  static String formatDateReadableShort(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return "${parsedDate.day} "
        "${DateFormat('EEE').format(parsedDate)} "
        "${DateFormat('MMMM').format(parsedDate)} "
        "${parsedDate.year}";
  }

  //! Format: d EEEE MMMM yyyy (e.g., Tue, June 19, 2025)
  static String formatDateReadableDMY(String dateString) {
    try {
      // Parse the date string (assuming it's in yyyy-MM-dd format)
      DateTime date = DateTime.parse(dateString);

      // Format it to "EEE, MMM dd, yyyy" pattern
      // EEE = abbreviated weekday (Tue)
      // MMM = abbreviated month (Aug)
      // dd = day with leading zero if needed (20)
      // yyyy = full year (2025)
      return DateFormat('EEE, MMM dd, yyyy').format(date);
    } catch (e) {
      // Return original string if parsing fails
      return dateString;
    }
  }

  //! parse time
  static DateTime parseTime(String? timeStr) {
    if (timeStr == null) return DateTime(2000);
    try {
      final now = DateTime.now();
      final time = TimeOfDay(
        hour:
            int.parse(timeStr.split(' ')[0].split(':')[0]) +
            (timeStr.toLowerCase().contains('pm') && !timeStr.startsWith('12')
                ? 12
                : 0),
        minute: int.parse(timeStr.split(' ')[0].split(':')[1]),
      );
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    } catch (_) {
      return DateTime(2000); // fallback if parsing fails
    }
  }

  //! convert standart time to railway time to pass
  static String convertToRailwayTime(String inputTime) {
    try {
      // Replace dot with colon, in case user enters like "10.00 Am"
      String cleanedTime = inputTime.replaceAll('.', ':').toUpperCase().trim();

      // Parse the time as 12-hour format
      DateFormat inputFormat = DateFormat('h:mm a');
      DateTime dateTime = inputFormat.parse(cleanedTime);

      // Format to 24-hour (railway) format
      DateFormat outputFormat = DateFormat('HH:mm');
      return outputFormat.format(dateTime);
    } catch (e) {
      return 'Invalid time';
    }
  }

  //! convert railway time to standart time to show
  static String convertTo12HourFormat(String railwayTime) {
    try {
      // Parse input like "15:45"
      DateFormat inputFormat = DateFormat('HH:mm');
      DateTime dateTime = inputFormat.parse(railwayTime);

      // Format to "h.mm a" like "3.45 PM"
      DateFormat outputFormat = DateFormat('h:mm a');
      return outputFormat.format(dateTime);
    } catch (e) {
      return 'Invalid time';
    }
  }

  //!12 hour format to 24 hour format
  static String formatTime12(TimeOfDay time) {
    final hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour12.toString().padLeft(2, '0')}:$minute $period';
  }

  //!24 hour format to 12 hour format
  static String formatTime24(TimeOfDay time) {
    final hour24 = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour24:$minute';
  }

  //! Format DB "yyyy-MM-dd HH:mm:ss" → "MMM d, yyyy hh:mm a"
  static String formatReadableDateTime(String dbDateTime) {
    try {
      // Parse using exact incoming pattern
      DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      DateTime dateTime = inputFormat.parse(dbDateTime);

      // Convert to local time if needed
      dateTime = dateTime.toLocal();

      // Output format: Jan 15, 2026 11:51 AM
      return DateFormat('MMM d, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return dbDateTime;
    }
  }

  //! convert data base date time section
  static String formatIsoDateTimeFromDB(String isoString) {
    try {
      // Parse ISO date string
      DateTime utcDateTime = DateTime.parse(isoString);
      // Convert to local time (if needed)
      DateTime localDateTime = utcDateTime.toLocal();
      // Format to "dd-MM-yyyy h.mm a"
      String formatted = DateFormat('dd/MM/yyyy h:mm a').format(localDateTime);
      return formatted;
    } catch (e) {
      return 'Invalid date';
    }
  }

  //! Format: dd MMM yyyy | hh:mm a "2026-04-27T04:30:00.000000Z"
  static String formatStartedDateTime(String? isoDateTime) {
    if (isoDateTime == null || isoDateTime.trim().isEmpty) return '-';
    final DateTime? parsed = DateTime.tryParse(isoDateTime);
    if (parsed == null) return isoDateTime;
    return DateFormat('dd MMM yyyy | hh:mm a').format(parsed.toLocal());
  }

  //! Format: Aug 20, 2025
  static String formatDateReadableMonth(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('MMM d, yyyy').format(parsedDate);
  }

  //! Format: 20, Aug , 2025
  static String formatMonthReadableMonth(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('d MMM, yyyy').format(parsedDate);
  }

  //!====multiple list time selection use key
  static Future<void> pickTimeFromList(
    dynamic provider,
    int jobkey,
    BuildContext context,
  ) async {
    final current = provider.cardState(jobkey).selectedTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
    );
    if (picked != null && context.mounted) {
      provider.updateTime(jobkey, picked);
    }
  }
}
