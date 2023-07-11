import 'package:eight_night/state/auth/providers/user_id_provider.dart';
import 'package:eight_night/state/posts/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final canCurrentUserDeletePostProvider =
    StreamProvider.autoDispose.family<bool, Post>((ref, Post post) async* {
  final userId = ref.watch(userIdProvider);
  yield userId == post.userId;
});
