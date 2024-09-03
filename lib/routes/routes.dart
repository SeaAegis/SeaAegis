import 'package:seaaegis/views/home/home.dart';
import 'package:seaaegis/views/auth/signin.dart';
import 'package:seaaegis/views/auth/signup.dart';

class AppRoutes {
  static const String loginRoute = '/signin';
  static const String signupRoute = '/signup';
  static const String homePageRoute = '/home';
  static final routes = {
    loginRoute: (context) => const LoginScreen(),
    signupRoute: (context) => const SignUpScreen(),
    homePageRoute: (context) => HomeScreen(),
  };
}
