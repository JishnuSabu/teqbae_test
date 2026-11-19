import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:teqbae_test/core/network/mock_http_server.dart';
import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:teqbae_test/core/themes/text/app_text.dart';
import 'package:teqbae_test/core/utils/ui_utils.dart';

void showMockScenarioDialog(BuildContext context, {VoidCallback? onScenarioChanged}) {
  showDialog(
    context: context,
    builder: (ctx) => _MockScenarioDialog(onScenarioChanged: onScenarioChanged),
  );
}

class _MockScenarioDialog extends StatefulWidget {
  final VoidCallback? onScenarioChanged;
  const _MockScenarioDialog({this.onScenarioChanged});

  @override
  State<_MockScenarioDialog> createState() => _MockScenarioDialogState();
}

class _MockScenarioDialogState extends State<_MockScenarioDialog> {
  late MockScenario _selected;

  @override
  void initState() {
    super.initState();
    _selected = MockHttpServer.activeScenario;
  }

  String _scenarioTitle(MockScenario s) {
    switch (s) {
      case MockScenario.normal:
        return "1. Successful Responses (200 OK)";
      case MockScenario.slow:
        return "2. Slow Responses (4s Delay)";
      case MockScenario.timeout:
        return "3. Simulated Timeout (35s Delay)";
      case MockScenario.serverError:
        return "4. Server Errors (500 Error)";
      case MockScenario.duplicateConflict:
        return "5. Duplicate Attendance Conflict (409)";
      case MockScenario.leaveRejection:
        return "6. Leave Validation Rejection (422)";
    }
  }

  String _scenarioDesc(MockScenario s) {
    switch (s) {
      case MockScenario.normal:
        return "Standard responses for all endpoints.";
      case MockScenario.slow:
        return "Simulates high latency or slow network connection.";
      case MockScenario.timeout:
        return "Triggers client-side request timeout handling.";
      case MockScenario.serverError:
        return "Endpoints return 500 internal server error.";
      case MockScenario.duplicateConflict:
        return "POST /attendance/events returns 409 conflict.";
      case MockScenario.leaveRejection:
        return "POST /leave/requests returns 422 validation rejection.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.mainCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.rf(context)),
      ),
      title: Row(
        children: [
          Icon(Icons.science_outlined, color: context.themeColor, size: 22.rf(context)),
          SizedBox(width: 8.rw(context)),
          Text(
            "Mock API Scenarios",
            style: TextStyle(
              fontSize: 16.rf(context),
              fontWeight: FontWeight.bold,
              color: context.mainTextColor,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiUtils.textWidgetCard(
              context: context,
              title: "Select an active scenario to test edge cases without real backend credentials:",
              styleType: TextStyleType.extraSmallRegular,
              color: context.primaryGreyColor,
            ),
            SizedBox(height: 12.rh(context)),
            ...MockScenario.values.map((scenario) {
              final isSelected = _selected == scenario;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selected = scenario;
                    MockHttpServer.activeScenario = scenario;
                  });
                  widget.onScenarioChanged?.call();
                },
                borderRadius: BorderRadius.circular(10.rf(context)),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.rh(context)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.rw(context),
                    vertical: 8.rh(context),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.themeColor.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.rf(context)),
                    border: Border.all(
                      color: isSelected
                          ? context.themeColor
                          : context.primaryGreyColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected
                            ? context.themeColor
                            : context.primaryGreyColor,
                        size: 18.rf(context),
                      ),
                      SizedBox(width: 10.rw(context)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _scenarioTitle(scenario),
                              style: TextStyle(
                                fontSize: 13.rf(context),
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? context.themeColor
                                    : context.mainTextColor,
                              ),
                            ),
                            SizedBox(height: 2.rh(context)),
                            Text(
                              _scenarioDesc(scenario),
                              style: TextStyle(
                                fontSize: 11.rf(context),
                                color: context.primaryGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(height: 12.rh(context)),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  MockHttpServer.resetData();
                  setState(() {
                    _selected = MockScenario.normal;
                  });
                  widget.onScenarioChanged?.call();
                  UiUtils.showSnackBarMessage(
                    context,
                    "Mock database reset to initial state.",
                    isSuccess: true,
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Reset Mock Data"),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Close",
            style: TextStyle(
              color: context.themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
