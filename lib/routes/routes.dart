import 'package:seaaegis/screens/home/home.dart';
import 'package:seaaegis/screens/auth/user/login.dart';
import 'package:seaaegis/screens/auth/user/signup.dart';

class AppRoutes {
  static const String loginRoute = '/signin';
  static const String signupRoute = '/signup';
  static const String homePageRoute = '/home';
  static final routes = {
    loginRoute: (context) => LoginScreen(),
    signupRoute: (context) => SignupScreen(),
    homePageRoute: (context) => HomeScreen(),
  };
}
