import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<T> customTransitionPageWidget<T>({
  required Widget child,
  required LocalKey key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (Platform.isIOS) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      } else {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      }
    },
  );
}
