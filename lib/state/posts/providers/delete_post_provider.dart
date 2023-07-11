import 'package:eight_night/state/image_upload/typedefs/is_loading.dart';
import 'package:eight_night/state/posts/notifiers/delete_post_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (ref) => DeletePostStateNotifier(),
);
