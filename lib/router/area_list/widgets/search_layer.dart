import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/riverpod/provider_location.dart';
import 'package:weather_me/router/area_list/model/lookup_area.dart';
import 'package:weather_me/router/area_list/provider_area.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';

/// 搜索功能的搜索层功能
class SearchLayer extends ConsumerStatefulWidget {
  final AnimationController controller;

  const SearchLayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  ConsumerState<SearchLayer> createState() => _SearchLayerState();
}

class _SearchLayerState extends ConsumerState<SearchLayer> {
  /// 输入框控制器
  late final TextEditingController _editController = TextEditingController();

  /// 焦点控制器
  late final FocusNode _focusNode = FocusNode()
    ..addListener(() {
      if (_focusNode.hasFocus) widget.controller.forward();
    });

  /// 用于控制取消/搜索按钮的文本
  final ValueNotifier<bool> _notifierCancle = ValueNotifier(true);

  /// 搜索层的高度
  final double _searchLayerHeight = logicHeight - (MediaQueryData.fromWindow(window).padding.top + kToolbarHeight);

  /// 搜索层需要移动的高度
  late final double _moveDistance = _searchLayerHeight - 180.px;

  /// 取消按钮的宽度
  final double _cancelWidth = 100.px;

  /// 搜索栏高度
  final double _boxHeight = 80.px;

  /// 搜索栏在顶部时top的距离
  final double _topDistance = padding24;

  @override
  void dispose() {
    _focusNode.unfocus();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Column column = Column(children: [
      _buildBox(),
      Expanded(child: _buildResultArea()),
    ]);

    AnimatedBuilder builder = AnimatedBuilder(
      animation: widget.controller,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding24),
        height: _searchLayerHeight,
        child: column,
      ),
      builder: (context, child) {
        return Positioned(
          left: 0,
          right: 0,
          top: _topDistance + _moveDistance * (1 - widget.controller.value),
          child: child!,
        );
      },
    );
    return builder;
  }

  /// 构建搜索结果
  Widget _buildResultArea() {
    Widget consumer = Consumer(
      builder: (context, ref, child) {
        AsyncValue<List<LookupArea>> asyncValue = ref.watch(searchCityProvider);
        List<LookupArea> list = asyncValue.when(
          data: (list) => list,
          error: (err, stack) => [],
          loading: () => [],
        );
        if (list.isEmpty) return const SizedBox();

        ListView listView = ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            LookupArea city = list[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                ref.watch(addRecentlyProvider(city.id));
                ref.read(searchStringProvider.notifier).state = '';
                ref.read(adCodeProvider.notifier).state = city.id;
                AppRouterDelegate.of(context).popRoute();
              },
              child: Padding(
                padding: EdgeInsets.all(padding12),
                child: Text(
                  "${city.name} - ${city.adm2} - ${city.adm1} - ${city.country}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        );
        return Container(
          padding: EdgeInsets.only(top: padding24),
          color: contentBackgroundColor(context),
          child: listView,
        );
      },
    );
    return consumer;
  }

  /// 构建搜索栏
  Widget _buildBox() {
    Widget builder = AnimatedBuilder(
      animation: widget.controller,
      child: SizedBox(
        height: _boxHeight,
        child: Stack(children: [
          _buildSearch(),
          _buildCancel(),
        ]),
      ),
      builder: (context, child) {
        Widget decoration = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(padding24)),
            boxShadow: widget.controller.value != 0
                ? []
                : [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: padding48 * (1 - widget.controller.value),
                      blurStyle: BlurStyle.outer,
                    )
                  ],
          ),
          child: child,
        );
        return decoration;
      },
    );
    return builder;
  }

  /// 构建取消按钮
  Widget _buildCancel() {
    Widget cancelBuilder = AnimatedBuilder(
      animation: widget.controller,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_notifierCancle.value) {
            _editController.clear();
            _focusNode.unfocus();
            widget.controller.reverse();
            ref.read(searchStringProvider.notifier).state = '';
          } else {
            _focusNode.unfocus();
            _doSearch(_editController.text);
          }
        },
        child: Container(
          alignment: Alignment.center,
          child: ValueListenableBuilder<bool>(
            valueListenable: _notifierCancle,
            builder: (context, isCancel, child) {
              String text = isCancel ? l10n(context).cancel : l10n(context).search;
              return Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueAccent),
              );
            },
          ),
        ),
      ),
      builder: (context, child) {
        return Positioned(
          width: _cancelWidth,
          right: -_cancelWidth * (1 - widget.controller.value),
          top: 0,
          bottom: 0,
          child: child!,
        );
      },
    );
    return cancelBuilder;
  }

  /// 执行地区搜索
  void _doSearch(String area) {
    if (area.isEmpty) return;
    ref.watch(searchStringProvider.notifier).state = area;
  }

  /// 构建搜索框
  Widget _buildSearch() {
    Widget searchField = TextField(
      controller: _editController,
      focusNode: _focusNode,
      maxLines: 1,
      autofocus: false,
      enabled: true,
      cursorColor: tomato,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: padding12),
        prefixIcon: const Icon(Icons.search_rounded, color: tomato),
        suffixIcon: ValueListenableBuilder<bool>(
          valueListenable: _notifierCancle,
          builder: (content, value, child) {
            return value ? const SizedBox() : child!;
          },
          child: GestureDetector(
            child: const Icon(Icons.close_rounded, color: tomato),
            onTap: () {
              _editController.clear();
              _notifierCancle.value = _editController.text.isEmpty ? true : false;
              ref.read(searchStringProvider.notifier).state = '';
            },
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
          borderSide: const BorderSide(),
        ),
      ),
      textInputAction: TextInputAction.search,
      onChanged: (text) {
        _notifierCancle.value = text.isEmpty ? true : false;
        if (text.isEmpty) ref.read(searchStringProvider.notifier).state = '';
      },
      onSubmitted: (text) {
        _doSearch(_editController.text);
      },
    );
    Widget searchBuilder = AnimatedBuilder(
      animation: widget.controller,
      child: Container(
        decoration: BoxDecoration(
          color: containerBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
        ),
        child: searchField,
      ),
      builder: (context, child) {
        Positioned positioned = Positioned(
          left: 0,
          right: _cancelWidth * widget.controller.value,
          top: 0,
          bottom: 0,
          child: child!,
        );
        return positioned;
      },
    );
    return searchBuilder;
  }
}
