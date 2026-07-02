import 'package:flutter/material.dart';
import 'package:capcat_doca/screens/main/chat/shared/message_actions/chat_message_action.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/sheets/custom_action_sheet_container.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<void> showChatMessageActionsSheet(
  BuildContext context, {
  required List<ChatMessageAction> actions,
  Offset? anchor,
}) async {
  if (actions.isEmpty) return;

  final overlayRenderObject = Overlay.of(context).context.findRenderObject();
  final overlayBox = overlayRenderObject is RenderBox
      ? overlayRenderObject
      : null;

  if (anchor != null && overlayBox != null) {
    final selectedId = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        anchor.dx,
        anchor.dy,
        overlayBox.size.width - anchor.dx,
        overlayBox.size.height - anchor.dy,
      ),
      color: AC.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      items: actions
          .map(
            (action) => PopupMenuItem<String>(
              value: action.id,
              child: _ActionTileContent(action: action),
            ),
          )
          .toList(growable: false),
    );

    if (selectedId == null) return;
    for (final action in actions) {
      if (action.id == selectedId) {
        await action.onSelected();
        return;
      }
    }
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return CustomActionSheetContainer(
        showHandle: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: actions
              .map(
                (action) => _ActionTile(
                  action: action,
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await action.onSelected();
                  },
                ),
              )
              .toList(growable: false),
        ),
      );
    },
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.onTap});

  final ChatMessageAction action;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        child: _ActionTileContent(action: action),
      ),
    );
  }
}

class _ActionTileContent extends StatelessWidget {
  const _ActionTileContent({required this.action});

  final ChatMessageAction action;

  @override
  Widget build(BuildContext context) {
    final isPinIcon =
        action.iconAssetPath.endsWith('/pin.svg') ||
        action.iconAssetPath.endsWith('/unpin.svg');
    final color = isPinIcon
        ? AC.blackPure
        : action.isDestructive
        ? AC.redDeleteAction
        : AC.blackText6;
    return Row(
      children: [
        SvgPicture.asset(
          action.iconAssetPath,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            action.label,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
