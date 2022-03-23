import 'package:flutter/material.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/utils_box/size_fit.dart';

/// 用于收缩展开的容器
class ExpandContainer extends StatefulWidget {
  final double shrinkHeight;
  final double expandHeight;
  final Widget title;
  final Widget content;

  const ExpandContainer({
    Key? key,
    required this.shrinkHeight,
    required this.expandHeight,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  _ExpandContainerState createState() => _ExpandContainerState();
}

class _ExpandContainerState extends State<ExpandContainer> with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> _notifier = ValueNotifier(false);

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );
  late final Animation<double> _animation = Tween(
    begin: widget.shrinkHeight,
    end: widget.expandHeight,
  ).animate(_controller)
    ..addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          _notifier.value = true;
          break;
        case AnimationStatus.dismissed:
          _notifier.value = false;
          break;
        default:
      }
    });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery mediaQuery = MediaQuery.removePadding(
      removeTop: true,
      removeBottom: true,
      context: context,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding36),
        child: widget.content,
      ),
    );
    Widget builder = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: _animation.value,
          child: mediaQuery,
        );
      },
    );
    Column column = Column(
      children: [
        widget.title,
        builder,
        ValueListenableBuilder<bool>(
          valueListenable: _notifier,
          builder: (context, value, child) {
            return _buildToggle(value);
          },
        ),
      ],
    );
    return column;
  }

  Widget _buildToggle(bool isExpand) {
    Widget text = Text(
      isExpand ? l10n(context).showLess : l10n(context).showMore,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
          ),
    );
    Widget icon = Icon(
      isExpand ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
      color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
    );
    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [text, icon],
    );
    GestureDetector detector = GestureDetector(
      child: row,
      onTap: () {
        _animation.value == widget.shrinkHeight ? _controller.forward() : _controller.reverse();
      },
    );
    return SizedBox(height: 100.px, child: detector);
  }
}
