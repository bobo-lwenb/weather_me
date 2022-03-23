import 'package:flutter/material.dart';
import 'package:weather_me/utils_box/size_fit.dart';
import 'package:weather_me/utils_box/utils_color.dart';

/// 切割的上三角路径
class LeadingTrianglePath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// 切割的下三角路径
class TrailingTrianglePath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// 可滚动的卡片布局列表
class CardLayout extends StatelessWidget {
  final String? text;
  final List<Widget> children;

  const CardLayout({
    Key? key,
    this.text,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List.empty(growable: true);
    for (int i = 0; i < children.length; i++) {
      Container outter = Container(
        margin: EdgeInsets.only(
          top: padding48,
          left: i.isEven ? 100.px : 0,
          right: i.isOdd ? 100.px : 0,
        ),
        child: children[i],
      );
      list.add(outter);
    }
    GridView gridView = GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 100.px,
      childAspectRatio: 0.6,
      children: list,
    );

    Row row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: padding42),
        SizedBox(width: padding12),
        Expanded(
            child: Text(
          text ?? 'fsdhfkhjskdfhskdhf',
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5)),
        )),
      ],
    );
    CustomScrollView scrollView = CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: gridView),
        SliverToBoxAdapter(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding48),
          child: text == null ? const SizedBox() : row,
        )),
      ],
    );
    return scrollView;
  }
}

/// 可滚动的卡片布局列表的item
class ItemCard extends StatelessWidget {
  final bool isCheck;
  final String title;
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const ItemCard({
    Key? key,
    required this.isCheck,
    required this.title,
    required this.child,
    this.onTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 卡片
    Widget inner = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(padding24)),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? containerBackgroundColor(context),
          borderRadius: BorderRadius.all(Radius.circular(padding24)),
          border: Border.all(width: 6.px, color: isCheck ? tomato : Colors.transparent),
        ),
        child: child,
      ),
    );

    /// 下方标题
    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isCheck ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: padding30,
        ),
        SizedBox(width: padding6),
        Text(title),
      ],
    );

    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: inner),
          SizedBox(height: padding24),
          Center(child: row),
        ],
      ),
      onTap: () {
        if (onTap != null) onTap!();
      },
    );
  }
}

/// 卡片内容的布局
class CardContent extends StatelessWidget {
  final Widget child;

  const CardContent({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 60.px,
        padding: EdgeInsets.only(left: 20.px),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.arrow_back_ios_rounded, size: 20.px),
      ),
      Divider(height: 1.px),
      Expanded(child: child),
    ]);
  }
}

/// 用于规定卡片中文本的样式
class Height36 extends StatelessWidget {
  final String text;

  const Height36({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: padding36,
      child: Center(
        child: Text(text, style: TextStyle(fontSize: padding24)),
      ),
    );
  }
}
