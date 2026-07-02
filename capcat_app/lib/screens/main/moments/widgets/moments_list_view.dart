import 'package:flutter/material.dart';
import 'package:capcat_doca/models/moment.dart';
import 'package:capcat_doca/theme/app_colors.dart';
import 'package:capcat_doca/utils/size_config.dart';
import 'package:capcat_doca/widgets/button/tap_effect.dart';
import 'package:capcat_doca/widgets/loading/text_loading_indicator.dart';
import 'package:capcat_doca/screens/main/moments/widgets/moment_card.dart';
import 'package:capcat_doca/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MomentsListView extends StatelessWidget {
  const MomentsListView({
    super.key,
    required this.momentsAsync,
    required this.onRefresh,
    required this.onCreateMoment,
    required this.onEditMoment,
    required this.onDeleteMoment,
    this.userAvatar,
    this.enablePullToRefresh = true,
  });

  final AsyncValue<List<Moment>> momentsAsync;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onCreateMoment;
  final Future<void> Function(Moment) onEditMoment;
  final Future<void> Function(Moment) onDeleteMoment;
  final String? userAvatar;
  final bool enablePullToRefresh;

  @override
  Widget build(BuildContext context) {
    return momentsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextLoadingIndicator(text: 'Đang tải khoảnh khắc...'),
      ),
      error: (err, _) => Center(
        child: Padding(
          padding: EdgeInsets.all(SC.sw(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tải khoảnh khắc thất bại'),
              SizedBox(height: SC.sh(8)),
              TapEffect(
                onTap: onRefresh,
                child: Text(
                  'Thử lại',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    fontSize: SC.sf(14),
                    color: AppColors.greenStrong1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (moments) {
        final itemCount = moments.length + 1; // composer + moments
        final list = ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            0,
            SC.sh(16),
            0,
            SC.sh(SC.desBotBarHeight + SC.desBotBarVp + 8),
          ),
          itemBuilder: (_, index) {
            if (index == 0) {
              return _ComposerRow(
                userAvatar: userAvatar,
                onCreateMoment: onCreateMoment,
              );
            }
            final moment = moments[index - 1];
            return MomentCard(
              moment: moment,
              onEdit: () => onEditMoment(moment),
              onDelete: () => onDeleteMoment(moment),
            );
          },
          separatorBuilder: (_, __) => SizedBox(height: SC.sh(16)),
          itemCount: itemCount,
        );
        if (!enablePullToRefresh) return list;
        return RefreshIndicator(
          color: AppColors.greenStrong1,
          backgroundColor: AppColors.white,
          onRefresh: onRefresh,
          child: list,
        );
      },
    );
  }
}

class _ComposerRow extends StatelessWidget {
  const _ComposerRow({this.userAvatar, required this.onCreateMoment});

  final String? userAvatar;
  final Future<void> Function() onCreateMoment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SC.sw(16)),
      child: TapEffect(
        // behavior: HitTestBehavior.opaque,
        effect: TapEffectType.opacity,
        onTap: onCreateMoment,
        child: Container(
          width: double.infinity,
          // height: SC.sh(72),
          padding: EdgeInsets.all(SC.smin(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AC.greyCheckbox),
            borderRadius: BorderRadius.circular(SC.smin(16)),
          ),
          child: Row(
            children: [
              userAvatar != null && userAvatar!.isNotEmpty
                  ? Container(
                      width: SC.smin(33),
                      height: SC.smin(33),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AC.amberMomentAccent,
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: CircleCachedNetworkImage(
                          imageUrl: userAvatar!,
                          size: SC.smin(32),
                          subject: ImageSubject.person,
                        ),
                      ),
                    )
                  : Container(
                      width: SC.smin(33),
                      height: SC.smin(33),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AC.amberMomentAccent,
                          width: 1,
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/pet-placeholder.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              SizedBox(width: SC.sw(10)),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Đăng một kỷ niệm mới...',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w400,
                          fontSize: SC.sf(14),
                          color: AC.neutralPrimaryText,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SC.sw(60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/moment-camera.png',
                            width: SC.smin(24),
                            height: SC.smin(24),
                            fit: BoxFit.contain,
                          ),
                          Image.asset(
                            'assets/icons/moment-picture.png',
                            width: SC.smin(24),
                            height: SC.smin(24),
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
