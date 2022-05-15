import 'dart:ui';

var _sizeFit = SizeFit();

/// 尺寸适配
class SizeFit {
  late double _ratio;
  late double _ratiopx;

  /// design: 设计稿的物理宽度
  SizeFit({double design = 750}) {
    double physicalWidth = window.physicalSize.width; // 屏幕宽度的物理像素
    _ratio = window.devicePixelRatio;
    double ratioWidth = physicalWidth / _ratio; // 算出屏幕宽度的逻辑像素
    _ratiopx = ratioWidth / design; // 算出宽度 逻辑像素 和 物理像素 的比率，以便算出指定物理尺寸的逻辑尺寸
  }

  double getRatiopx(double px) => _ratiopx * px; // 算出的 逻辑像素
  double getPx(double ratioPX) => _ratio * ratioPX; // 算出的 物理像素
}

extension DoubleFit on double {
  double get px => _sizeFit.getRatiopx(this);
  double get rpx => _sizeFit.getPx(this);
}

extension IntFit on int {
  double get px => _sizeFit.getRatiopx(toDouble());
  double get rpx => _sizeFit.getPx(toDouble());
}

final Rect clipRect = Rect.fromLTWH(
  0,
  0,
  window.physicalSize.width,
  window.physicalSize.height,
);

double logicWidth = window.physicalSize.width / window.devicePixelRatio;
double logicHeight = window.physicalSize.height / window.devicePixelRatio;

double padding6 = 6.px;
double padding12 = 12.px;
double padding18 = 18.px;
double padding24 = 24.px;
double padding30 = 30.px;
double padding36 = 36.px;
double padding42 = 42.px;
double padding48 = 48.px;
