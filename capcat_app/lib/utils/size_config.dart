import 'dart:math';
import 'package:flutter/widgets.dart';

class SizeConfig {
  //--
  static late MediaQueryData _mq;

  //--Device's width, height, safe area height
  static late double physicScreenWidth;
  static late double physicScreenHeight;

  //--Device's top, bottom padding & safe area
  static double get physicPaddingTop => _mq.padding.top;
  static double get physicPaddingBottom => _mq.padding.bottom;
  static late double physicSafeHeight;

  //--
  static late double scaleWidthRatio;
  static late double scaleHeightRatio;
  static late double _scaleTextRatio;

  // design reference
  static const double designScreenWidth = 375.0;
  static const double designScreenHeight = 812.0;
  static const double designSafeHeight = designScreenHeight - 44.0 - 34.0;

  // static const double designBotNavBarWidth = 272.0;
  static const double desBotBarWidth = 220.0;
  static const double desBotBarHeight = 64.0;
  static const double desBotBarVp = 16.0;

  // optional clamps
  static const double minTextScale = 0.85;
  static const double maxTextScale = 1.25;
  static const double minScale = 0.6;
  static const double maxScale = 2.0;

  /// Call once per screen (or in app builder)
  static void init(
    BuildContext context, {
    double designW = designScreenWidth,
    double designH = designScreenHeight,
  }) {
    _mq = MediaQuery.of(context);
    physicScreenWidth = _mq.size.width;
    physicScreenHeight = _mq.size.height;

    // Use viewPadding so keyboard insets (viewInsets) won't change scale ratios.
    physicSafeHeight =
        physicScreenHeight - _mq.viewPadding.top - _mq.viewPadding.bottom;

    scaleWidthRatio = (physicScreenWidth / designW).clamp(minScale, maxScale);
    // use safe heights for vertical scaling
    scaleHeightRatio = (physicSafeHeight / designSafeHeight).clamp(
      minScale,
      maxScale,
    );

    // text scale: choose conservative ratio
    _scaleTextRatio = min(
      scaleWidthRatio,
      scaleHeightRatio,
    ).clamp(minTextScale, maxTextScale);
  }

  static double phyBotBarWidth =
      desBotBarWidth * min(scaleWidthRatio, scaleHeightRatio);
  static double phyBotBarHeight =
      desBotBarHeight * min(scaleWidthRatio, scaleHeightRatio);
  static double phyBotBarVp = desBotBarVp * scaleHeightRatio;

  static double sw(double px) => px * scaleWidthRatio;
  static double sh(double px) => px * scaleHeightRatio;
  static double smin(double px) => px * min(scaleWidthRatio, scaleHeightRatio);
  static double smax(double px) => px * max(scaleWidthRatio, scaleHeightRatio);

  static double sf(double px) => px * _scaleTextRatio;

  static double pw(double percent) => physicScreenWidth * percent;
  static double ph(double percent) => physicSafeHeight * percent;
}

typedef SC = SizeConfig;
