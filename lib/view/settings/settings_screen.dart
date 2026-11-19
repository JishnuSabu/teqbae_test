import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teqbae_test/controller/provider/dashboard_provider.dart';
import 'package:teqbae_test/controller/provider/theme/theme_provider.dart';
import 'package:teqbae_test/controller/service/theme/theme_service.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/routes/route_names.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:teqbae_test/core/widgets/custom_profile_bar.dart';
import 'package:teqbae_test/view/dashboard/widgets/sync_status_banner.dart';
import 'package:teqbae_test/view/settings/widgets/theme_bottom_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final employee = dashboardProvider.employee;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.rh(context)),
            CustomProfileBar(
              employee: employee,
            ),
            SizedBox(height: 14.rh(context)),
            _buildCardBlock(
              context: context,
              children: [
                _buildSettingsTile(
                  context: context,
                  img: ConstSvgIcons.profile,
                  title: "Profile",
                  onTap: () {
                    context.pushNamed(RouteNames.profile);
                  },
                ),
                _buildDivider(context),
                _buildSettingsTile(
                  context: context,
                  img: ConstSvgIcons.themeIcon,
                  title: "Theme",
                  trailing: Consumer<ThemeProvider>(
                    builder: (context, tp, _) {
                      String modeText = "System Default";
                      if (tp.themeMode == ThemeService.LIGHT_MODE) {
                        modeText = "Light Mode";
                      } else if (tp.themeMode == ThemeService.DARK_MODE) {
                        modeText = "Dark Mode";
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UiUtils.textWidgetCard(
                            context: context,
                            title: modeText,
                            styleType: TextStyleType.smallSemiBold,
                            color: context.primaryGreyColor,
                          ),
                          SizedBox(width: 8.rw(context)),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14.rf(context),
                            color: context.primaryGreyColor,
                          ),
                        ],
                      );
                    },
                  ),
                  showArrow: false,
                  onTap: () {
                    showThemeMenu(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16.rh(context)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.rw(context)),
              child: const SyncStatusBanner(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBlock({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.rw(context)),
      padding: EdgeInsets.symmetric(horizontal: 16.rw(context)),
      decoration: BoxDecoration(
        color: context.mainCardColor,
        borderRadius: BorderRadius.circular(20.rf(context)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    String? img,
    IconData? icon,
    required String title,
    bool showArrow = true,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.rh(context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36.rh(context),
              height: 36.rh(context),
              decoration: BoxDecoration(
                color: context.themeColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        color: context.whiteColor,
                        size: 18.rf(context),
                      )
                    : (img != null
                        ? UiUtils.getSvg(
                            img,
                            color: context.whiteColor,
                            height: 16.rh(context),
                            width: 16.rw(context),
                          )
                        : const SizedBox.shrink()),
              ),
            ),
            SizedBox(width: 14.rw(context)),
            Expanded(
              child: UiUtils.textWidgetCard(
                context: context,
                title: title,
                styleType: TextStyleType.mediumRegular,
                color: context.textColor2,
              ),
            ),
            if (trailing != null)
              trailing
            else if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 14.rf(context),
                color: context.primaryGreyColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.rw(context)),
      child: Divider(
        color: context.primaryGreyColor.withOpacity(0.2),
        height: 1,
        thickness: 0.3.rf(context),
      ),
    );
  }
}
