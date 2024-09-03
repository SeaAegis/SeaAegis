import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:seaaegis/providers/app_theme.dart';

class AppProviders {
  static List<SingleChildWidget> appProviders = [
    ChangeNotifierProvider(create: (_) => AppThemeProvider())
  ];
}
