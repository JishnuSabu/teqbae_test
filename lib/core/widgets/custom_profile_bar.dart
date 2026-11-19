import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:teqbae_test/core/constants/assets/const_images.dart';
import 'package:teqbae_test/core/routes/route_names.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:teqbae_test/model/employee/employee_model.dart';
import 'package:teqbae_test/view/settings/widgets/theme_bottom_sheet.dart';

class CustomProfileBar extends StatelessWidget implements PreferredSizeWidget {
  final EmployeeModel employee;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const CustomProfileBar({
    super.key,
    required this.employee,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.rw(context),
        vertical: 10.rh(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onProfileTap ??
                () {
                  context.pushNamed(RouteNames.profile);
                },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: 48.rh(context),
                  height: 48.rh(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.whiteColor,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: const AssetImage(ConstImages.profile),
                      colorFilter: ColorFilter.mode(
                        context.whiteColor,
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.rw(context)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UiUtils.textWidgetCard(
                      title: employee.name.isNotEmpty ? employee.name : "Employee",
                      context: context,
                      styleType: TextStyleType.mediumSemiBold,
                      fz: 18.rf(context),
                      color: context.whiteColor,
                    ),
                    if (employee.id.isNotEmpty || employee.department.isNotEmpty) ...[
                      SizedBox(height: 2.rh(context)),
                      UiUtils.textWidgetCard(
                        title: [
                          if (employee.id.isNotEmpty) employee.id,
                          if (employee.department.isNotEmpty) employee.department,
                        ].join(" • "),
                        context: context,
                        styleType: TextStyleType.extraSmallRegular,
                        color: context.primaryGreyColor,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onNotificationTap ?? () => showThemeMenu(context),
            child: Container(
              width: 38.rh(context),
              height: 38.rh(context),
              decoration: BoxDecoration(
                color: context.notificationContainerColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.brightness_medium_rounded,
                  color: context.whiteColor,
                  size: 20.rf(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
