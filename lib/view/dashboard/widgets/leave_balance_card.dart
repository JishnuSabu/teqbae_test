import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:teqbae_test/controller/provider/dashboard_provider.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/routes/route_names.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:teqbae_test/core/widgets/custom_button_widget.dart';
import 'package:teqbae_test/core/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class LeaveBalanceCard extends StatelessWidget {
  const LeaveBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = context.watch<DashboardProvider>();
    final balance = dashboardProvider.leaveBalance;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rw(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiUtils.textWidgetCard(
                context: context,
                title: "Leave Overview",
                styleType: TextStyleType.mediumSemiBold,
                fz: 16.rf(context),
                color: context.textColor2,
              ),
              InkWell(
                onTap: () => context.pushNamed(RouteNames.leave),
                borderRadius: BorderRadius.circular(6.rf(context)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 4.rh(context), horizontal: 4.rw(context)),
                  child: Row(
                    children: [
                      UiUtils.textWidgetCard(
                        context: context,
                        title: "View All",
                        styleType: TextStyleType.smallRegular,
                        color: context.themeColor,
                      ),
                      SizedBox(width: 4.rw(context)),
                      UiUtils.getSvg(
                        ConstSvgIcons.arrowRight,
                        color: context.themeColor,
                        height: 12.rh(context),
                        width: 12.rw(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.rh(context)),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.pushNamed(RouteNames.leave),
                  child: CustomCard(
                    value: balance.casual.toString().padLeft(2, '0'),
                    unit: "Days",
                    showUnit: true,
                    label: "Casual Leave",
                    img: ConstSvgIcons.casual,
                    labelClr: context.homeGridTextColor,
                    height: 78.rh(context),
                  ),
                ),
              ),
              SizedBox(width: 12.rw(context)),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.pushNamed(RouteNames.leave),
                  child: CustomCard(
                    value: balance.sick.toString().padLeft(2, '0'),
                    unit: "Days",
                    showUnit: true,
                    label: "Sick Leave",
                    img: ConstSvgIcons.sick,
                    labelClr: context.homeGridTextColor,
                    height: 78.rh(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.rh(context)),
          CustomButtonWidget(
            title: "Apply for Leave",
            useIcon: true,
            buttonIcon: ConstSvgIcons.applyLeave,
            buttonIconColor: context.whiteColor,
            bottonColor: context.themeColor,
            titleColor: context.whiteColor,
            height: 46.rh(context),
            borderRadius: 10.rf(context),
            onTap: () {
              context.pushNamed(RouteNames.applyLeave);
            },
          ),
        ],
      ),
    );
  }
}
