import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:provider/provider.dart';
import 'package:teqbae_test/controller/provider/dashboard_provider.dart';
import 'package:teqbae_test/core/constants/assets/const_images.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:teqbae_test/core/widgets/body_frame_widget.dart';
import 'package:teqbae_test/model/employee/employee_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final employee = dashboardProvider.employee;

    return BodyFrameWidget(
      title: "Profile info",
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileCard(context, employee),
          SizedBox(height: 16.rh(context)),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, "Personal Information"),
                  _buildCardBlock(
                    context: context,
                    children: [
                      _buildInfoRow(context, "Employee ID", employee.id),
                      _buildRowDivider(context),
                      _buildInfoRow(context, "Full Name", employee.name),
                      _buildRowDivider(context),
                      _buildInfoRow(
                        context,
                        "Department",
                        employee.department.isNotEmpty
                            ? employee.department
                            : "-",
                      ),
                      _buildRowDivider(context),
                      _buildInfoRow(
                        context,
                        "Designation",
                        employee.designation.isNotEmpty
                            ? employee.designation
                            : "-",
                      ),
                    ],
                  ),
                  SizedBox(height: 16.rh(context)),
                  if (employee.office != null) ...[
                    _buildSectionHeader(context, "Office & Location"),
                    _buildCardBlock(
                      context: context,
                      children: [
                        _buildInfoRow(
                          context,
                          "Office Name",
                          employee.office!.name,
                        ),
                        _buildRowDivider(context),
                        _buildInfoRow(
                          context,
                          "Geofence Radius",
                          "${employee.office!.radiusMeters.toInt()} meters",
                        ),
                        _buildRowDivider(context),
                        _buildInfoRow(
                          context,
                          "Timezone",
                          employee.office!.timezone,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.rh(context)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, EmployeeModel employee) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.rf(context)),
      decoration: BoxDecoration(
        color: context.themeColor,
        borderRadius: BorderRadius.circular(20.rf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50.rh(context),
                height: 50.rh(context),
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
              SizedBox(width: 14.rw(context)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UiUtils.textWidgetCard(
                    context: context,
                    title: employee.name,
                    styleType: TextStyleType.mediumSemiBold,
                    fz: 18.rf(context),
                    color: context.whiteColor,
                  ),
                  SizedBox(height: 2.rh(context)),
                  UiUtils.textWidgetCard(
                    context: context,
                    title: "Emp Code: ${employee.id}",
                    styleType: TextStyleType.smallSemiBold,
                    fz: 12.rf(context),
                    color: context.whiteColor.withOpacity(0.8),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.rh(context)),
          _buildCardRow(
            context,
            "Designation",
            employee.designation.isNotEmpty ? employee.designation : "-",
          ),
          _buildCardRow(
            context,
            "Department",
            employee.department.isNotEmpty
                ? employee.department
                : "-",
          ),
          if (employee.office != null)
            _buildCardRow(
              context,
              "Office",
              employee.office!.name,
            ),
        ],
      ),
    );
  }

  Widget _buildCardRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.rh(context)),
      child: Row(
        children: [
          SizedBox(
            width: 130.rw(context),
            child: UiUtils.textWidgetCard(
              context: context,
              title: label,
              styleType: TextStyleType.mediumSemiBold,
              color: context.whiteColor,
            ),
          ),
          Expanded(
            child: UiUtils.textWidgetCard(
              context: context,
              title: ":  $value",
              styleType: TextStyleType.mediumRegular,
              color: context.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.rw(context), bottom: 8.rh(context)),
      child: UiUtils.textWidgetCard(
        context: context,
        title: title,
        styleType: TextStyleType.smallBold,
        color: context.textColor2,
      ),
    );
  }

  Widget _buildCardBlock({
    required BuildContext context,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.rw(context)),
      decoration: BoxDecoration(
        color: context.mainCardColor,
        borderRadius: BorderRadius.circular(20.rf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.rh(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UiUtils.textWidgetCard(
            context: context,
            title: label,
            styleType: TextStyleType.smallSemiBold,
            color: context.textColor2,
          ),
          UiUtils.textWidgetCard(
            context: context,
            title: value,
            styleType: TextStyleType.smallRegular,
            color: context.textColor2,
          ),
        ],
      ),
    );
  }

  Widget _buildRowDivider(BuildContext context) {
    return Divider(
      color: context.primaryGreyColor.withOpacity(0.2),
      height: 1,
      thickness: 0.3.rf(context),
    );
  }
}
