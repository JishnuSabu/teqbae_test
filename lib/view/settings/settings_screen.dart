import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teqbae_test/controller/provider/dashboard_provider.dart';
import 'package:teqbae_test/controller/provider/theme/theme_provider.dart';
import 'package:teqbae_test/controller/service/theme/theme_service.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/routes/route_names.dart';
import 'package:teqbae_test/core/services/location_service.dart';
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
  /// Show bottom sheet for configuring office coordinates and radius
  void _showOfficeCoordinatesSheet(BuildContext context) {
    final latController = TextEditingController(
      text: LocationService.officeLatitude.toString(),
    );
    final lngController = TextEditingController(
      text: LocationService.officeLongitude.toString(),
    );
    final radiusController = TextEditingController(
      text: LocationService.permittedRadiusMeters.toInt().toString(),
    );
    bool isFetchingCurrentLoc = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.mainCardColor,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20.rf(context))),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20.rf(context),
            right: 20.rf(context),
            top: 20.rf(context),
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.rf(context),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UiUtils.textWidgetCard(
                      context: ctx,
                      title: 'Office Coordinates',
                      styleType: TextStyleType.mediumBold,
                      color: ctx.mainTextColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                      color: ctx.primaryGreyColor,
                    ),
                  ],
                ),
                UiUtils.textWidgetCard(
                  context: ctx,
                  title:
                      'Configure the office location and geofence radius for check-in verification.',
                  styleType: TextStyleType.extraSmallRegular,
                  color: ctx.primaryGreyColor,
                ),
                SizedBox(height: 16.rh(ctx)),
                _buildCoordinateField(
                  ctx: ctx,
                  controller: latController,
                  label: "Office Latitude",
                  hint: "e.g. 12.9716",
                  icon: Icons.my_location,
                ),
                SizedBox(height: 12.rh(ctx)),
                _buildCoordinateField(
                  ctx: ctx,
                  controller: lngController,
                  label: "Office Longitude",
                  hint: "e.g. 77.5946",
                  icon: Icons.location_searching,
                ),
                SizedBox(height: 12.rh(ctx)),
                _buildCoordinateField(
                  ctx: ctx,
                  controller: radiusController,
                  label: "Geofence Radius (meters)",
                  hint: "e.g. 200",
                  icon: Icons.radar,
                ),
                SizedBox(height: 16.rh(ctx)),
                // Set to current location button
                OutlinedButton.icon(
                  onPressed: isFetchingCurrentLoc
                      ? null
                      : () async {
                          setSheetState(() => isFetchingCurrentLoc = true);
                          try {
                            final loc =
                                await LocationService.getCurrentCoordinates();
                            if (loc.isSuccess &&
                                loc.latitude != null &&
                                loc.longitude != null) {
                              latController.text =
                                  loc.latitude!.toStringAsFixed(6);
                              lngController.text =
                                  loc.longitude!.toStringAsFixed(6);
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Captured current GPS coordinates!"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } else {
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text(loc.errorMessage ??
                                        "Could not get GPS position."),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text("Could not get GPS: $e"),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } finally {
                            setSheetState(() => isFetchingCurrentLoc = false);
                          }
                        },
                  icon: isFetchingCurrentLoc
                      ? SizedBox(
                          width: 14.rf(ctx),
                          height: 14.rf(ctx),
                          child:
                              const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.gps_fixed, size: 16.rf(ctx)),
                  label: Text(
                    isFetchingCurrentLoc
                        ? "Getting GPS..."
                        : "Set to My Current Location",
                    style: TextStyle(fontSize: 12.rf(ctx)),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ctx.themeColor,
                    side: BorderSide(color: ctx.themeColor),
                    minimumSize: Size(double.infinity, 42.rh(ctx)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.rf(ctx)),
                    ),
                  ),
                ),
                SizedBox(height: 10.rh(ctx)),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          await LocationService.resetToDefaultCoordinates();
                          latController.text = "12.9716";
                          lngController.text = "77.5946";
                          radiusController.text = "200";
                          setState(() {});
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Reset to default headquarters (12.9716, 77.5946, 200m)."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Reset Default",
                          style: TextStyle(
                            color: ctx.primaryGreyColor,
                            fontSize: 12.rf(ctx),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.rw(ctx)),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          final lat =
                              double.tryParse(latController.text.trim());
                          final lng =
                              double.tryParse(lngController.text.trim());
                          final rad =
                              double.tryParse(radiusController.text.trim());

                          if (lat == null || lng == null || rad == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please enter valid numeric coordinates and radius."),
                              ),
                            );
                            return;
                          }

                          await LocationService.updateOfficeCoordinates(
                            latitude: lat,
                            longitude: lng,
                            radiusMeters: rad,
                          );

                          if (ctx.mounted) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Office coordinates updated to $lat, $lng (${rad.toInt()}m)."),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ctx.themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.rf(ctx)),
                          ),
                          minimumSize: Size(double.infinity, 42.rh(ctx)),
                        ),
                        child: Text(
                          "Save Location",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.rf(ctx),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoordinateField({
    required BuildContext ctx,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UiUtils.textWidgetCard(
          context: ctx,
          title: label,
          styleType: TextStyleType.extraSmallRegular,
          color: ctx.primaryGreyColor,
        ),
        SizedBox(height: 4.rh(ctx)),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(
            fontSize: 13.rf(ctx),
            color: ctx.mainTextColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(fontSize: 12.rf(ctx), color: ctx.primaryGreyColor),
            prefixIcon:
                Icon(icon, size: 18.rf(ctx), color: ctx.primaryGreyColor),
            filled: true,
            fillColor: ctx.secondCardColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.rw(ctx),
              vertical: 10.rh(ctx),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.rf(ctx)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final employee = dashboardProvider.employee;

    final String officeCoordSummary =
        "${LocationService.officeLatitude.toStringAsFixed(4)}, ${LocationService.officeLongitude.toStringAsFixed(4)} • ${LocationService.permittedRadiusMeters.toInt()}m";

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
                _buildDivider(context),
                _buildSettingsTile(
                  context: context,
                  icon: Icons.location_on_outlined,
                  title: "Office Coordinates",
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UiUtils.textWidgetCard(
                        context: context,
                        title: officeCoordSummary,
                        styleType: TextStyleType.extraSmallRegular,
                        color: context.primaryGreyColor,
                      ),
                      SizedBox(width: 8.rw(context)),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.rf(context),
                        color: context.primaryGreyColor,
                      ),
                    ],
                  ),
                  showArrow: false,
                  onTap: () {
                    _showOfficeCoordinatesSheet(context);
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
