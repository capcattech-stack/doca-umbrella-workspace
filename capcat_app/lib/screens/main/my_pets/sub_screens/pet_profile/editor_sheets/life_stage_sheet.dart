import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/theme/app_colors.dart';
import 'package:flutter_chat_mock_app/utils/size_config.dart';
import 'package:flutter_chat_mock_app/widgets/button/action_button.dart';
import 'package:flutter_chat_mock_app/widgets/sheets/custom_action_sheet_container.dart';

class LifeStageSheet extends StatelessWidget {
  const LifeStageSheet({
    super.key,
    required this.stageLabel,
    required this.greenInfoText,
    required this.shortDescription,
    required this.bullets,
    required this.careTips,
    required this.healthWatch,
    required this.onClose,
  });

  final String stageLabel;
  final String greenInfoText;
  final String shortDescription;
  final List<String> bullets;
  final List<String> careTips;
  final List<String> healthWatch;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return CustomActionSheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Main Card
          SizedBox(
            width: double.infinity,
            // height: SC.sh(160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: SC.sh(116),
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/life-stage-background.jpg',
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(SC.smin(16)),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: SC.sw(24),
                        top: SC.sh(16),
                        bottom: 0,
                        child: IgnorePointer(
                          child: Image.asset(
                            'assets/images/life-stage-art-cat-3.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          SC.sw(16),
                          SC.sh(16),
                          SC.sw(16),
                          SC.sh(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Giai đoạn',
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w500,
                                fontSize: SC.sf(14),
                                height: 18 / 14,
                                color: AC.greyText4,
                              ),
                            ),
                            SizedBox(height: SC.sh(8)),
                            Text(
                              stageLabel,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                fontSize: SC.sf(24),
                                height: 1,
                                color: AC.blackText6,
                              ),
                            ),
                            SizedBox(height: SC.sh(8)),
                            Text(
                              greenInfoText,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                fontSize: SC.sf(12),
                                height: 15 / 12,
                                color: AC.greenSelectedAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SC.sh(10)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: SC.sw(12),
                    vertical: SC.sh(8),
                  ),
                  decoration: BoxDecoration(
                    color: AC.greenSoftTint,
                    borderRadius: BorderRadius.circular(SC.smin(14)),
                  ),
                  child: Text(
                    shortDescription,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      fontSize: SC.sf(11),
                      height: 18 / 11,
                      color: AC.brownCardBodyText,
                    ),
                  ),
                ),
                SizedBox(height: SC.sh(16)),
                _LifeStageCardsCarousel(
                  bullets: bullets,
                  careTips: careTips,
                  healthWatch: healthWatch,
                ),
                SizedBox(height: SC.sh(16)),
                const _LifeStageStaticTipBanner(),
              ],
            ),
          ),
          SizedBox(height: SC.sh(16)),
          ActionButton(text: 'Đã hiểu', onTap: onClose),
          SizedBox(height: SC.sh(16)),
        ],
      ),
    );
  }
}

class _LifeStageStaticTipBanner extends StatelessWidget {
  const _LifeStageStaticTipBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SC.sh(69.25),
      padding: EdgeInsets.symmetric(horizontal: SC.sw(12)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AC.greenMediumTint, AC.greenAltTint],
        ),
        borderRadius: BorderRadius.circular(SC.smin(14)),
      ),
      child: Row(
        children: [
          Container(
            width: SC.smin(32),
            height: SC.smin(32),
            decoration: BoxDecoration(
              color: AC.greenText1,
              borderRadius: BorderRadius.circular(SC.smin(10)),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.favorite_border_rounded,
              size: SC.smin(14),
              color: Colors.white,
            ),
          ),
          SizedBox(width: SC.sw(10)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mỗi bé sẽ có một hành trình riêng!',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    fontSize: SC.sf(10),
                    height: 15 / 10,
                    color: AC.greenText1,
                  ),
                ),
                SizedBox(height: SC.sh(1)),
                Text(
                  'Các mốc chỉ mang tính tham khảo. Hãy quan sát bé và điều chỉnh phù hợp.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w400,
                    fontSize: SC.sf(9),
                    height: 15 / 9,
                    color: AC.brownCardCaption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LifeStageCardsCarousel extends StatefulWidget {
  const _LifeStageCardsCarousel({
    required this.bullets,
    required this.careTips,
    required this.healthWatch,
  });

  final List<String> bullets;
  final List<String> careTips;
  final List<String> healthWatch;

  @override
  State<_LifeStageCardsCarousel> createState() =>
      _LifeStageCardsCarouselState();
}

class _LifeStageCardsCarouselState extends State<_LifeStageCardsCarousel> {
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onIndicatorTap(int index) {
    if (index < 0) return;
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardSpecs = <_LifeStageCardSpec>[
      _LifeStageCardSpec(
        items: widget.bullets,
        accentColor: AC.purpleTipAccent,
        iconBackgroundColor: AC.purpleTipIconBg,
        iconData: Icons.info_outline,
        subtitle: 'BẠN ĐÃ BIẾT CHƯA?',
        title: 'Đặc điểm nổi bật',
      ),
      _LifeStageCardSpec(
        items: widget.careTips,
        accentColor: AC.greenText1,
        iconBackgroundColor: AC.greenCareIconBg,
        iconData: Icons.lightbulb_outline,
        subtitle: 'CHỦ NÊN LÀM GÌ?',
        title: 'Mẹo chăm sóc',
      ),
      _LifeStageCardSpec(
        items: widget.healthWatch,
        accentColor: AC.redHealthAccent,
        iconBackgroundColor: AC.redHealthIconBg,
        iconData: Icons.warning_amber_rounded,
        subtitle: 'DẤU HIỆU SỨC KHỎE',
        title: 'Các lưu ý cần biết',
      ),
    ];
    final cards = cardSpecs
        .map((spec) => _LifeStageInfoCard(spec: spec))
        .toList(growable: false);
    final cardsLength = cards.length;
    final canGoPrev = _currentIndex > 0;
    final canGoNext = _currentIndex < cardsLength - 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tips cho sen',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: SC.sf(13),
                  height: 20 / 13,
                  color: AC.brownCardHeading,
                ),
              ),
            ),
            SizedBox(width: SC.sw(8)),
            Row(
              children: [
                _CarouselNavButton(
                  icon: Icons.chevron_left_rounded,
                  enabled: canGoPrev,
                  onTap: () => _onIndicatorTap(_currentIndex - 1),
                ),
                SizedBox(width: SC.sw(4)),
                _CarouselNavButton(
                  icon: Icons.chevron_right_rounded,
                  enabled: canGoNext,
                  onTap: () => _onIndicatorTap(_currentIndex + 1),
                ),
              ],
            ),
          ],
        ),
        // SizedBox(height: SC.sh(8)),
        SizedBox(
          height: SC.sh(206),
          child: PageView.builder(
            controller: _controller,
            clipBehavior: Clip.none,
            itemCount: cards.length,
            onPageChanged: (index) {
              if (!mounted) return;
              setState(() => _currentIndex = index);
            },
            itemBuilder: (_, index) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SC.sw(4),
                vertical: SC.sh(8),
              ),
              child: cards[index],
            ),
          ),
        ),
        SizedBox(height: SC.sh(8)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(cards.length, (index) {
            final isActive = index == _currentIndex;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _onIndicatorTap(index),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: SC.sw(3)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: isActive ? SC.sw(18) : SC.sw(6),
                  height: SC.sh(6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AC.greenText1
                        : AC.beigePagerDot,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _CarouselNavButton extends StatelessWidget {
  const _CarouselNavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: Container(
        width: SC.smin(24),
        height: SC.smin(24),
        decoration: BoxDecoration(
          color: enabled ? AC.greenGhostBg : AC.beigeNavDisabledBg,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: SC.smin(12),
          color: enabled ? AC.greenText1 : AC.beigePagerDot,
        ),
      ),
    );
  }
}

class _LifeStageCardSpec {
  const _LifeStageCardSpec({
    required this.items,
    required this.accentColor,
    required this.iconBackgroundColor,
    required this.iconData,
    required this.subtitle,
    required this.title,
  });

  final List<String> items;
  final Color accentColor;
  final Color iconBackgroundColor;
  final IconData iconData;
  final String subtitle;
  final String title;
}

class _LifeStageInfoCard extends StatelessWidget {
  const _LifeStageInfoCard({required this.spec});

  final _LifeStageCardSpec spec;

  @override
  Widget build(BuildContext context) {
    final displayItems = spec.items.take(4).toList();

    return Container(
      width: double.infinity,
      height: SC.sh(188),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SC.smin(18)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -SC.sw(10),
            top: -SC.sh(10),
            child: Transform.rotate(
              angle: -0.45,
              child: Icon(
                Icons.pets_rounded,
                size: SC.smin(40),
                color: spec.accentColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -SC.sw(8),
            bottom: SC.sh(16),
            child: Transform.rotate(
              angle: 0.25,
              child: Icon(
                Icons.pets_rounded,
                size: SC.smin(28),
                color: spec.accentColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(SC.sw(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: SC.smin(36),
                      height: SC.smin(36),
                      decoration: BoxDecoration(
                        color: spec.iconBackgroundColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        spec.iconData,
                        size: SC.smin(14),
                        color: spec.accentColor,
                      ),
                    ),
                    SizedBox(width: SC.sw(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spec.subtitle,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w500,
                            fontSize: SC.sf(10),
                            height: 14 / 10,
                            letterSpacing: 0.45,
                            color: spec.accentColor,
                          ),
                        ),
                        SizedBox(height: SC.sh(2)),
                        Text(
                          spec.title,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                            fontSize: SC.sf(14),
                            height: 18 / 14,
                            color: AC.brownCardHeading,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: SC.sh(12)),
                Expanded(
                  child: Column(
                    children: [
                      for (int i = 0; i < displayItems.length; i++) ...[
                        _BulletRow(
                          index: i + 1,
                          text: displayItems[i],
                          accentColor: spec.accentColor,
                        ),
                        if (i < displayItems.length - 1)
                          SizedBox(height: SC.sh(8)),
                      ],
                      if (displayItems.isEmpty)
                        _BulletRow(
                          index: 1,
                          text: '--',
                          accentColor: spec.accentColor,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({
    required this.index,
    required this.text,
    this.accentColor = AC.purpleTipAccent,
  });

  final int index;
  final String text;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: SC.smin(20),
          height: SC.smin(20),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.082),
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
              fontSize: SC.sf(8),
              height: 12 / 8,
              color: accentColor,
            ),
          ),
        ),
        SizedBox(width: SC.sw(10)),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w500,
              fontSize: SC.sf(12),
              height: 18 / 12,
              color: AC.brownCardBodyText,
            ),
          ),
        ),
      ],
    );
  }
}
