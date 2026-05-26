import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/l10n/gen/app_localizations.dart';
import 'package:flutter_chat_mock_app/models/chat_welcome.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/image/rectangle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/loading/text_loading_indicator.dart';

class ChatMessagesLoadingState extends StatelessWidget {
  const ChatMessagesLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return TextLoadingIndicator(
      text: AppLocalizations.of(context)!.chatNewLoadingMessages,
    );
  }
}

class ChatMessagesErrorState extends StatelessWidget {
  const ChatMessagesErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SC.sw(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.chatNewLoadMessagesError(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SC.sf(14),
                color: AC.neutralLoadingText,
              ),
            ),
            SizedBox(height: SC.sh(12)),
            TapEffect(
              onTap: () {
                onRetry();
              },
              child: Text(
                l10n.chatNewRetry,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SC.sf(14),
                  color: AppColors.greenStrong1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatWelcomeState extends StatelessWidget {
  const ChatWelcomeState({
    super.key,
    required this.onRefreshMessages,
    required this.onRetryWelcome,
    required this.welcomeContent,
    required this.isLoadingWelcome,
    required this.errorMessage,
    required this.onSuggestionTap,
    required this.l10n,
  });

  final Future<void> Function() onRefreshMessages;
  final VoidCallback onRetryWelcome;
  final ChatWelcomeContent? welcomeContent;
  final bool isLoadingWelcome;
  final String? errorMessage;
  final ValueChanged<String> onSuggestionTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (isLoadingWelcome) {
      body = SizedBox(
        height: SC.sh(200),
        child: Center(
          child: Text(
            l10n.chatNewSuggestionLoading,
            style: TextStyle(fontSize: SC.sf(14), color: AC.neutralLoadingText),
          ),
        ),
      );
    } else if (welcomeContent != null) {
      body = ChatWelcomeCard(
        content: welcomeContent!,
        onSuggestionTap: onSuggestionTap,
      );
    } else {
      body = ChatWelcomeError(
        message: errorMessage ?? l10n.chatNewSuggestionError,
        onRetry: onRetryWelcome,
        l10n: l10n,
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16), vertical: SC.sh(24)),
      children: [
        body,
        SizedBox(height: SC.sh(12)),
      ],
    );
  }
}

class ChatWelcomeCard extends StatelessWidget {
  const ChatWelcomeCard({
    super.key,
    required this.content,
    required this.onSuggestionTap,
  });

  final ChatWelcomeContent content;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        RectangleCachedNetworkImage(
          imageUrl: content.imageUrl,
          width: double.infinity,
          height: SC.sh(228),
          radius: 16,
          subject: ImageSubject.others,
        ),
        SizedBox(height: SC.sh(32)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: SC.smin(20),
              color: AppColors.greenStrong1,
            ),
            SizedBox(width: SC.sw(8)),
            Expanded(
              child: Text(
                content.title,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(16),
                  color: AC.deepPurpleOverlay70,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SC.sh(16)),
        if (content.suggestions.isNotEmpty)
          Wrap(
            spacing: SC.sw(12),
            runSpacing: SC.sh(12),
            children: content.suggestions
                .map(
                  (text) => ChatWelcomeSuggestionChip(
                    label: text,
                    onTap: () => onSuggestionTap(text),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class ChatWelcomeSuggestionChip extends StatelessWidget {
  const ChatWelcomeSuggestionChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(16),
          vertical: SC.sh(8),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greenStrong1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w500,
            fontSize: SC.sf(14),
            color: AC.deepPurpleOverlay70,
          ),
        ),
      ),
    );
  }
}

class ChatWelcomeError extends StatelessWidget {
  const ChatWelcomeError({
    super.key,
    required this.message,
    required this.onRetry,
    required this.l10n,
  });

  final String message;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: SC.sf(15), color: AC.neutralLoadingText),
        ),
        SizedBox(height: SC.sh(12)),
        TapEffect(
          onTap: onRetry,
          child: Text(
            l10n.commonRetry,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: SC.sf(14),
              color: AppColors.greenStrong1,
            ),
          ),
        ),
      ],
    );
  }
}
