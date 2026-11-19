// ignore: must_be_immutable
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';

class CustomTextFormWidget extends StatelessWidget {
  final String titles;
  final TextInputType textinputType;
  final int? maxline;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Color? borderColor;
  final String? suffix;
  final VoidCallback? onTap;
  final VoidCallback? suffixOnTap;
  final List<TextInputFormatter>? inputFormatters;
  final Color? textColor;
  final Color? fillColor;
  final bool obscureText;
  final int? maxLength;
  final TextCapitalization? textCapitalization;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final bool preventCopyPaste;
  final int nonPasswordFeild;
  final Color? suffixColor;
  final Color? preffixColor;
  final bool copy;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int forgotpasswordType;
  final BorderRadius? borderRadius;
  final double? contentPaddingHorizontalValue;
  final double? contentPaddingverticalValue;
  final Color? cursorColor;
  final Color? hintColor;
  final bool isDense;
  final TextAlign? textAlign;
  final double? borderWidth;
  final String? labelText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Function(PointerDownEvent)? onTapOutside;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;

  const CustomTextFormWidget({
    super.key,
    required this.controller,
    required this.textinputType,
    required this.validator,
    this.onChanged,
    this.maxline,
    required this.titles,
    this.textColor,
    this.onTap,
    this.suffixOnTap,
    this.inputFormatters,
    this.borderColor,
    this.maxLength,
    this.fillColor,
    this.textCapitalization,
    this.readOnly = false,
    this.obscureText = false,
    this.enableInteractiveSelection = true,
    this.preventCopyPaste = false,
    this.suffix,
    this.nonPasswordFeild = 1,
    this.suffixColor,
    this.copy = true,
    this.textInputAction,
    this.focusNode,
    this.forgotpasswordType = 0,
    this.borderRadius,
    this.preffixColor,
    this.contentPaddingHorizontalValue,
    this.contentPaddingverticalValue,
    this.cursorColor,
    this.hintColor,
    this.isDense = false,
    this.textAlign,
    this.borderWidth,
    this.labelText,
    this.prefixWidget,
    this.suffixWidget,
    this.labelStyle,
    this.floatingLabelStyle,
    this.floatingLabelBehavior,
    this.onTapOutside,
    this.titleStyle,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign ?? TextAlign.start,
      onTapOutside:
          onTapOutside ??
          (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
      cursorColor: cursorColor ?? context.lightGreyColor,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.next,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      style:
          titleStyle ??
          AppTextStyles.getStyle(
            context,
            TextStyleType.mediumRegular,
            color: context.mainTextColor,
          ),
      keyboardType: textinputType,
      readOnly: readOnly,
      maxLength: maxLength,
      onChanged: onChanged,
      maxLines: obscureText ? 1 : maxline,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        errorMaxLines: 2,
        isDense: isDense,
        counterText: "",
        labelText: labelText,
        labelStyle:
            labelStyle ??
            AppTextStyles.getStyle(
              context,
              TextStyleType.mediumBold,
              fontSize: 16.rf(context),
              color: textColor ?? context.secondaryColor,
            ),
        floatingLabelStyle: floatingLabelStyle,
        floatingLabelBehavior: floatingLabelBehavior,
        suffixIcon: suffixWidget,
        prefixIcon: prefixWidget,
        contentPadding: EdgeInsets.symmetric(
          horizontal: contentPaddingHorizontalValue ?? 10.rh(context),
          vertical: contentPaddingverticalValue ?? 15.5.rh(context),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: forgotpasswordType == 1
              ? borderRadius!
              : BorderRadius.circular(10.rf(context)),
          borderSide: BorderSide(
            color: borderColor ?? context.secondaryColor,
            width: borderWidth ?? 2.rw(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: forgotpasswordType == 1
              ? borderRadius!
              : BorderRadius.circular(10.rf(context)),
          borderSide: BorderSide(
            color: borderColor ?? context.secondaryColor,
            width: borderWidth ?? 2.rw(context),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: forgotpasswordType == 1
              ? borderRadius!
              : BorderRadius.circular(10.rf(context)),
          borderSide: BorderSide(color: context.failureColor),
        ),
        hintText: titles,
        errorStyle: TextStyle(
          fontSize: 12.rf(context),
          fontWeight: FontWeight.w600,
        ),
        hintStyle:
            hintStyle ??
            AppTextStyles.getStyle(
              context,
              TextStyleType.mediumRegular,
              color: hintColor ?? context.hintTextColor,
            ),
        border: OutlineInputBorder(
          borderRadius: forgotpasswordType == 1
              ? borderRadius!
              : BorderRadius.circular(10.rf(context)),
        ),
      ),
    );
  }
}
