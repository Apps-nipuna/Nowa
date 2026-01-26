import 'package:shared_preferences/shared_preferences.dart';
import 'package:orsa_3/integrations/supabase_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orsa_3/globals/app_state.dart';
import 'package:orsa_3/pages/complete_profile.dart';
import 'package:orsa_3/pages/create_account_page.dart';
import 'package:orsa_3/pages/create_article.dart';
import 'package:orsa_3/pages/events.dart';
import 'package:orsa_3/pages/forgot_password_page.dart';
import 'package:orsa_3/pages/home_page.dart';
import 'package:orsa_3/pages/main_navigation_page.dart';
import 'package:orsa_3/pages/members.dart';
import 'package:orsa_3/pages/memories_home.dart';
import 'package:orsa_3/pages/my_profile.dart';
import 'package:orsa_3/pages/password_reset.dart';
import 'package:orsa_3/pages/projects.dart';
import 'package:orsa_3/pages/sign_in_page.dart';

@NowaGenerated()
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await SupabaseService().initialize();
  runApp(const MyApp());
}

@NowaGenerated({'visibleInNowa': false})
class MyApp extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      builder: (context, child) => MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppState.of(context).theme,
        initialRoute: 'SignInPage',
        routes: {
          'CompleteProfile': (context) => const CompleteProfile(),
          'CreateAccountPage': (context) => const CreateAccountPage(),
          'CreateArticle': (context) => const CreateArticle(),
          'Events': (context) => const Events(),
          'ForgotPasswordPage': (context) => const ForgotPasswordPage(),
          'HomePage': (context) => const HomePage(),
          'MainNavigationPage': (context) => const MainNavigationPage(),
          'Members': (context) => const Members(),
          'MemoriesHome': (context) => const MemoriesHome(),
          'MyProfile': (context) => const MyProfile(),
          'PasswordReset': (context) => const PasswordReset(),
          'Projects': (context) => const Projects(),
          'SignInPage': (context) => const SignInPage(),
        },
      ),
    );
  }
}

@NowaGenerated()
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@NowaGenerated()
late final SharedPreferences sharedPrefs;
