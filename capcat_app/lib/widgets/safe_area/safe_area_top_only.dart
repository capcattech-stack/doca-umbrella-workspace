import 'package:flutter/widgets.dart';

class SafeAreaTopOnly extends StatelessWidget {
  final Widget child;
  final bool left;
  final bool right;
  final EdgeInsets? minimum;
  final bool maintainBottomViewPadding;

  const SafeAreaTopOnly({
    super.key,
    required this.child,
    this.left = true,
    this.right = true,
    this.minimum,
    this.maintainBottomViewPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      left: left,
      right: right,
      minimum: minimum ?? EdgeInsets.zero,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}
