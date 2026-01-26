import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:orsa_3/models/profile.dart';
import 'package:orsa_3/main.dart';

@NowaGenerated()
class SupabaseService {
  SupabaseService._();

  factory SupabaseService() {
    return _instance;
  }

  static final SupabaseService _instance = SupabaseService._();

  Future<AuthResponse> signIn(String email, String password) async {
    return Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  Future<bool> profileExists(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  Future<Profile?> getProfile(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response != null) {
        return Profile.fromJson(response);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future initialize() async {
    await Supabase.initialize(
      url: 'https://fzbdaqrmkfsvztgooibj.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6YmRhcXJta2Zzdnp0Z29vaWJqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg1NjQxNzQsImV4cCI6MjA3NDE0MDE3NH0.rY3WsJAC6WTpJX6KPoZwGNEj2XBMnjM0hDN3wirONhM',
    );
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final session = data.session;
      if (event == AuthChangeEvent.passwordRecovery) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushReplacementNamed('PasswordReset');
        });
      } else if (event == AuthChangeEvent.signedIn && session != null) {
        if (session.user.emailConfirmedAt != null) {
          final userId = session.user.id;
          final profileExists = await SupabaseService().profileExists(userId);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (profileExists) {
              navigatorKey.currentState?.pushReplacementNamed(
                'MainNavigationPage',
              );
            } else {
              navigatorKey.currentState?.pushReplacementNamed(
                'CompleteProfile',
              );
            }
          });
        }
      }
    });
  }
}
