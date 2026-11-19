import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/widgets/custom_app_bar.dart';

class BodyFrameWidget extends StatelessWidget {
  const BodyFrameWidget({
    super.key,
    required this.widget,
    this.onBackTap,
    required this.title,
    this.iconText,
    this.iconImg,
    this.showLeading = false,
    this.onTap,
    this.iconOnTap,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.actions,
  });

  final Widget widget;
  final VoidCallback? onBackTap;
  final String title;
  final String? iconText;
  final String? iconImg;
  final bool showLeading;
  final VoidCallback? onTap;
  final void Function()? iconOnTap;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (onBackTap != null) {
            onBackTap!();
          } else {
            context.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.primaryColor,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.rw(context)),
            child: Column(
              children: [
                SizedBox(height: 16.rh(context)),
                CustomAppBar(
                  text: title,
                  iconText: iconText,
                  iconImg: iconImg,
                  showLeading: showLeading,
                  onTap: onTap,
                  iconOnTap: iconOnTap,
                  actions: actions,
                ),
                SizedBox(height: 16.rh(context)),
                Expanded(child: widget),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
