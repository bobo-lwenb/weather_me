import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_me/router/setting/provider_setting.dart';
import 'package:weather_me/utils_box/navigator_manager.dart';
import 'package:weather_me/utils_box/style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late AppRouterDelegate delegate = AppRouterDelegate();
  late AppRouteParser parser = AppRouteParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Weather Me',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(localeProvider),
      themeMode: ref.watch(themeProvider),
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      routerDelegate: delegate,
      routeInformationParser: parser,
      localeResolutionCallback: (locale, supportedLocales) {
        if (ref.read(systemLocaleProvider.notifier).state == null) {
          ref.read(systemLocaleProvider.notifier).state = locale;
        }
        return null;
      },
    );
  }
}
