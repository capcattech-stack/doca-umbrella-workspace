import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';

class ExpandableTextContainer extends StatefulWidget {
  final String title;
  final String body;

  const ExpandableTextContainer({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  ExpandableTextContainerState createState() => ExpandableTextContainerState();
}

class ExpandableTextContainerState extends State<ExpandableTextContainer>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  bool canExpand = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkTextCanExpand();
  }

  void _checkTextCanExpand() {
    final TextSpan textSpan = TextSpan(
      text: widget.body,
      style: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w400,
        fontSize: SC.sf(14),
        height: 20 / 14,
        color: AC.slateSecondaryText,
      ),
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    setState(() {
      canExpand = textPainter.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int maxLines = isExpanded ? 50 : 2;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          SizedBox(
            width: double.infinity,
            height: SC.sh(24),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(16),
                  height: 24 / 16,
                  color: AC.blackText5,
                ),
              ),
            ),
          ),
          SizedBox(height: SC.sh(16)),

          // Body + Animation
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                widget.body,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w400,
                  fontSize: SC.sf(14),
                  height: 20 / 14,
                  color: AC.slateSecondaryText,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nút Xem thêm / Thu gọn
          if (canExpand)
            SizedBox(
              height: SC.sh(20),
              child: Align(
                alignment: Alignment.center,
                child: TapEffect(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? 'Thu gọn' : 'Xem thêm',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500,
                      fontSize: SC.sf(14),
                      height: 20 / 14,
                      color: AC.greenText1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
