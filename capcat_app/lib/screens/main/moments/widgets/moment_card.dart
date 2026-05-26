import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/config/moment_ui_config.dart';
import 'package:flutter_chat_mock_app/models/moment.dart';
import 'package:flutter_chat_mock_app/models/moment_type.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/date_format_config.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/tap_effect.dart';
import 'package:flutter_chat_mock_app/widgets/image/circle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/image/rectangle_cached_network_image.dart';
import 'package:flutter_chat_mock_app/widgets/viewer/full_screen_gallery_viewer.dart';

class MomentCard extends StatelessWidget {
  const MomentCard({
    super.key,
    required this.moment,
    this.momentType = MomentType.emotion,
    this.onEdit,
    this.onDelete,
  });

  final Moment moment;
  final MomentType momentType;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final meta = MomentUiConfig.enableMomentType
        ? (momentTypeMeta[momentType] ?? momentTypeMeta[MomentType.emotion]!)
        : MomentTypeMeta(icon: '', title: '', fallbackIcon: Icons.circle);
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: SC.sw(12)),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...[_TimelineIndicator(meta: meta), SizedBox(width: SC.sw(4))],
              Expanded(
                child: _MomentBody(
                  moment: moment,
                  meta: meta,
                  onEdit: onEdit,
                  onDelete: onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  const _TimelineIndicator({required this.meta});

  final MomentTypeMeta meta;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: SC.smin(24),
          height: SC.smin(24),
          decoration: const BoxDecoration(
            // color: AC.redSoftBg,
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.zero,
            child: Image.asset(
              meta.icon,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                meta.fallbackIcon,
                color: AC.greyBorder2,
                size: SC.smin(8),
              ),
            ),
          ),
        ),
        SizedBox(height: SC.sh(4)),
        Expanded(
          child: Container(width: SC.smin(1), color: AC.greyBorder2),
        ),
      ],
    );
  }
}

class _MomentBody extends StatelessWidget {
  const _MomentBody({
    required this.moment,
    required this.meta,
    this.onEdit,
    this.onDelete,
  });

  final Moment moment;
  final MomentTypeMeta? meta;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderRow(
          createdAt: moment.createdAt,
          meta: meta,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
        SizedBox(height: SC.sh(8)),
        if (moment.media.isNotEmpty) ...[
          _MediaList(moment: moment),
          SizedBox(height: SC.sh(8)),
        ],
        if (moment.caption.isNotEmpty) _Caption(text: moment.caption),
        if (moment.caption.isNotEmpty && moment.pets.isNotEmpty)
          SizedBox(height: SC.sh(8)),
        if (moment.pets.isNotEmpty) ...[_SharedWithRow(moment: moment)],
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.createdAt,
    this.meta,
    this.onEdit,
    this.onDelete,
  });

  final DateTime createdAt;
  final MomentTypeMeta? meta;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormatConfig.formatMomentCreatedAt(createdAt);
    final hasMeta = meta != null && meta!.title.isNotEmpty;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateLabel,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: SC.sf(12),
                color: AC.neutralPrimaryText,
              ),
            ),
            if (hasMeta)
              if (hasMeta)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SC.sw(8),
                    vertical: SC.sh(4),
                  ),
                  decoration: BoxDecoration(
                    color: AC.redSoftBg,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    meta!.title,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w500,
                      fontSize: SC.sf(10),
                      color: AC.redMomentAccent,
                    ),
                  ),
                ),
          ],
        ),
        _OverflowMenu(onEdit: onEdit, onDelete: onDelete),
      ],
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: AC.white,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit?.call();
        } else if (value == 'delete') {
          onDelete?.call();
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
        PopupMenuItem(
          value: 'delete',
          child: Text('Xóa', style: TextStyle(color: AC.redDeleteAction)),
        ),
      ],
      child: Container(
        margin: EdgeInsets.only(left: SC.sw(8)),
        width: SC.sw(36),
        height: SC.sh(20),
        padding: EdgeInsets.symmetric(
          horizontal: SC.sw(12),
          vertical: SC.sh(4),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AC.greyCheckbox),
        ),
        child: Center(
          child: Icon(
            Icons.more_horiz,
            size: SC.smin(12),
            color: AC.neutralPrimaryText,
          ),
        ),
      ),
    );
  }
}

class _MediaList extends StatelessWidget {
  const _MediaList({required this.moment});

  final Moment moment;

  @override
  Widget build(BuildContext context) {
    final imageUrls = moment.media.map((m) => m.url).toList();

    return SizedBox(
      height: SC.sh(110),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: moment.media.length,
        separatorBuilder: (_, __) => SizedBox(width: SC.sw(10)),
        itemBuilder: (_, index) {
          final media = moment.media[index];
          final width = index == 0 ? SC.sw(120) : SC.sw(100);
          final height = SC.sh(100);
          return TapEffect(
            effect: TapEffectType.none,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FullScreenGalleryViewer(
                    imageUrls: imageUrls,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RectangleCachedNetworkImage(
                imageUrl: media.url,
                width: width,
                height: height,
                fit: BoxFit.cover,
                radius: 10,
                subject: ImageSubject.others,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w400,
        fontSize: SC.sf(12),
        color: AC.blackText6,
      ),
    );
  }
}

class _SharedWithRow extends StatelessWidget {
  const _SharedWithRow({required this.moment});

  final Moment moment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SC.sw(8), vertical: SC.sh(6)),
      decoration: BoxDecoration(
        color: AC.greyBorder2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/moment-shared-with.png',
                width: SC.smin(16),
                height: SC.smin(16),
                fit: BoxFit.contain,
              ),
              SizedBox(width: SC.sw(6)),
              Text(
                'Cùng với',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w400,
                  fontSize: SC.sf(12),
                  color: AC.blackText6,
                ),
              ),
            ],
          ),
          const Spacer(),
          _PetAvatars(moment: moment),
        ],
      ),
    );
  }
}

class _PetAvatars extends StatelessWidget {
  const _PetAvatars({required this.moment});

  final Moment moment;

  @override
  Widget build(BuildContext context) {
    const baseSize = 24.0;
    final overlap = SC.smin(20);
    final displayPets = moment.pets.take(2).toList();
    final hasExtra = moment.pets.length > displayPets.length;
    final totalItems = displayPets.length + (hasExtra ? 1 : 0);
    final totalWidth = totalItems > 0
        ? SC.smin(baseSize) + overlap * (totalItems - 1)
        : SC.smin(baseSize);

    return SizedBox(
      height: SC.smin(baseSize),
      width: totalWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (hasExtra)
            Positioned(
              left: overlap * displayPets.length,
              child: Container(
                width: SC.smin(baseSize),
                height: SC.smin(baseSize),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AC.greyBox2,
                ),
                alignment: Alignment.center,
                child: Text(
                  '+${moment.pets.length - displayPets.length}',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: SC.sf(10),
                    color: AC.blackText6,
                  ),
                ),
              ),
            ),
          for (int i = displayPets.length - 1; i >= 0; i--)
            if (displayPets[i].avatar != null &&
                displayPets[i].avatar!.isNotEmpty)
              Positioned(
                left: overlap * i,
                child: CircleCachedNetworkImage(
                  imageUrl: displayPets[i].avatar!,
                  size: SC.smin(baseSize),
                  subject: ImageSubject.pet,
                ),
              ),
        ],
      ),
    );
  }
}
