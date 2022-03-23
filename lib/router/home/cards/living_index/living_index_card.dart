import 'package:flutter/material.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/home/cards/living_index/model/living_index.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';
import 'package:weather_me/utils_box/weather_convert.dart';

class LivingIndexCard extends StatefulWidget {
  final List<LivingIndex> list;

  const LivingIndexCard({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  _LivingIndexCardState createState() => _LivingIndexCardState();
}

class _LivingIndexCardState extends State<LivingIndexCard> {
  /// 需要显示的生活指数项目
  late final List<String> typeSelect = ['1', '2', '3', '5', '6', '8', '15', '16'];

  @override
  Widget build(BuildContext context) {
    Widget title = _buildTitle();
    Widget content = _buildContent(widget.list);
    Column column = Column(children: [title, content]);
    return column;
  }

  /// 预报更多的文本样式
  late final TextStyle _moreStyle = const TextStyle(color: Colors.blueAccent);

  Widget _buildTitle() {
    Text title = Text(
      l10n(context).livingIndex,
      style: Theme.of(context).textTheme.headline6,
    );
    Widget more = GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding18, padding18, 0, padding18),
        child: Text(l10n(context).more, style: _moreStyle),
      ),
      onTap: () => AppRouterDelegate.of(context).push('living_forecast'),
    );
    Row row = Row(children: [
      title,
      const Expanded(child: SizedBox()),
      more,
    ]);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding36),
      height: 100.px,
      child: row,
    );
  }

  Widget _buildContent(List<LivingIndex> list) {
    // 用于存放显示的生活指数对象
    List<LivingIndex> result = _computeItem(list);
    GridView gridView = GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: padding24,
        mainAxisSpacing: padding24,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: result.length,
      itemBuilder: (context, index) {
        return LivingCardItem(index: result[index]);
      },
    );
    return MediaQuery.removePadding(
      removeTop: true,
      removeBottom: true,
      context: context,
      child: Padding(
        padding: EdgeInsets.only(
          left: padding36,
          right: padding36,
          bottom: padding36,
        ),
        child: gridView,
      ),
    );
  }

  /// 计算title栏需要展示的项目
  List<LivingIndex> _computeItem(List<LivingIndex> list) {
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
}

class LivingCardItem extends StatelessWidget {
  final LivingIndex index;

  const LivingCardItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget icon = Icon(
      livingType2IconData(index.type),
      color: Colors.blueAccent,
      size: 70.px,
    );
    Widget name = Text(index.name);
    Widget category = Text(
      index.category,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
            color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.6),
            fontSize: 24.px,
          ),
    );
    // 进行组合
    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [name, SizedBox(height: padding6), category],
    );
    Row row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: padding24),
        icon,
        SizedBox(width: padding24),
        column,
      ],
    );
    return Container(
      decoration: BoxDecoration(
        color: contentBackgroundColor(context),
        borderRadius: BorderRadius.all(Radius.circular(padding24)),
      ),
      child: row,
    );
  }
}
