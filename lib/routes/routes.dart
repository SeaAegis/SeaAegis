import 'package:seaaegis/screens/home/home.dart';
import 'package:seaaegis/screens/auth/signin.dart';
import 'package:seaaegis/screens/auth/signup.dart';

class AppRoutes{
  static const String loginRoute = '/signin';
  static const String signupRoute = '/signup';
  static const String homePageRoute = '/home';
  static final routes = {
    loginRoute: (context) => const LoginScreen(),
    signupRoute: (context) => const SignUpScreen(),
    homePageRoute: (context) => const HomeScreen(),
  };
}


