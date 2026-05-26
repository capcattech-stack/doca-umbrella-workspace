import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/models/moment.dart';
import 'package:flutter_chat_mock_app/providers/moments_provider.dart';
import 'package:flutter_chat_mock_app/screens/main/moments/widgets/moment_card.dart';
import 'package:flutter_chat_mock_app/screens/main/moments/widgets/moments_list_view.dart';
import 'package:flutter_chat_mock_app/services/moment_remote_service.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/media_query_utils.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/header/custom_app_header.dart';
import 'package:flutter_chat_mock_app/widgets/layout/custom_scaffold.dart';
import 'package:flutter_chat_mock_app/widgets/loading/text_loading_indicator.dart';
import 'package:flutter_chat_mock_app/widgets/safe_area/safe_area_top_only.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/storage/user_detail_local_storage.dart';
import 'package:flutter_chat_mock_app/screens/main/moments/moment_form_screen.dart';
import 'package:flutter_chat_mock_app/utils/toast_overlay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionScreen extends ConsumerStatefulWidget {
  const EmotionScreen({super.key});

  @override
  ConsumerState<EmotionScreen> createState() => _EmotionScreenState();
}

class _EmotionScreenState extends ConsumerState<EmotionScreen> {
  String? _userAvatar;

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
  }

  Future<void> _loadUserAvatar() async {
    final user = await UserDetailLocalStorage().read();
    if (!mounted) return;
    setState(() {
      _userAvatar = user?.avatarUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final momentsAsync = ref.watch(momentsProvider);
    return CustomScaffold(
      extendBody: true,
      backgroundColor: AppColors.white,
      body: SafeAreaTopOnly(
        child: Padding(
          padding: EdgeInsets.only(bottom: MQ.bottomPadding(context)),
          child: Column(
            children: [
              const CustomAppHeader(
                title: 'Khoảnh khắc cảm xúc',
                hasLeftAction: false,
                color: AppColors.white,
              ),
              Expanded(
                child: MomentsListView(
                  momentsAsync: momentsAsync,
                  userAvatar: _userAvatar,
                  onCreateMoment: () async {
                    final created = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MomentFormScreen(
                          showMomentTypePicker: false,
                        ),
                      ),
                    );
                    if (created == true && mounted) {
                      await ref.read(momentsProvider.notifier).refresh();
                    }
                  },
                  onRefresh: () async {
                    await ref.read(momentsProvider.notifier).refresh();
                  },
                  onEditMoment: (moment) async {
                    final changed = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MomentFormScreen(
                          existingMoment: moment,
                          showMomentTypePicker: false,
                        ),
                      ),
                    );
                    if (changed == true) {
                      await ref.read(momentsProvider.notifier).refresh();
                    }
                  },
                  onDeleteMoment: (moment) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Xóa kỷ niệm?'),
                        content: const Text(
                          'Bạn có chắc muốn xóa kỷ niệm này?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Xóa'),
                          ),
                        ],
                      ),
                    );
                    if (confirm != true) return;
                    final resp = await MomentRemoteService.deleteMoment(
                      moment.id,
                    );
                    if (resp.isSuccess) {
                      await ref
                          .read(momentsProvider.notifier)
                          .deleteMoment(moment.id);
                    } else {
                      ToastOverlay.show(
                        context,
                        resp.message ?? 'Xóa kỷ niệm thất bại',
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class _ComposerRow extends StatelessWidget {
//   const _ComposerRow({this.userAvatar, this.onCreateMoment});

//   final String? userAvatar;
//   final VoidCallback? onCreateMoment;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(SC.sw(16), SC.sh(8), SC.sw(16), SC.sh(16)),
//       child: Row(
//         children: [
//           userAvatar != null && userAvatar!.isNotEmpty
//               ? Container(
//                   width: SC.smin(33),
//                   height: SC.smin(33),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: AC.amberMomentAccent,
//                       width: 1,
//                     ),
//                   ),
//                   child: ClipOval(
//                     child: CircleCachedNetworkImage(
//                       imageUrl: userAvatar!,
//                       size: SC.smin(32),
//                       subject: ImageSubject.person,
//                     ),
//                   ),
//                 )
//               : Container(
//                   width: SC.smin(33),
//                   height: SC.smin(33),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: AC.amberMomentAccent,
//                       width: 1,
//                     ),
//                     image: const DecorationImage(
//                       image: AssetImage('assets/images/pet-placeholder.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//           SizedBox(width: SC.sw(16)),
//           Expanded(
//             child: GestureDetector(
//               behavior: HitTestBehavior.opaque,
//               onTap: onCreateMoment,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Hôm nay của bạn thế nào?',
//                       style: TextStyle(
//                         fontFamily: 'Quicksand',
//                         fontWeight: FontWeight.w400,
//                         fontSize: SC.sf(14),
//                         color: AC.neutralPrimaryText,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: SC.sw(60),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Image.asset(
//                           'assets/icons/moment-camera.png',
//                           width: SC.smin(24),
//                           height: SC.smin(24),
//                           fit: BoxFit.contain,
//                         ),
//                         Image.asset(
//                           'assets/icons/moment-picture.png',
//                           width: SC.smin(24),
//                           height: SC.smin(24),
//                           fit: BoxFit.contain,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _MomentsList extends StatelessWidget {
//   const _MomentsList({
//     required this.future,
//     required this.onRefresh,
//     required this.userAvatar,
//     required this.onCreateMoment,
//   });

//   final Future<List<Moment>> future;
//   final VoidCallback onRefresh;
//   final String? userAvatar;
//   final VoidCallback onCreateMoment;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: FutureBuilder<List<Moment>>(
//         future: future,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const TextLoadingIndicator(text: "Đang tải khoảnh khắc...");
//           }
//           final moments = snapshot.data ?? [];
//           final itemCount = moments.length + 1; // composer + moments
//           return ListView.separated(
//             padding: EdgeInsets.fromLTRB(
//               0,
//               SC.sh(16),
//               0,
//               SC.sh(SC.desBotBarHeight + SC.desBotBarVp + 8),
//             ),
//             itemBuilder: (_, index) {
//               if (index == 0) {
//                 return _ComposerRow(
//                   userAvatar: userAvatar,
//                   onCreateMoment: onCreateMoment,
//                 );
//               }
//               final moment = moments[index - 1];
//               return MomentCard(
//                 moment: moment,
//                 onEdit: () async {
//                   final changed = await Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => MomentFormScreen(
//                         existingMoment: moment,
//                         showEventPicker: false,
//                       ),
//                     ),
//                   );
//                   if (changed == true) {
//                     onRefresh();
//                   }
//                 },
//                 onDelete: () async {
//                   final confirm = await showDialog<bool>(
//                     context: context,
//                     builder: (_) => AlertDialog(
//                       title: const Text('Xóa kỷ niệm?'),
//                       content: const Text('Bạn có chắc muốn xóa kỷ niệm này?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(false),
//                           child: const Text('Hủy'),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.of(context).pop(true),
//                           child: const Text('Xóa'),
//                         ),
//                       ],
//                     ),
//                   );
//                   if (confirm != true) return;
//                   final resp = await MomentRemoteService.deleteMoment(
//                     moment.id,
//                   );
//                   if (resp.isSuccess) {
//                     onRefresh();
//                   } else {
//                     ToastOverlay.show(
//                       context,
//                       resp.message ?? 'Xóa kỷ niệm thất bại',
//                     );
//                   }
//                 },
//               );
//             },
//             separatorBuilder: (_, __) => SizedBox(height: SC.sh(12)),
//             itemCount: itemCount,
//           );
//         },
//       ),
//     );
//   }
// }
