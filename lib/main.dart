import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:orsa_3/integrations/supabase_service.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orsa_3/globals/app_state.dart';
import 'package:orsa_3/pages/complete_profile.dart';
import 'package:orsa_3/pages/create_account_page.dart';
import 'package:orsa_3/pages/forgot_password_page.dart';
import 'package:orsa_3/pages/main_navigation_page.dart';
import 'package:orsa_3/pages/sign_in_page.dart';
import 'package:orsa_3/pages/password_reset.dart';
// Add this line near the top of your file
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@NowaGenerated()
late final SharedPreferences sharedPrefs;

@NowaGenerated()
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await SupabaseService().initialize();
  // --- START OF NEW CODE ---
  // Listen for the Password Recovery event
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;
    if (event == AuthChangeEvent.passwordRecovery) {
      // NOTE: Make sure you have a page/route named 'CreateNewPasswordPage'
      // or change this string to match the page you want to show.
      navigatorKey.currentState?.pushReplacementNamed('password_reset'); 
    }
  });
  // --- END OF NEW CODE ---
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
        theme: AppState.of(context).theme,
        initialRoute: 'SignInPage',
        routes: {
          'CompleteProfile': (context) => const CompleteProfile(),
          'CreateAccountPage': (context) => const CreateAccountPage(),
          'ForgotPasswordPage': (context) => const ForgotPasswordPage(),
          'MainNavigationPage': (context) => const MainNavigationPage(),
          'SignInPage': (context) => const SignInPage(),
          'password_reset': (context) => const PasswordReset(),
        },
      ),
    );
  }
}
