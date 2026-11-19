import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 20.rw(context),
        right: 20.rw(context),
        bottom: 20.rh(context),
      ),
      height: 56.rh(context),
      decoration: BoxDecoration(
        color: context.bottomBarColor,
        borderRadius: BorderRadius.circular(16.rf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            image: ConstSvgIcons.home,
            imageActive: ConstSvgIcons.homeActive,
            label: "Home",
            context: context,
          ),
          _buildNavItem(
            index: 1,
            image: ConstSvgIcons.leave,
            imageActive: ConstSvgIcons.applyLeave,
            label: "Leaves",
            context: context,
          ),
          _buildNavItem(
            index: 2,
            image: ConstSvgIcons.settings,
            imageActive: ConstSvgIcons.settingsActive,
            label: "Settings",
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String image,
    required String imageActive,
    required String label,
    required BuildContext context,
  }) {
    final bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        height: 40.rh(context),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16.rw(context) : 10.rw(context),
          vertical: 8.rh(context),
        ),
        decoration: BoxDecoration(
          color: isActive ? context.themeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25.rf(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UiUtils.getSvg(
              isActive ? imageActive : image,
              color: isActive ? Colors.white : context.bottomBarSvgColor,
              height: 20.rh(context),
              width: 20.rw(context),
            ),
            if (isActive) ...[
              SizedBox(width: 6.rw(context)),
              UiUtils.textWidgetCard(
                title: label,
                context: context,
                styleType: TextStyleType.smallBold,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
