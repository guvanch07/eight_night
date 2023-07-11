import 'package:eight_night/state/likes/providers/post_likes_count_provider.dart';
import 'package:eight_night/state/posts/typedefs/post_id.dart';
import 'package:eight_night/views/components/animations/small_error_animation_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;
  const LikesCountView({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikesCountProvider(postId));
    return likesCount.when(
      data: (int likesCount) {
        final likesText = '$likesCount';
        return Text(likesText);
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}


// class LikesCountView extends ConsumerWidget {
//   final PostId postId;
//   const LikesCountView({
//     Key? key,
//     required this.postId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final likesCount = ref.watch(postLikesCountProvider(postId));
//     return likesCount.when(
//       data: (int likesCount) {
//         final personOrPeople =
//             likesCount == 1 ? Strings.person : Strings.people;
//         final likesText = '$likesCount $personOrPeople ${Strings.likedThis}';
//         return Text(likesText);
//       },
//       error: (error, stackTrace) {
//         return const SmallErrorAnimationView();
//       },
//       loading: () {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
// }