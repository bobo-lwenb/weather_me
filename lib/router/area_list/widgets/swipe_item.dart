import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/area_list/widgets/swipe_provider.dart';
import 'package:weather_me/utils_box/callback/call_back.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';

/// 接收三个Offset数据作为参数的callback
typedef PositionOffsetCallback = void Function(Offset global, Offset local, Offset delta);

/// 接收一个Offset、int数据作为参数的callback
typedef SingleOffsetCallback = void Function(Offset global, int position);

/// 可编辑、排序的item
class SwipeItem extends ConsumerStatefulWidget {
  final Widget icon;

  /// 是否是固定模式，不响应编辑删除操作
  final bool isFix;

  /// 是否参与排序
  final bool joinSort;
  final int index;

  /// 对外暴露的组件
  final Widget child;

  /// 选择回调
  final IntCallback? selectCallback;

  /// 删除回调
  final IntCallback? removeCallback;

  /// 收藏回调
  final IntCallback? favoriteCallback;

  /// 排序开始时的回调
  final SingleOffsetCallback? sortStartCallback;

  /// 排序进行时的回调
  final PositionOffsetCallback? sortUpdateCallback;

  /// 排序结束时的回调
  final VoidCallback? sortEndCallback;

  const SwipeItem({
    Key? key,
    required this.icon,
    this.isFix = false,
    this.joinSort = true,
    required this.index,
    required this.child,
    this.selectCallback,
    this.removeCallback,
    this.favoriteCallback,
    this.sortStartCallback,
    this.sortUpdateCallback,
    this.sortEndCallback,
  }) : super(key: key);

  @override
  ItemSwipeState createState() => ItemSwipeState();
}

/// item的高度
final double itemSwipeHeight = 150.px;

class ItemSwipeState extends ConsumerState<SwipeItem> {
  /// 删除文本的宽度
  late double _deleteWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _deleteWidth = _globalKey.currentContext!.size!.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(editModeProvider, (oldValue, newValue) {
      if (widget.isFix) return;
      _notifierEdit.value = newValue ? 0.px : 100.px;
    });
    ref.listen<int>(waitRemoveProvider, (oldIndex, newIndex) {
      if (widget.isFix) return;
      // 如果下标和自身线标不一致，说明有其他item进入等待删除模式，则复位
      if (newIndex != widget.index) _notifierFore.value = 0.px;
    });

    Widget foreground = _buildForeground();
    return Container(
      margin: EdgeInsets.symmetric(vertical: padding12),
      height: itemSwipeHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: _buildBackground(foreground),
    );
  }

  /// 滑动删除移动的距离
  late final ValueNotifier<double> _notifierFore = ValueNotifier(0.px);

  /// 滑动删除中显示删除操作的距离
  final double _showRemoveDistance = 150.px;

  /// 滑动删除中直接删除的距离
  final double _removeDistance = 350.px;

  /// 构建前景
  Widget _buildForeground() {
    Widget fore = Container(
      decoration: BoxDecoration(
        color: containerBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: padding36),
          Expanded(child: widget.child),
          SizedBox(width: padding24),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.fromLTRB(padding24, padding24, 0, padding24),
              child: widget.icon,
            ),
            onTap: () {
              if (ref.read(editModeProvider.notifier).state) return;
              if (widget.favoriteCallback != null) widget.favoriteCallback!(widget.index);
            },
          ),
          SizedBox(width: padding36),
        ],
      ),
    );

    Widget container = GestureDetector(
      child: fore,
      onTap: () {
        if (ref.read(editModeProvider.notifier).state) {
          _notifierFore.value = 0.px;
          ref.read(waitRemoveProvider.notifier).reset();
        } else if (ref.read(waitRemoveProvider.notifier).isWaitRemove()) {
          return;
        } else {
          if (widget.selectCallback != null) widget.selectCallback!(widget.index);
        }
      },
      onPanUpdate: (details) {
        if (widget.isFix || ref.read(editModeProvider.notifier).state) return;
        ref.read(waitRemoveProvider.notifier).update(widget.index);
        _notifierFore.value += -details.delta.dx;
      },
      onPanEnd: (details) {
        if (widget.isFix) return;
        if (_notifierFore.value < _showRemoveDistance) {
          _notifierFore.value = 0.px;
          ref.read(waitRemoveProvider.notifier).reset();
        } else if (_notifierFore.value >= _showRemoveDistance && _notifierFore.value < _removeDistance) {
          _notifierFore.value = _deleteWidth;
        } else if (_notifierFore.value >= _removeDistance) {
          _removeItem();
        }
      },
    );
    ValueListenableBuilder builder = ValueListenableBuilder<double>(
      valueListenable: _notifierFore,
      child: container,
      builder: (context, value, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          top: 0,
          bottom: 0,
          left: -value,
          right: value,
          child: container,
        );
      },
    );
    return Stack(children: [builder]);
  }

  /// 执行删除操作
  void _removeItem() {
    ref.read(waitRemoveProvider.notifier).reset();
    _notifierFore.value = logicWidth;
    Future.delayed(
      const Duration(milliseconds: 170),
      () {
        if (widget.removeCallback != null) widget.removeCallback!(widget.index);
        _notifierFore.value = 0.px;
      },
    );
  }

  /// 显示编辑操作需要移动的距离
  final ValueNotifier<double> _notifierEdit = ValueNotifier(100.px);

  /// 记录上次滑动到的位置
  Offset _offset = Offset.zero;

  /// 用于唯一表示删除文本
  final GlobalKey _globalKey = GlobalKey();

  /// 构建背景的操作层
  Widget _buildBackground(Widget foreground) {
    // 左侧的删除图标
    Widget deleteIcon = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(padding24),
        child: const Icon(Icons.remove_circle_rounded, color: Colors.red),
      ),
      onTap: () {
        _removeItem();
      },
    );
    // 右侧的排序图标
    Widget sort = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(padding24),
        child: const Icon(Icons.format_line_spacing_rounded, color: Colors.blueGrey),
      ),
      onLongPressStart: (details) {
        _offset = details.localPosition;
        if (widget.sortStartCallback != null) {
          widget.sortStartCallback!(details.globalPosition, widget.index);
        }
      },
      onLongPressMoveUpdate: (details) {
        Offset offset = Offset(0, details.localPosition.dy) - _offset;
        _offset = details.localPosition; // 更新记录上次滑动到的位置
        if (widget.sortUpdateCallback != null) {
          widget.sortUpdateCallback!(
            details.globalPosition,
            details.localPosition,
            offset,
          );
        }
      },
      onLongPressEnd: (details) {
        if (widget.sortEndCallback != null) widget.sortEndCallback!();
      },
    );
    // 背部的删除布局
    Widget removeText = Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _removeItem(),
        child: Padding(
          key: _globalKey,
          padding: EdgeInsets.all(padding24),
          child: Text(l10n(context).delete, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );

    ValueListenableBuilder builder = ValueListenableBuilder<double>(
      valueListenable: _notifierEdit,
      child: foreground,
      builder: (context, value, child) {
        Stack stack = Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: 0,
              bottom: 0,
              left: -value,
              width: 100.px,
              child: deleteIcon,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: 2.px,
              bottom: 2.px,
              left: 100.px - value + 2.px,
              right: 100.px - value + 2.px,
              child: removeText,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: 0,
              bottom: 0,
              left: 100.px - value,
              right: widget.joinSort ? 100.px - value : 0,
              child: child!,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: 0,
              bottom: 0,
              right: widget.joinSort ? -value : -100.px,
              width: 100.px,
              child: sort,
            ),
          ],
        );
        return stack;
      },
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: builder,
    );
  }
}
