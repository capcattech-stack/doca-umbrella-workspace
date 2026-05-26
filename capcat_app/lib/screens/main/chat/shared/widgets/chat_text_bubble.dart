import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';

class ChatTextBubble extends StatelessWidget {
  const ChatTextBubble({
    super.key,
    required this.text,
    required this.timeLabel,
    required this.maxWidth,
    required this.backgroundColor,
    required this.textColor,
    required this.timeColor,
    this.replyCount,
    this.showThreadButton = false,
    this.onSeeMore,
  });

  final String text;
  final String timeLabel;
  final double maxWidth;
  final Color backgroundColor;
  final Color textColor;
  final Color timeColor;
  final int? replyCount;
  final bool showThreadButton;
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.fromLTRB(SC.sw(16), SC.sh(16), SC.sw(16), SC.sh(8)),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: SC.sf(14),
                height: 1.4,
                color: textColor,
              ),
            ),
            SizedBox(height: SC.sh(6)),
            if (showThreadButton && onSeeMore != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TapEffect(
                    onTap: onSeeMore,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SC.sw(12),
                        vertical: SC.sh(6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            replyCount != null
                                ? '${replyCount!} phản hồi'
                                : 'Xem thêm',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w600,
                              fontSize: SC.sf(12),
                              color: textColor,
                            ),
                          ),
                          SizedBox(width: SC.sw(6)),
                          Image.asset(
                            'assets/icons/ab-chevron-right.png',
                            width: SC.smin(12),
                            height: SC.smin(12),
                            color: textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    timeLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(12),
                      color: timeColor,
                    ),
                  ),
                ],
              )
            else
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: SC.sf(12),
                    color: timeColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
