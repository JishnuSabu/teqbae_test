import 'package:teqbae_test/core/themes/color/color_theme_genarator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_packages/flutter_local_packages.dart';
import 'package:shimmer/shimmer.dart';

Widget customShimmerLoadingWidget({
  required BuildContext context,
  required double height,
  required double width,
  double radius = 10,
}) {
  return CustomShimmer(
    height: height,
    width: width,
    borderRadius: radius,
  );
}

class CustomShimmerLoadingWidget extends StatelessWidget {
  final int? count;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  const CustomShimmerLoadingWidget({
    super.key,
    this.count = 10,
    this.physics = const NeverScrollableScrollPhysics(),
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView.separated(
        physics: physics,
        shrinkWrap: shrinkWrap,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.rw(context)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomShimmer(height: 63.rh(context), width: 63.rh(context)),
                SizedBox(width: 12.rw(context)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(
                        height: 15.rh(context),
                        width: double.infinity,
                      ),
                      SizedBox(height: 5.rh(context)),
                      CustomShimmer(
                        height: 15.rh(context),
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 10.rh(context)),
        itemCount: count!,
      ),
    );
  }
}

class CustomShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? baseColor;
  final Color? highlightColor;
  const CustomShimmer({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.shimmerBaseColor,
      highlightColor: context.shimmerHighlightColor,
      child: Container(
        width: width,
        margin: margin,
        height: height ?? 10.rh(context),
        decoration: BoxDecoration(
          color: context.shimmerBaseColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 10.rw(context)),
        ),
      ),
    );
  }
}
