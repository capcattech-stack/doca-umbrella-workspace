import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_mock_app/assistant/assistant_visibility_scope.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';

class ChatScreenShell extends StatelessWidget {
  const ChatScreenShell({
    super.key,
    required this.hideAssistantFab,
    this.showHeader = true,
    required this.onGlobalPointerDown,
    required this.contentFade,
    required this.headerTitle,
    required this.headerBody,
    required this.messagesContent,
    this.attachmentSection,
    required this.composer,
    required this.showToolPanel,
    required this.toolPanel,
    required this.bottomInsetHeight,
    required this.bottomBarColorWhenToolPanelShown,
    required this.bottomBarColorWhenToolPanelHidden,
    required this.showInitialLoadingOverlay,
    required this.initialLoadingText,
  });

  final bool hideAssistantFab;
  final bool showHeader;
  final PointerDownEventListener onGlobalPointerDown;
  final Animation<double> contentFade;
  final String headerTitle;
  final Widget headerBody;
  final Widget messagesContent;
  final Widget? attachmentSection;
  final Widget composer;
  final bool showToolPanel;
  final Widget toolPanel;
  final double bottomInsetHeight;
  final Color bottomBarColorWhenToolPanelShown;
  final Color bottomBarColorWhenToolPanelHidden;
  final bool showInitialLoadingOverlay;
  final String initialLoadingText;

  @override
  Widget build(BuildContext context) {
    final body = AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: CustomScaffold(
        resizeToAvoidBottomInset: true,
        body: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: onGlobalPointerDown,
          child: SafeAreaTopOnly(
            child: Stack(
              children: [
                FadeTransition(
                  opacity: contentFade,
                  child: Column(
                    children: [
                      if (showHeader)
                        CustomAppHeader(
                          title: headerTitle,
                          body: headerBody,
                          hasLeftAction: true,
                          color: AC.white,
                        ),
                      Expanded(child: messagesContent),
                      if (attachmentSection != null) attachmentSection!,
                      composer,
                      AnimatedSize(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        alignment: Alignment.topCenter,
                        child: showToolPanel
                            ? toolPanel
                            : const SizedBox.shrink(),
                      ),
                      Container(
                        color: showToolPanel
                            ? bottomBarColorWhenToolPanelShown
                            : bottomBarColorWhenToolPanelHidden,
                        height: bottomInsetHeight,
                      ),
                    ],
                  ),
                ),
                if (showInitialLoadingOverlay)
                  Center(
                    child: Text(
                      initialLoadingText,
                      style: TextStyle(
                        fontSize: SC.sf(14),
                        color: AC.neutralLoadingText,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    return hideAssistantFab ? AssistantVisibilityScope.hide(child: body) : body;
  }
}
