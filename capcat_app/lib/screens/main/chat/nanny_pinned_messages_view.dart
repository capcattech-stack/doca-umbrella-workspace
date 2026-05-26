import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/message.dart';
import 'package:flutter_chat_mock_app/providers/nanny_chat_provider.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/shared/search/chat_search_text_matcher.dart';
import 'package:flutter_chat_mock_app/screens/main/chat/shared/widgets/chat_search_field.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/date_format_config.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/search_debouncer.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/loading/text_loading_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NannyPinnedMessagesView extends ConsumerStatefulWidget {
  const NannyPinnedMessagesView({super.key, this.onTapMessage});

  final ValueChanged<Message>? onTapMessage;

  @override
  ConsumerState<NannyPinnedMessagesView> createState() =>
      _NannyPinnedMessagesViewState();
}

class _NannyPinnedMessagesViewState
    extends ConsumerState<NannyPinnedMessagesView> {
  final TextEditingController _searchController = TextEditingController();
  final SearchDebouncer _searchDebouncer = SearchDebouncer();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchDebouncer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinnedMessagesAsync = ref.watch(nannyPinnedMessagesProvider);
    final pinnedMessages = pinnedMessagesAsync.valueOrNull ?? const <Message>[];
    final filtered = filterPinnedMessagesByQuery(pinnedMessages, _searchQuery);

    return Container(
      color: AC.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SC.sw(16),
              vertical: SC.sh(4),
            ),
            child: SizedBox(
              height: SC.sh(48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Tin nhắn đã ghim',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        fontSize: SC.sf(20),
                        height: 24 / 20,
                        color: AC.blackText6,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Giúp bảo mẫu lên kế hoạch chăm sóc bé.',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w400,
                        fontSize: SC.sf(12),
                        height: 16 / 12,
                        color: AC.greyText4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: SC.sh(8)),
          ChatSearchField(
            controller: _searchController,
            onChanged: (value) {
              _searchDebouncer.run(() {
                if (!mounted) return;
                setState(() => _searchQuery = value);
              });
            },
          ),
          SizedBox(height: SC.sh(8)),
          Expanded(
            child: pinnedMessagesAsync.when(
              loading: () => const Center(
                child: TextLoadingIndicator(
                  text: 'Đang tải tin nhắn đã ghim...',
                ),
              ),
              error: (error, _) => _PinnedMessagesErrorState(
                message: error.toString(),
                onRetry: () => ref.invalidate(nannyPinnedMessagesProvider),
              ),
              data: (_) {
                if (filtered.isEmpty) {
                  return const _PinnedMessagesEmptyState();
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: SC.sw(12),
                    vertical: SC.sh(8),
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, index) => _PinnedMessageRow(
                    message: filtered[index],
                    onTap: () => widget.onTapMessage?.call(filtered[index]),
                  ),
                );
              },
            ),
          ),
          Container(color: AC.white, height: SC.sh(MQ.bottomPadding(context))),
        ],
      ),
    );
  }
}

List<Message> filterPinnedMessagesByQuery(
  List<Message> messages,
  String query,
) {
  final normalized = normalizeChatSearchText(query);
  if (normalized.isEmpty) return messages;
  return messages
      .where((message) {
        return chatSearchContains(source: message.text, query: query);
      })
      .toList(growable: false);
}

class _PinnedMessageRow extends StatelessWidget {
  const _PinnedMessageRow({required this.message, this.onTap});

  final Message message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = message.text.trim().isNotEmpty
        ? message.text.trim()
        : '[Tin nhắn đã ghim]';
    final relativeTime = DateFormatConfig.formatMomentCreatedAt(
      message.timestamp,
    );

    return TapEffect(
      onTap: onTap,
      child: SizedBox(
        height: SC.sh(50),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w600,
                      fontSize: SC.sf(16),
                      height: 22 / 16,
                      letterSpacing: -0.4,
                      color: AC.blackPure,
                    ),
                  ),
                  SizedBox(height: SC.sh(2)),
                  Text(
                    relativeTime,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w400,
                      fontSize: SC.sf(14),
                      height: 20 / 14,
                      letterSpacing: -0.15,
                      color: AC.neutralChatSubtext,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: SC.sw(8)),
            SvgPicture.asset(
              'assets/icons/pin.svg',
              width: SC.sw(20),
              height: SC.sh(20),
              colorFilter: const ColorFilter.mode(
                AC.greenText1,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinnedMessagesEmptyState extends StatelessWidget {
  const _PinnedMessagesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Chưa có tin nhắn đã ghim',
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w500,
          fontSize: SC.sf(14),
          color: AC.neutralLoadingText,
        ),
      ),
    );
  }
}

class _PinnedMessagesErrorState extends StatelessWidget {
  const _PinnedMessagesErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SC.sw(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w500,
                fontSize: SC.sf(13),
                color: AC.redDeleteAction,
              ),
            ),
            SizedBox(height: SC.sh(12)),
            TextButton(
              onPressed: onRetry,
              child: const Text(
                'Thử lại',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  color: AC.greenText1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
