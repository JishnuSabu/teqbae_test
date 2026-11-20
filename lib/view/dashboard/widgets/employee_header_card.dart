import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/controller/provider/dashboard_provider.dart';
import 'package:teqbae_test/core/services/location_service.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:provider/provider.dart';

class EmployeeHeaderCard extends StatelessWidget {
  const EmployeeHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final employee = dashboardProvider.employee;

    const String simLabel = "Live Device GPS";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.rf(context)),
      decoration: BoxDecoration(
        color: context.mainCardColor,
        borderRadius: BorderRadius.circular(16.rf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26.rf(context),
                backgroundColor: context.primaryGreyColor.withOpacity(0.15),
                child: Text(
                  employee.name.isNotEmpty
                      ? employee.name.split(' ').map((n) => n[0]).take(2).join()
                      : "EM",
                  style: TextStyle(
                    fontSize: 16.rf(context),
                    fontWeight: FontWeight.bold,
                    color: context.primaryGreyColor,
                  ),
                ),
              ),
              SizedBox(width: 14.rw(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UiUtils.textWidgetCard(
                      context: context,
                      title: employee.name,
                      styleType: TextStyleType.headline2,
                      fz: 17.rf(context),
                      color: context.textColor2,
                    ),
                    SizedBox(height: 2.rh(context)),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.rw(context),
                              vertical: 2.rh(context)),
                          decoration: BoxDecoration(
                            color: context.secondCardColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            employee.id,
                            style: TextStyle(
                              fontSize: 10.rf(context),
                              fontWeight: FontWeight.w600,
                              color: context.textColor2,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.rw(context)),
                        Text(
                          "•  ${employee.department}",
                          style: TextStyle(
                            fontSize: 12.rf(context),
                            color: context.textColor2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.rh(context)),
          Divider(color: context.textColor2.withOpacity(0.15), height: 1),
          SizedBox(height: 8.rh(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14.rf(context), color: context.textColor2),
                  SizedBox(width: 4.rw(context)),
                  Text(
                    LocationService.officeName,
                    style: TextStyle(
                        fontSize: 11.rf(context), color: context.textColor2),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 6.rw(context), vertical: 2.rh(context)),
                decoration: BoxDecoration(
                  color: context.successColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  simLabel,
                  style: TextStyle(
                    fontSize: 9.rf(context),
                    fontWeight: FontWeight.w600,
                    color: context.successColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
