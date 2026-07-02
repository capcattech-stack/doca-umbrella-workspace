import 'package:flutter/material.dart';
import 'package:capcat_doca/screens/main/chat/shared/models/chat_view_contracts.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';

class ChatInputGroup extends StatelessWidget {
  const ChatInputGroup({
    super.key,
    required this.controller,
    required this.data,
    required this.actions,
  });

  final TextEditingController controller;
  final ChatComposerViewData data;
  final ChatComposerActions actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AC.yellowChatInputGroup,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      padding: EdgeInsets.fromLTRB(SC.sw(12), SC.sh(12), SC.sw(12), SC.sh(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TapEffect(
            onTap: data.isToolPanelEnabled ? actions.onToggleTools : null,
            child: Image.asset(
              'assets/icons/chat-tools-box.png',
              width: SC.smin(24),
            ),
          ),
          SizedBox(width: SC.sw(12)),
          Expanded(
            child: Container(
              height: SC.sh(46),
              padding: EdgeInsets.symmetric(horizontal: SC.sw(12)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: data.hintText,
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: SC.sw(12)),
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final text = controller.text;
              final hasText = text.trim().isNotEmpty;
              final disabled = data.isSendDisabled;
              final shouldShow = hasText || data.hasPendingAttachments;
              final child = shouldShow
                  ? Opacity(
                      key: const ValueKey('paw-visible'),
                      opacity: disabled ? 0.3 : 1,
                      child: TapEffect(
                        onTap: disabled ? null : () => actions.onSendText(text),
                        child: Image.asset(
                          'assets/icons/chat-paw.png',
                          width: SC.smin(46),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('paw-hidden'));
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.horizontal,
                      axisAlignment: -1,
                      child: child,
                    ),
                  );
                },
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}
