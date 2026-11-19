library flutter_local_packages;

import 'package:flutter/widgets.dart';

extension ResponsiveExtension on num {
  double rh(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return (this / 812.0) * height;
  }

  double rw(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (this / 375.0) * width;
  }

  double rf(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (this / 375.0) * width;
  }
}
