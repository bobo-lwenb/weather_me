import 'package:flutter/material.dart';
import 'package:weather_me/l10n/intl_func.dart';
import 'package:weather_me/router/home/cards/sun_moon/model/moon_active.dart';
import 'package:weather_me/router/home/cards/sun_moon/model/sun_active.dart';
import 'package:weather_me/router/home/cards/sun_moon/pallet.dart';
import 'package:weather_me/utils_box/size_fit.dart';

class SunMoonCard extends StatefulWidget {
  final SunActive sunActive;
  final MoonActive moonActive;

  const SunMoonCard({
    Key? key,
    required this.sunActive,
    required this.moonActive,
  }) : super(key: key);

  @override
  _SunMoonCardState createState() => _SunMoonCardState();
}

class _SunMoonCardState extends State<SunMoonCard> {
  @override
  Widget build(BuildContext context) {
    Widget title = _buildTitle();
    Widget sunMoon = SizedBox(
      height: 600.px,
      child: CustomPaint(
        painter: Pallet(
          context: context,
          sun: widget.sunActive,
          moon: widget.moonActive,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [title, sunMoon],
    );
  }

  Widget _buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 100.px,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding36),
        child: Text(
          l10n(context).sunMoon,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
