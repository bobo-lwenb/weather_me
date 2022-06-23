import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';

/// 下拉刷新的过程动画
class RefreshBanner extends ConsumerStatefulWidget {
  final double distance;

  const RefreshBanner({
    Key? key,
    required this.distance,
  }) : super(key: key);

  @override
  ConsumerState<RefreshBanner> createState() => _RefreshBannerState();
}

/// 触发下拉刷新需要下拉的距离
final double refreshDistance = 350.px;

/// 刷新条的宽度
final double refreshWidth = 120.px;

/// 刷新条的高度
final double refreshHeight = 40.px;

class _RefreshBannerState extends ConsumerState<RefreshBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    lowerBound: 0,
    upperBound: 9,
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  /// 刷新条固定时距离顶部的位置
  final double _fixedPosition = 120.px;

  /// 刷新条需要移动的距离
  late final double _refreshMoveDist = _fixedPosition + refreshHeight;

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(isRefreshProvider, (previous, next) {
      next ? refreshStart() : refreshEnd();
    });
    Widget builder = AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: RefreshPainter(
            process: _controller.value,
            isRefresh: ref.read(isRefreshProvider.notifier).state,
          ),
          isComplex: true,
        );
      },
    );
    bool isFixed = widget.distance >= _refreshMoveDist;
    Widget positioned = AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      top: isFixed ? _fixedPosition : -refreshHeight + widget.distance,
      child: SizedBox(
        width: refreshWidth,
        height: refreshHeight,
        child: builder,
      ),
    );
    return positioned;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void refreshStart() {
    _controller.repeat();
  }

  void refreshEnd() {
    _controller.stop();
    _controller.reset();
  }
}

class RefreshPainter extends CustomPainter {
  final double process;
  final bool isRefresh;

  RefreshPainter({
    required this.process,
    required this.isRefresh,
  });

  late final Paint _paint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 4.px
    ..style = PaintingStyle.fill;

  final List<Color> _listColor = [Colors.limeAccent, Colors.white, tomato];

  @override
  void paint(Canvas canvas, Size size) {
    // 每一格的宽度
    double cellWidthSize = size.width / 6;
    // 每一格的高度
    double cellHeightSize = size.height / 3;
    // 需要缩放的色块
    int scaleIndex = (process % 3) ~/ 1;

    Path path = Path();
    double left = 0;
    for (int i = 0; i < 3; i++) {
      canvas.save();
      // 对需要缩放的色块进行缩放
      if (i == scaleIndex && isRefresh) {
        canvas.translate(
          left + cellWidthSize * 2 / 2,
          (cellHeightSize * 3) / 2,
        );
        canvas.scale(1.3);
        canvas.translate(
          -(left + cellWidthSize * 2 / 2),
          -(cellHeightSize * 3) / 2,
        );
      }
      // 绘制色块
      _paint.color = _listColor[i];
      path.reset();
      path
        ..moveTo(left, cellHeightSize * 3)
        ..lineTo(left + cellWidthSize, 0)
        ..lineTo(left + cellWidthSize * 2, 0)
        ..lineTo(left + cellWidthSize, cellHeightSize * 3)
        ..close();
      canvas.drawPath(path, _paint);
      left += cellWidthSize * 2;
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant RefreshPainter oldDelegate) {
    return oldDelegate.process != process;
  }
}

/// 是否刷新
final isRefreshProvider = StateProvider<bool>((ref) {
  return false;
});
