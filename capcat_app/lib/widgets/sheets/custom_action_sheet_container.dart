import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import '../../utils/size_config.dart';

/// Reusable base action sheet container with handle and rounded top corners.
/// Wrap your sheet content with this to get consistent styling.
class CustomActionSheetContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final bool showHandle;
  final EdgeInsets? padding;
  final Color backgroundColor;
  final bool expandChild;
  final Clip clipBehavior;

  const CustomActionSheetContainer({
    super.key,
    required this.child,
    this.height,
    this.showHandle = true,
    this.padding,
    // this.backgroundColor = AC.background,
    this.backgroundColor = AC.white,
    this.expandChild = false,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: height ?? double.infinity),
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color.fromRGBO(12, 26, 75, 0.1),
        //     blurRadius: 8,
        //     offset: Offset(0, 0),
        //   ),
        //   BoxShadow(
        //     color: Color.fromRGBO(50, 50, 71, 0.02),
        //     blurRadius: 20,
        //     offset: Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            SizedBox(height: SC.sh(8)),
            Container(
              width: SC.sw(80),
              height: SC.sh(5),
              decoration: BoxDecoration(
                color: AC.greyText6,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(height: SC.sh(8)),
          ],
          if (expandChild)
            Expanded(
              child: Padding(
                padding:
                    padding ??
                    EdgeInsets.fromLTRB(
                      SC.sw(16),
                      SC.sh(16),
                      SC.sw(16),
                      MQ.bottomPadding(context) + SC.sh(16),
                    ),
                child: child,
              ),
            )
          else
            Padding(
              padding:
                  padding ??
                  EdgeInsets.fromLTRB(
                    SC.sw(16),
                    SC.sh(16),
                    SC.sw(16),
                    MQ.bottomPadding(context) + SC.sh(16),
                  ),
              child: child,
            ),
        ],
      ),
    );
  }
}
