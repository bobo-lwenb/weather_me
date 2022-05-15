import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/router/area_list/area_content.dart';
import 'package:weather_me/router/area_list/model/all_area.dart';
import 'package:weather_me/router/area_list/provider_area.dart';
import 'package:weather_me/router/area_list/widgets/swipe_item.dart';
import 'package:weather_me/router/area_list/widgets/swipe_provider.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 可编辑、排序的item的管理容器
class SwipeContainer extends ConsumerStatefulWidget {
  final AreaLiveWeather nearMe;
  final List<AreaLiveWeather> favorite;
  final List<AreaLiveWeather> recently;

  const SwipeContainer({
    Key? key,
    required this.nearMe,
    required this.favorite,
    required this.recently,
  }) : super(key: key);

  @override
  SwipeContainerState createState() => SwipeContainerState();
}

class SwipeContainerState extends ConsumerState<SwipeContainer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _buildNearMe(),
        _buildFavorite(),
        _buildRecently(),
        SizedBox(height: 180.px),
      ],
    );
  }

  /// 构建当前位置部分
  Widget _buildNearMe() {
    Widget title = Padding(
      padding: EdgeInsets.only(left: padding36, top: padding24, bottom: padding12),
      child: Text(l10n(context).currentLocation),
    );

    Widget item = AreaContent(info: widget.nearMe);
    // 计算在整个列表中的位置
    int index = 1;
    SwipeItem itemSwipe = SwipeItem(
      icon: const Icon(Icons.near_me_rounded, color: Colors.blueGrey),
      isFix: true,
      index: index,
      child: item,
      selectCallback: (index) {
        ref.read(adCodeProvider.notifier).state = widget.nearMe.city.id;
        AppRouterDelegate.of(context).popRoute();
      },
    );

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [title, itemSwipe],
    );
    return column;
  }

  /// 构建关注地区的部分
  Widget _buildFavorite() {
    if (widget.favorite.isEmpty && widget.recently.isEmpty) return const SizedBox();
    Widget title = Padding(
      padding: EdgeInsets.only(left: padding36, top: padding24, bottom: padding12),
      child: Text(l10n(context).areasConcern),
    );
    Widget edit = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 首先判断是否有item处于等待删除模式
        if (ref.read(waitRemoveProvider.notifier).isWaitRemove()) {
          ref.read(waitRemoveProvider.notifier).reset();
          return;
        }
        ref.read(editModeProvider.notifier).update((state) => !state);
      },
      child: Padding(
        padding: EdgeInsets.only(right: padding36, left: padding36, top: padding24, bottom: padding12),
        child: Consumer(builder: (context, ref, child) {
          return Text(
            ref.watch(editModeProvider) ? l10n(context).done : l10n(context).edit,
            style: const TextStyle(color: Colors.blueAccent),
          );
        }),
      ),
    );
    Row row = Row(children: [title, const Expanded(child: SizedBox()), edit]);

    Widget stack = _buildSortList();

    List<Widget> listContent = List.empty(growable: true);
    listContent.add(row);
    listContent.add(stack);
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listContent,
    );
    return column;
  }

  final GlobalKey _globalStack = GlobalKey();

  /// 控制状态刷新时是否有动画
  bool _isAnimatable = true;

  /// 记录长按排序开始时的item的真实位置
  late int _realPosition;

  /// 记录长按排序开始时容器早y轴的偏移量
  late double _containerOffsetY;

  /// 构建可排序列表
  Widget _buildSortList() {
    // 控制各个AnimatedPositioned的top属性
    List<ValueNotifier> listNotifier = List.empty(growable: true);
    // 每个item的高度
    double eachHeight = itemSwipeHeight + padding24;
    // 可排序部分的总高度
    double totalHeight = widget.favorite.length * eachHeight;
    List<Widget> listSort = List.empty(growable: true);
    if (widget.favorite.isNotEmpty) {
      for (int i = 0; i < widget.favorite.length; i++) {
        Widget item = AreaContent(info: widget.favorite[i]);
        // 计算在整个列表中的位置
        int index = i + 1;
        SwipeItem itemSwipe = SwipeItem(
          icon: const Icon(Icons.star_rounded),
          index: index,
          child: item,
          selectCallback: (index) {
            int realIndex = index - 1;
            ref.read(adCodeProvider.notifier).state = widget.favorite[realIndex].city.id;
            AppRouterDelegate.of(context).popRoute();
          },
          removeCallback: (index) {
            int realIndex = index - 1;
            ref.watch(removeFavoriteProvider(widget.favorite[realIndex].city.id));
            setState(() {
              widget.favorite.removeAt(realIndex);
            });
          },
          favoriteCallback: (index) {
            int realIndex = index - 1;
            String id = widget.favorite[realIndex].city.id;
            ref.watch(removeFavoriteProvider(id));
            ref.watch(addRecentlyProvider(id));
            setState(() {
              AreaLiveWeather item = widget.favorite.removeAt(realIndex);
              widget.recently.add(item);
            });
          },
          sortStartCallback: (global, position) {
            _isAnimatable = true;
            _buildOverlay(global, Offset.zero);
            _realPosition = position - 1;
            RenderBox stackBox = _globalStack.currentContext?.findRenderObject() as RenderBox;
            _containerOffsetY = stackBox.localToGlobal(Offset.zero).dy;
          },
          sortUpdateCallback: (global, local, delta) {
            _updateOverlay(global, delta);
            _updateListSort(
              listNotifier,
              global,
              totalHeight,
              eachHeight,
            );
          },
          sortEndCallback: () {
            _overlayEntry.remove();
            setState(() {
              _isAnimatable = false;
            });
          },
        );

        ValueNotifier<double> notifier = ValueNotifier(i * eachHeight);
        listNotifier.add(notifier);
        ValueListenableBuilder builder = ValueListenableBuilder<double>(
          valueListenable: notifier,
          builder: (context, value, child) {
            AnimatedPositioned positioned = AnimatedPositioned(
              duration: Duration(milliseconds: _isAnimatable ? 200 : 0),
              left: 0,
              right: 0,
              top: value,
              height: eachHeight,
              child: child!,
            );
            return positioned;
          },
          child: itemSwipe,
        );
        listSort.add(builder);
      }
    }
    Widget stack = SizedBox(
      height: totalHeight,
      child: Stack(
        key: _globalStack,
        children: listSort,
      ),
    );
    return stack;
  }

  /// 更新列表的排序
  void _updateListSort(
    List<ValueNotifier> listNotifier,
    Offset global,
    double totalHeight,
    double eachHeight,
  ) {
    double diffY = global.dy - _containerOffsetY;
    if (diffY <= 0 || diffY >= totalHeight) return;
    int sortIndex = diffY ~/ eachHeight;
    if (sortIndex == _realPosition) return;

    // 先开始做出交换动画
    ValueNotifier realNotifier = listNotifier[_realPosition];
    ValueNotifier sortNotifier = listNotifier[sortIndex];
    realNotifier.value = sortIndex * eachHeight;
    sortNotifier.value = _realPosition * eachHeight;

    // 交换ValueNotifier
    ValueNotifier tempNotifier = listNotifier[_realPosition];
    listNotifier[_realPosition] = listNotifier[sortIndex];
    listNotifier[sortIndex] = tempNotifier;

    // 交换数据源
    AreaLiveWeather tempWeather = widget.favorite[_realPosition];
    widget.favorite[_realPosition] = widget.favorite[sortIndex];
    widget.favorite[sortIndex] = tempWeather;

    // 交换下标
    int temp = _realPosition;
    _realPosition = sortIndex;
    sortIndex = temp;
  }

  /// 遮罩层实体
  late OverlayEntry _overlayEntry;

  /// 移动时的遮罩层内的组件
  late final Widget _overlayWidget = _buildOverlayWidget();

  /// 更新移动时的遮罩层
  void _updateOverlay(Offset global, Offset delta) {
    _overlayEntry.remove();
    _buildOverlay(global, delta);
  }

  /// 构建移动时的遮罩层
  void _buildOverlay(Offset global, Offset delta) {
    _overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (context) {
        return Positioned(
          left: padding24,
          right: padding24,
          top: global.dy - itemSwipeHeight / 2 + delta.dy,
          height: itemSwipeHeight,
          child: _overlayWidget,
        );
      },
    );
    Overlay.of(context)?.insert(_overlayEntry);
  }

  /// 构建移动时的指示层内的组件
  Widget _buildOverlayWidget() {
    Widget container = Container(
      height: itemSwipeHeight,
      decoration: BoxDecoration(
        color: Colors.orangeAccent[100]!.withAlpha(126),
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: padding48,
            blurStyle: BlurStyle.outer,
          )
        ],
      ),
    );
    return container;
  }

  /// 构建最近查看部分
  Widget _buildRecently() {
    if (widget.recently.isEmpty) return const SizedBox();
    Widget title = Padding(
      padding: EdgeInsets.only(left: padding36, top: padding24, bottom: padding12),
      child: Text(l10n(context).viewed),
    );
    Widget edit = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ref.watch(clearRecentlyProvider);
        setState(() {
          widget.recently.clear();
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: padding36, left: padding36, top: padding24, bottom: padding12),
        child: Text(l10n(context).clear, style: const TextStyle(color: Colors.blueAccent)),
      ),
    );
    Row row = Row(children: [title, const Expanded(child: SizedBox()), edit]);

    List<Widget> list = List.empty(growable: true);
    list.add(row);
    for (int i = 0; i < widget.recently.length; i++) {
      Widget item = AreaContent(info: widget.recently[i]);
      // 计算在整个列表中的位置
      int index = i + 1 + widget.favorite.length;
      SwipeItem itemSwipe = SwipeItem(
        icon: const Icon(Icons.star_outline_rounded),
        joinSort: false,
        index: index,
        child: item,
        selectCallback: (index) {
          int realIndex = index - 1 - widget.favorite.length;
          ref.read(adCodeProvider.notifier).state = widget.recently[realIndex].city.id;
          AppRouterDelegate.of(context).popRoute();
        },
        removeCallback: (index) {
          int realIndex = index - 1 - widget.favorite.length;
          ref.watch(removeRecentlyProvider(widget.recently[realIndex].city.id));
          setState(() {
            widget.recently.removeAt(realIndex);
          });
        },
        favoriteCallback: (index) {
          int realIndex = index - 1 - widget.favorite.length;
          String id = widget.recently[realIndex].city.id;
          ref.watch(removeRecentlyProvider(id));
          ref.watch(addFavoriteProvider(id));
          setState(() {
            AreaLiveWeather item = widget.recently.removeAt(realIndex);
            widget.favorite.add(item);
          });
        },
      );
      list.add(itemSwipe);
    }
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
    return column;
  }
}
