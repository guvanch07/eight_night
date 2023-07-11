import 'package:eight_night/state/post_settings/models/post_setting.dart';
import 'package:eight_night/state/post_settings/notifiers/post_settings_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingNotifier(),
);
