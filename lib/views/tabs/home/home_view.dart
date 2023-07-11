import 'package:eight_night/state/posts/providers/all_posts_provider.dart';
import 'package:eight_night/state/user_info/providers/user_info_model_provider.dart';
import 'package:eight_night/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:eight_night/views/components/animations/error_animation_view.dart';
import 'package:eight_night/views/components/animations/loading_animation_view.dart';
import 'package:eight_night/views/components/post/posts_grid_view.dart';
import 'package:eight_night/views/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
    required this.userId,
  }) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostsProvider);
    final userInfo = ref.watch(
      userInfoModelProvider(userId),
    );
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(allPostsProvider);
          return Future.delayed(
            const Duration(
              seconds: 1,
            ),
          );
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(radius: 60),
                  Column(
                    children: const [
                      Text('name'),
                      Text('position'),
                      Text('email'),
                      Text('phone')
                    ],
                  )
                ],
              ),
            ),
            ExpansionTile(
              title: const Text('work experance'),
              children: [
                Container(
                  height: 100,
                  color: Colors.amber,
                )
              ],
            ),
            ExpansionTile(
              title: const Text('Skills and languages'),
              children: [
                Container(
                  height: 100,
                  color: Colors.amber,
                )
              ],
            ),
            ExpansionTile(
              title: const Text('about yourself'),
              children: [
                Container(
                  height: 100,
                  color: Colors.amber,
                )
              ],
            ),
            posts.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const EmptyContentsWithTextAnimationView(
                    text: Strings.noPostsAvailable,
                  );
                } else {
                  return PostsGridView(
                    posts: posts,
                  );
                }
              },
              error: (error, stackTrace) {
                return const ErrorAnimationView();
              },
              loading: () {
                return const LoadingAnimationView();
              },
            ),
          ],
        ),
      ),
    );
  }
}
