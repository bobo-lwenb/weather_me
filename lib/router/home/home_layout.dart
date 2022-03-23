import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/router/home/home_widgets/banner_widget.dart';
import 'package:weather_me/router/home/home_widgets/refresh_banner.dart';
import 'package:weather_me/router/home/home_widgets/top_banner.dart';
import 'package:weather_me/utils_box/style.dart';
import 'package:weather_me/utils_box/utils_image.dart';
import 'package:weather_me/utils_box/weather/weather_container.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/size_fit.dart';

class HomeLayout extends ConsumerStatefulWidget {
  final Widget appBar;
  final Widget icons;
  final Widget background;
  final Widget floatBanner;
  final List<Widget> slivers;
  final VoidCallback? refreshCallback;

  const HomeLayout({
    Key? key,
    required this.appBar,
    required this.icons,
    required this.background,
    required this.floatBanner,
    required this.slivers,
    this.refreshCallback,
  })  : assert(slivers.length >= 2),
        super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> with WeatherController {
  /// 控制背景透明度
  late final ValueNotifier<double> _opacityNotifier = ValueNotifier(0);

  /// 控制第一个banner的高度
  late final ValueNotifier<List<double>> _heightsNotifier = ValueNotifier(List.empty(growable: true));

  /// 控制刷新动画的位置
  final ValueNotifier<double> _refreshNotifier = ValueNotifier(0);

  late final ScrollController _scrollController = ScrollController();
  late final List<GlobalKey> _globalKeys = List.empty(growable: true);

  /// 第一个card缩小时的高度
  double smallSize = 0.px;

  /// 第一个card需要多展开的高度
  double biggerSize = 0.px;

  /// 吸顶滑动需要移动的距离
  late double _scrollDistance;

  /// 右侧icon列表的顶部位置
  late final _iconListTop =
      MediaQueryData.fromWindow(window).padding.top + kToolbarHeight - IconTheme.of(context).size! - 28.px;

  /// 右侧icon列表的宽度
  late final _iconListWidth = IconTheme.of(context).size!;

  /// appbar的高度
  final double _appbarHeight = MediaQueryData.fromWindow(window).padding.top + kToolbarHeight;

  /// 记录手指按下位置
  late double _downY;

  /// 是否吸顶
  bool _isTop = false;

  /// 吸顶后是否已经继续向上滑动
  bool _isOverTop = false;

  /// 手指是否抬起
  bool _isTouch = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // 判断吸顶时是fling还是手指的滑动
      _isOverTop = _scrollController.offset > _scrollDistance;
      if (_isTop && !_isOverTop && !_isTouch) _scrollToTop();

      // 更新透明度系数
      bool upBuonds = _scrollController.offset > _scrollDistance;
      bool downBounds = _scrollController.offset < 0;
      if (upBuonds || downBounds) return;
      double opacity = _scrollController.offset / _scrollDistance;
      _opacityNotifier.value = opacity;
      // 控制天气背景的播放
      if (opacity == 1) {
        togglePlay(ref, false);
      } else if (opacity == 0) {
        togglePlay(ref, true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _opacityNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 在页面渲染完成后，用于确定第一个banner的高度
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      List<double> list = List.empty(growable: true);
      for (var globalKey in _globalKeys) {
        if (globalKey.currentContext == null) continue;
        list.add(globalKey.currentContext!.size!.height);
      }
      _heightsNotifier.value = list;
    });
    ref.listen<bool>(isRefreshProvider, (previous, next) {
      if (next) {
        // 用于处理定位刷新的情况
        _refreshNotifier.value = 160.px;
      } else {
        if (_isTouch) return; // 如果是手指滑动过程中的动画则不复位
        _refreshNotifier.value = 0; // 当刷新停止时复位刷新条
      }
    });
    ValueListenableBuilder builder = ValueListenableBuilder<double>(
      valueListenable: _opacityNotifier,
      builder: (context, opacity, child) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(child: widget.background),
            Positioned.fill(child: _buildMaskLayer(opacity)),
            Positioned(
              child: ValueListenableBuilder<List<double>>(
                valueListenable: _heightsNotifier,
                builder: (context, list, child) => _getScrollView(opacity, list),
              ),
            ),
            _getAppBar(opacity),
            _geticonList(opacity),
            ValueListenableBuilder<double>(
              valueListenable: _refreshNotifier,
              builder: (context, value, child) => RefreshBanner(distance: value),
            ),
          ],
        );
      },
    );
    return Scaffold(body: builder);
  }

  Widget _buildMaskLayer(double opacity) {
    return Offstage(
      offstage: opacity == 0,
      child: Opacity(
        opacity: opacity,
        child: Container(color: backgroundColor(context)),
      ),
    );
  }

  Widget _getScrollView(double ratio, List<double> listHeight) {
    // 用于更新一些高度和滑动距离的数据
    if (listHeight.isNotEmpty) {
      smallSize = listHeight[0] + listHeight[1] + padding24;
      biggerSize = listHeight[2];

      _scrollDistance = window.physicalSize.height / window.devicePixelRatio -
          MediaQueryData.fromWindow(window).padding.top -
          kToolbarHeight -
          smallSize;
    }
    List<Widget> listWidgets = List.empty(growable: true);
    // 头部banner展开后显示的组件
    List<Widget> listHide = List.empty(growable: true);
    for (var child in widget.slivers) {
      // 处理第一个组件的透明度
      if (widget.slivers.indexOf(child) == 0) {
        Opacity opacity = Opacity(
          opacity: 1 - ratio,
          child: child,
        );
        child = opacity;
      }
      // 将前三个组件放入第一个banner中处理，进行收缩伸展处理
      if (widget.slivers.indexOf(child) <= 2) {
        GlobalKey globalKey = GlobalKey();
        KeyedSubtree subtree = KeyedSubtree(key: globalKey, child: child);
        _globalKeys.add(globalKey);
        listHide.add(subtree);

        if (widget.slivers.indexOf(child) == 2) {
          TopBanner topBanner = TopBanner(
            height: smallSize + ratio * biggerSize,
            children: listHide,
          );
          listWidgets.add(topBanner);
        }
        continue;
      }
      BannerWidget bannerWidget = BannerWidget(child: child);
      listWidgets.add(bannerWidget);
    }
    // 往头部插入一个空白的 container 用做占位
    Stack stack = Stack(
      alignment: Alignment.center,
      children: [
        _getFloatBanner(ratio),
        _getTouchBar(ratio),
      ],
    );
    SizedBox sizedBox = SizedBox(
      height: window.physicalSize.height / window.devicePixelRatio - smallSize,
      child: stack,
    );
    SliverToBoxAdapter adapter = SliverToBoxAdapter(child: sizedBox);
    listWidgets.insert(0, adapter);
    Widget hfLogo = Container(
      margin: EdgeInsets.only(top: padding6),
      child: isDark(context) ? logoLight : logoDark,
    );
    listWidgets.add(SliverToBoxAdapter(child: hfLogo)); // 数据logo
    listWidgets.add(SliverToBoxAdapter(child: SizedBox(height: padding48))); // 用于底部的占位空白

    Widget scrollView = CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      slivers: listWidgets,
    );
    Listener listener = Listener(
      onPointerDown: (event) {
        _downY = event.position.dy;
        _isTouch = true;
      },
      onPointerMove: (event) {
        // 判断是否进行开启下来刷新钱的过渡动画
        if (!_isTop && event.position.dy - _downY > 0) {
          _refreshNotifier.value = (event.position.dy - _downY) * 0.5;
          // 超过触发距离但未松手，也开始动画，但此时未触发刷新回调
          if (event.position.dy - _downY >= refreshDistance) {
            ref.read(isRefreshProvider.notifier).state = true;
          } else {
            ref.read(isRefreshProvider.notifier).state = false;
          }
        }
      },
      onPointerUp: (event) {
        _howToScroll(event);
        _isTouch = false;

        if (_scrollController.offset > 0) return;
        double downDistance = event.position.dy - _downY;
        // 手指抬起时判断是否出发下拉刷新
        if (!_isTop && downDistance > padding12) {
          // 如果下滑距离超过_refreshDistance则出发下拉刷新，否则就复位
          if (downDistance >= refreshDistance) {
            if (widget.refreshCallback != null) widget.refreshCallback!();
          } else {
            _refreshNotifier.value = 0;
          }
        }
      },
      onPointerCancel: (event) {
        _isTouch = false;
      },
      child: scrollView,
    );
    return listener;
  }

  Widget _geticonList(double opacity) {
    Widget positioned = Positioned(
      top: _iconListTop,
      right: padding24 - opacity * (padding24 + _iconListWidth),
      child: Offstage(
        offstage: opacity == 1,
        child: Opacity(
          opacity: 1 - opacity,
          child: widget.icons,
        ),
      ),
    );
    return positioned;
  }

  Widget _getFloatBanner(double value) {
    Opacity opacity = Opacity(opacity: 1 - value, child: widget.floatBanner);
    Positioned positioned = Positioned(
      left: padding24,
      bottom: 0,
      child: opacity,
    );
    return positioned;
  }

  Widget _getTouchBar(double value) {
    Container container = Container(
      width: 120.px,
      height: 10.px,
      decoration: const BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
    );
    return Positioned(
      bottom: 0,
      child: container,
    );
  }

  Widget _getAppBar(double opacity) {
    Container container = Container(
      height: _appbarHeight,
      color: whiteSmoke,
      child: widget.appBar,
    );
    return Positioned(
      top: -_appbarHeight * (1 - opacity),
      left: 0,
      right: 0,
      child: Offstage(
        offstage: opacity == 0,
        child: Opacity(
          opacity: opacity,
          child: container,
        ),
      ),
    );
  }

  /// 判断手指抬起时列表如何滑动
  void _howToScroll(PointerUpEvent event) {
    // 手指按下抬起的距离
    double distance = event.position.dy - _downY;
    if (_isTop) {
      // 下面两个if判断的是吸顶时的滑动行为
      if (distance.abs().px > 100.px && !_isOverTop && distance > 0) {
        _scrollToBottom();
      } else if (distance.abs().px < 100.px && !_isOverTop && distance > 0) {
        _scrollToTop();
      }
      return;
    }
    // 判断的是未吸顶时的滑动行为
    if (distance < 0 && distance.abs().px > 100.px) {
      _scrollToTop();
    } else {
      _scrollToBottom();
    }
  }

  /// 滚动到顶部
  void _scrollToTop() {
    _scrollController.animateTo(
      _scrollDistance,
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
    );
    _isTop = true;
  }

  /// 滚动到底部
  void _scrollToBottom() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
    );
    _isTop = false;
  }
}
