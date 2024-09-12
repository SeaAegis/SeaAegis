import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:seaaegis/providers/app_theme.dart';
import 'package:seaaegis/providers/beach_data_provider.dart';
import 'package:seaaegis/providers/user_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AppThemeProvider()),
    ChangeNotifierProvider(create: (_) => BeachDataProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider())
  ];
}
