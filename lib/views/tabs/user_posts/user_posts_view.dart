import 'package:eight_night/state/posts/providers/user_posts_provider.dart';
import 'package:eight_night/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:eight_night/views/components/animations/error_animation_view.dart';
import 'package:eight_night/views/components/animations/loading_animation_view.dart';
import 'package:eight_night/views/components/post/posts_swipe_up.dart';
import 'package:eight_night/views/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);
    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(userPostsProvider);
        return Future.delayed(
          const Duration(
            seconds: 1,
          ),
        );
      },
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
                text: Strings.youHaveNoPosts);
          } else {
            return PostsSwipeUpView(posts: posts);
          }
        },
        error: (error, stackTrace) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView(),
      ),
    );
  }
}
