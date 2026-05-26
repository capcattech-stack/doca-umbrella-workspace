import 'package:flutter/widgets.dart';

class MediaQueryUtils {
  static double bottomPadding(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;
}

typedef MQ = MediaQueryUtils;
