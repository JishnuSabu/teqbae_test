import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:teqbae_test/controller/provider/leave/leave_provider.dart';
import 'package:teqbae_test/core/constants/assets/const_svg.dart';
import 'package:teqbae_test/core/network/api_status.dart';
import 'package:teqbae_test/core/routes/route_names.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';
import 'package:teqbae_test/core/widgets/body_frame_widget.dart';
import 'package:teqbae_test/core/widgets/custom_card.dart';
import 'package:teqbae_test/core/widgets/custom_shimmer_loading_widget.dart';
import 'package:teqbae_test/model/leave/leave_request_model.dart';
import 'package:provider/provider.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  String _formatDate(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveProvider = context.watch<LeaveProvider>();

    if (leaveProvider.leaveRequestsResponse.status == ApiStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        leaveProvider.fetchLeaveData();
      });
    }

    final balance = leaveProvider.leaveBalance;
    final requests = leaveProvider.filteredLeaveRequests;
    final allRequests = leaveProvider.leaveRequests;
    final isLoading =
        leaveProvider.leaveRequestsResponse.status == ApiStatus.loading &&
            allRequests.isEmpty;

    return BodyFrameWidget(
      title: "Leave Management",
      iconText: "Apply",
      iconImg: ConstSvgIcons.add,
      showLeading: true,
      iconOnTap: () {
        context.pushNamed(RouteNames.applyLeave);
      },
      widget: isLoading
          ? _buildLoadingState(context)
          : RefreshIndicator(
              onRefresh: () => leaveProvider.fetchLeaveData(),
              color: context.themeColor,
              backgroundColor: context.mainCardColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
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
                        SizedBox(width: 12.rw(context)),
                        Expanded(
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
                      ],
                    ),
                    SizedBox(height: 14.rh(context)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.rw(context),
                        vertical: 12.rh(context),
                      ),
                      decoration: BoxDecoration(
                        color: context.mainCardColor,
                        borderRadius: BorderRadius.circular(12.rf(context)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              UiUtils.getSvg(
                                ConstSvgIcons.leave,
                                color: context.themeColor,
                                height: 22.rh(context),
                                width: 22.rw(context),
                              ),
                              SizedBox(width: 10.rw(context)),
                              UiUtils.textWidgetCard(
                                context: context,
                                title: "Total Annual Allowance",
                                styleType: TextStyleType.smallSemiBold,
                                color: context.textColor2,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.rw(context),
                              vertical: 4.rh(context),
                            ),
                            decoration: BoxDecoration(
                              color: context.themeColor.withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(8.rf(context)),
                            ),
                            child: UiUtils.textWidgetCard(
                              context: context,
                              title: "${balance.total} Days Left",
                              styleType: TextStyleType.smallBold,
                              color: context.themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.rh(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UiUtils.textWidgetCard(
                          context: context,
                          title: "Leave History",
                          styleType: TextStyleType.mediumSemiBold,
                          fz: 16.rf(context),
                          color: context.textColor2,
                        ),
                        UiUtils.textWidgetCard(
                          context: context,
                          title: "${requests.length} of ${allRequests.length}",
                          styleType: TextStyleType.extraSmallRegular,
                          color: context.primaryGreyColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.rh(context)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(context, leaveProvider, "All"),
                          SizedBox(width: 8.rw(context)),
                          _buildFilterChip(context, leaveProvider, "Pending"),
                          SizedBox(width: 8.rw(context)),
                          _buildFilterChip(context, leaveProvider, "Approved"),
                          SizedBox(width: 8.rw(context)),
                          _buildFilterChip(context, leaveProvider, "Rejected"),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.rh(context)),
                    if (requests.isEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 40.rh(context)),
                        decoration: BoxDecoration(
                          color: context.mainCardColor,
                          borderRadius: BorderRadius.circular(15.rf(context)),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            UiUtils.getSvg(
                              ConstSvgIcons.leave,
                              color: context.primaryGreyColor.withOpacity(0.4),
                              height: 40.rh(context),
                              width: 40.rw(context),
                            ),
                            SizedBox(height: 8.rh(context)),
                            UiUtils.textWidgetCard(
                              title: "No leave requests in this category",
                              context: context,
                              styleType: TextStyleType.smallRegular,
                              color: context.primaryGreyColor,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: requests.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: 10.rh(context)),
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          return _buildLeaveRequestCard(context, request);
                        },
                      ),
                    ],
                    SizedBox(height: 24.rh(context)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    LeaveProvider provider,
    String filterLabel,
  ) {
    final isSelected = provider.selectedFilter == filterLabel;

    return GestureDetector(
      onTap: () => provider.setFilter(filterLabel),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 14.rw(context),
          vertical: 6.rh(context),
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.themeColor : context.mainCardColor,
          borderRadius: BorderRadius.circular(20.rf(context)),
          border: Border.all(
            color: isSelected
                ? context.themeColor
                : context.primaryGreyColor.withOpacity(0.2),
          ),
        ),
        child: Text(
          filterLabel,
          style: TextStyle(
            fontSize: 12.rf(context),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? context.whiteColor : context.primaryGreyColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveRequestCard(
      BuildContext context, LeaveRequestModel request) {
    final statusColor = _getStatusColor(context, request.status);
    final statusText = _getStatusText(request.status);
    final isCasual = request.leaveType.toLowerCase() == 'casual';

    return Container(
      padding: EdgeInsets.all(14.rf(context)),
      decoration: BoxDecoration(
        color: context.mainCardColor,
        borderRadius: BorderRadius.circular(12.rf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 34.rh(context),
                    height: 34.rh(context),
                    decoration: BoxDecoration(
                      color:
                          (isCasual ? context.themeColor : context.orangeColor)
                              .withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: UiUtils.getSvg(
                        isCasual ? ConstSvgIcons.casual : ConstSvgIcons.sick,
                        color:
                            isCasual ? context.themeColor : context.orangeColor,
                        height: 18.rh(context),
                        width: 18.rw(context),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.rw(context)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UiUtils.textWidgetCard(
                        context: context,
                        title:
                            "${request.leaveType[0].toUpperCase()}${request.leaveType.substring(1)} Leave",
                        styleType: TextStyleType.smallSemiBold,
                        fz: 14.rf(context),
                        color: context.mainTextColor,
                      ),
                      UiUtils.textWidgetCard(
                        context: context,
                        title:
                            "${request.days} ${request.days == 1 ? 'Day' : 'Days'}",
                        styleType: TextStyleType.extraSmallRegular,
                        color: context.primaryGreyColor,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.rw(context),
                  vertical: 4.rh(context),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.rf(context)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.rf(context),
                      height: 6.rf(context),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.rw(context)),
                    UiUtils.textWidgetCard(
                      context: context,
                      title: statusText,
                      styleType: TextStyleType.extraSmallsemiBold,
                      fz: 11.rf(context),
                      color: statusColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.rh(context)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.rw(context),
              vertical: 8.rh(context),
            ),
            decoration: BoxDecoration(
              color: context.secondCardColor,
              borderRadius: BorderRadius.circular(8.rf(context)),
            ),
            child: Row(
              children: [
                UiUtils.getSvg(
                  ConstSvgIcons.calender,
                  color: context.primaryGreyColor,
                  height: 14.rh(context),
                  width: 14.rw(context),
                ),
                SizedBox(width: 8.rw(context)),
                UiUtils.textWidgetCard(
                  context: context,
                  title:
                      "${_formatDate(request.startDate)}  →  ${_formatDate(request.endDate)}",
                  styleType: TextStyleType.extraSmallRegular,
                  color: context.textColor2,
                ),
              ],
            ),
          ),
          if (request.reason.isNotEmpty) ...[
            SizedBox(height: 8.rh(context)),
            UiUtils.textWidgetCard(
              context: context,
              title: "Reason: ${request.reason}",
              styleType: TextStyleType.extraSmallRegular,
              color: context.primaryGreyColor,
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return context.successColor;
      case 'rejected':
        return context.failureColor;
      case 'pending':
      default:
        return context.orangeColor;
    }
  }

  String _getStatusText(String status) {
    if (status.isEmpty) return "Pending";
    return status[0].toUpperCase() + status.substring(1);
  }

  Widget _buildLoadingState(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomShimmer(height: 78.rh(context), borderRadius: 10.rf(context)),
          SizedBox(height: 14.rh(context)),
          CustomShimmer(height: 50.rh(context), borderRadius: 12.rf(context)),
          SizedBox(height: 16.rh(context)),
          CustomShimmer(height: 90.rh(context), borderRadius: 12.rf(context)),
          SizedBox(height: 10.rh(context)),
          CustomShimmer(height: 90.rh(context), borderRadius: 12.rf(context)),
        ],
      ),
    );
  }
}
