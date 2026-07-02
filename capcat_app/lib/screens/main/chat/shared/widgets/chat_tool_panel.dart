import 'package:flutter/material.dart';
import 'package:capcat_doca/l10n/gen/app_localizations.dart';
import 'package:capcat_doca/screens/main/chat/shared/models/chat_view_contracts.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';

class ChatToolPanel extends StatelessWidget {
  const ChatToolPanel({
    super.key,
    required this.actions,
    required this.l10n,
    this.showAdvancedTools = true,
  });

  final ChatToolPanelActions actions;
  final AppLocalizations l10n;
  final bool showAdvancedTools;

  @override
  Widget build(BuildContext context) {
    final options = <_ToolButtonData>[
      _ToolButtonData(
        title: l10n.chatNewSendImages,
        icon: Image.asset('assets/icons/chat-tool-send-images.png'),
        onTap: actions.onSendImage,
      ),
      if (showAdvancedTools) ...[
        _ToolButtonData(
          title: l10n.chatNewToolNumerology,
          icon: Image.asset('assets/icons/chat-tool-than-so-hoc.png'),
          onTap: actions.onTapNumerology,
        ),
        _ToolButtonData(
          title: l10n.chatNewToolZodiac,
          icon: Image.asset('assets/icons/chat-tool-mat-ngu-chom-sao.png'),
          captionMaxLines: 2,
          onTap: actions.onTapConstellation,
        ),
        _ToolButtonData(
          title: l10n.chatNewToolCaption,
          icon: Image.asset('assets/icons/chat-tool-caption-hay-viral.png'),
          captionMaxLines: 2,
          onTap: actions.onTapCreateContent,
        ),
        _ToolButtonData(
          title: l10n.chatNewToolDiary,
          icon: Image.asset('assets/icons/chat-tool-viet-nhat-ky.png'),
        ),
        _ToolButtonData(
          title: l10n.chatNewToolOilPainting,
          icon: Image.asset('assets/icons/chat-tool-ve-tranh-son-dau.png'),
          comingSoon: true,
          comingSoonLabel: l10n.chatNewToolComingSoon,
        ),
        _ToolButtonData(
          title: l10n.chatNewToolStudio,
          icon: Image.asset('assets/icons/chat-tool-chup-studio.png'),
          comingSoon: true,
          comingSoonLabel: l10n.chatNewToolComingSoon,
        ),
        _ToolButtonData(
          title: l10n.chatNewToolCompose,
          icon: Image.asset('assets/icons/chat-tool-sang-tac.png'),
          comingSoon: true,
          comingSoonLabel: l10n.chatNewToolComingSoon,
        ),
      ],
    ];

    return Container(
      width: double.infinity,
      color: AC.yellowToolPanel,
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(16)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: SC.sw(12),
          mainAxisSpacing: SC.sh(16),
          childAspectRatio: 0.75,
        ),
        itemBuilder: (_, index) => _ChatToolButton(data: options[index]),
      ),
    );
  }
}

class _ToolButtonData {
  final String title;
  final Widget icon;
  final VoidCallback? onTap;
  final bool comingSoon;
  final int captionMaxLines;
  final String? comingSoonLabel;

  const _ToolButtonData({
    required this.title,
    required this.icon,
    this.onTap,
    this.comingSoon = false,
    this.captionMaxLines = 1,
    this.comingSoonLabel,
  });

  bool get isEnabled => onTap != null && !comingSoon;

  Color get captionColor => comingSoon ? AC.greyText4 : AC.blackText6;
}

class _ChatToolButton extends StatelessWidget {
  const _ChatToolButton({required this.data});

  final _ToolButtonData data;

  @override
  Widget build(BuildContext context) {
    final badge = Positioned(
      left: SC.sw(-8),
      right: SC.sw(-8),
      bottom: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: SC.sw(6),
            vertical: SC.sh(2),
          ),
          decoration: BoxDecoration(
            color: AC.redValidationText,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            data.comingSoonLabel ?? '',
            style: TextStyle(fontSize: SC.sf(8), color: Colors.white),
          ),
        ),
      ),
    );

    final button = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: SC.smin(52),
              height: SC.smin(52),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: data.icon,
              ),
            ),
            if (data.comingSoon) badge,
          ],
        ),
        SizedBox(height: SC.sh(6)),
        SizedBox(
          width: SC.sw(68),
          height: data.captionMaxLines > 1 ? SC.sh(32) : SC.sh(16),
          child: Text(
            data.title,
            textAlign: TextAlign.center,
            maxLines: data.captionMaxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              fontSize: SC.sf(10),
              color: data.captionColor,
            ),
          ),
        ),
      ],
    );

    return TapEffect(onTap: data.isEnabled ? data.onTap : null, child: button);
  }
}
