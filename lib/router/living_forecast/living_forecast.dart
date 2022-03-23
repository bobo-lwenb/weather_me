import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/router/home/cards/living_index/model/living_index.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/utils_time.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class LivingForecast extends ConsumerStatefulWidget {
  final List<LivingIndex> list;

  const LivingForecast({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  ConsumerState<LivingForecast> createState() => _LivingForecastState();
}

class _LivingForecastState extends ConsumerState<LivingForecast> {
  /// 需要显示的生活指数项目
  late final List<String> typeSelect = ['0', '1', '2', '3', '5', '6', '8', '11', '15'];

  /// 用于存放title栏的对象列表
  late final List<LivingIndex> resultTitle = _computeTitleList(widget.list);

  /// 用于存放content栏的对象列表
  late final List<List<LivingIndex>> resultContent = _computeContentList(widget.list);

  @override
  Widget build(BuildContext context) {
    int selectIndex = ref.watch(_selectItemProvider);
    Widget titleList = _buildTitleList(resultTitle, selectIndex);
    Widget explain = Text(
      livingType2Explain(context, resultTitle[selectIndex].type),
      style: _subTextStyle(),
    );
    Widget content = _buildContent(resultContent[selectIndex]);
    ListView listView = ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(height: 258.px, child: titleList),
        Padding(
          padding: EdgeInsets.all(padding24),
          child: Container(
            padding: EdgeInsets.all(padding36),
            decoration: BoxDecoration(
              color: containerBackgroundColor(context),
              borderRadius: BorderRadius.all(Radius.circular(padding24)),
            ),
            child: explain,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(padding24),
          child: content,
        ),
      ],
    );
    return listView;
  }

  Widget _buildTitleList(List<LivingIndex> list, int selectIndex) {
    ListView listView = ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        LivingIndex livingIndex = list[index];
        return TitleItem(
          index: index,
          color: selectIndex == index ? tomato : Colors.grey,
          living: livingIndex,
        );
      },
    );
    return listView;
  }

  /// 计算title栏需要展示的项目
  List<LivingIndex> _computeTitleList(List<LivingIndex> list) {
    /// 需要显示的生活指数对象
    final List<LivingIndex> result = List.empty(growable: true);
    List<String> types = typeSelect.first == '0'
        ? ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16']
        : typeSelect;
    for (var item in types) {
      int index = int.parse(item) - 1;
      result.add(list[index]);
    }
    return result;
  }

  Widget _buildContent(List<LivingIndex> list) {
    ListView listView = ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        LivingIndex livingIndex = list[index];
        return ContentItem(index: livingIndex);
      },
    );
    return listView;
  }

  /// 计算content栏需要展示的项目
  List<List<LivingIndex>> _computeContentList(List<LivingIndex> all) {
    List<List<LivingIndex>> result = List.empty(growable: true);
    List<String> types = typeSelect.first == '0'
        ? ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16']
        : typeSelect;
    for (var item in types) {
      int index = int.parse(item) - 1;
      List<LivingIndex> list = List.empty(growable: true);
      while (index < all.length) {
        list.add(all[index]);
        index += 16;
      }
      result.add(list);
    }
    return result;
  }

  TextStyle _subTextStyle() => Theme.of(context).textTheme.bodyText2!.copyWith(
        color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
      );
}

/// 保存title栏选中项的provider
final _selectItemProvider = StateProvider.autoDispose<int>((ref) => 0);

/// title栏列表的item的高度
final double _itemHeight = 258.px;

/// title栏列表的item
class TitleItem extends ConsumerWidget {
  final int index;
  final Color color;
  final LivingIndex living;

  const TitleItem({
    Key? key,
    required this.index,
    required this.color,
    required this.living,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget icon = Icon(
      livingType2IconData(living.type),
      size: 80.px,
      color: color,
    );
    Widget text = Text(
      livingType2Short(context, living.type),
      style: TextStyle(fontSize: 30.px, color: color),
    );
    Widget item = SizedBox(
      height: _itemHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, SizedBox(height: padding36), text],
      ),
    );
    GestureDetector detector = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding36),
        child: item,
      ),
      onTap: () => ref.read(_selectItemProvider.notifier).state = index,
    );
    return detector;
  }
}

/// content栏列表的item
class ContentItem extends StatelessWidget {
  final LivingIndex index;

  ContentItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  late final GlobalKey _globalKey = GlobalKey();
  late final ValueNotifier<double> _notifier = ValueNotifier(0.px);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      double bottomLineHeight =
          _globalKey.currentContext!.size!.height - padding36 - padding6 - 42.px - 30.px - padding24 * 2;
      _notifier.value = bottomLineHeight;
    });
    // 左侧的时间
    Widget lineTop = Container(
      width: 6.px,
      height: padding36,
      decoration: BoxDecoration(
        color: livingLevel2Color(index.type, index.level),
        borderRadius: BorderRadius.all(Radius.circular(padding6)),
      ),
    );
    Widget week = Text(weekTime(context, index.date),
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: 30.px,
            ));
    Widget date = Text(dateTime(context, index.date), style: _subStyle(context));
    Widget lineBottom = ValueListenableBuilder<double>(
      valueListenable: _notifier,
      builder: (context, value, child) {
        Widget container = Container(
          width: 6.px,
          height: value,
          decoration: BoxDecoration(
            color: livingLevel2Color(index.type, index.level),
            borderRadius: BorderRadius.all(Radius.circular(padding6)),
          ),
        );
        return container;
      },
    );
    Widget column1 = Padding(
      padding: EdgeInsets.only(left: padding36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(left: padding48), child: lineTop),
          week,
          date,
          Padding(padding: EdgeInsets.only(left: padding48), child: lineBottom),
        ],
      ),
    );

    // 右侧的文本
    Widget category = Container(
      padding: EdgeInsets.symmetric(horizontal: padding24, vertical: padding6),
      decoration: BoxDecoration(
        color: livingLevel2Color(index.type, index.level),
        borderRadius: BorderRadius.all(Radius.circular(padding12)),
      ),
      child: Text(index.category, style: const TextStyle(color: whiteSmoke)),
    );
    Widget text = Text(index.text, style: _subStyle(context));
    Column column2 = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [category, SizedBox(height: padding24), text],
    );
    Widget container = Container(
      padding: EdgeInsets.all(padding36),
      decoration: BoxDecoration(
        color: containerBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: column2,
    );

    // 将两者组合
    Row row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: column1, flex: 1),
        Expanded(child: container, flex: 2),
      ],
    );
    return Padding(
      key: _globalKey,
      padding: EdgeInsets.only(bottom: padding24),
      child: row,
    );
  }

  TextStyle _subStyle(BuildContext context) => Theme.of(context).textTheme.bodyText2!.copyWith(
        color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
        fontSize: 30.px,
      );
}
