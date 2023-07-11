

import 'package:eight_night/state/auth/models/auth_state.dart';
import 'package:eight_night/state/auth/notifiers/auth_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifierProvider;

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
  
);
