import 'package:eight_night/enums/date_sorting.dart';
import 'package:eight_night/state/comments/models/post_comments_request.dart';
import 'package:eight_night/state/match/match_users.dart';
import 'package:eight_night/state/match/write_to_match.dart';
import 'package:eight_night/state/posts/models/post.dart';
import 'package:eight_night/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:eight_night/state/posts/providers/specific_post_with_comments_provider.dart';
import 'package:eight_night/views/components/animations/error_animation_view.dart';
import 'package:eight_night/views/components/animations/loading_animation_view.dart';
import 'package:eight_night/views/components/like_button.dart';
import 'package:eight_night/views/components/likes_count_view.dart';
import 'package:eight_night/views/components/post/post_date_view.dart';
import 'package:eight_night/views/components/post/post_display_name_and_message_view.dart';
import 'package:eight_night/views/components/post/post_image_or_video_view.dart';
import 'package:eight_night/views/post_comments/post_comments_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3, // at most 3 comments
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    // get the actual post together with its comments
    final postWithComments = ref.watch(
      specificPostWithCommentsProvider(
        request,
      ),
    );

    final addToMatch =
        ref.read(writeMatchProvider(widget.post.userId).notifier);
    final hasMatch = ref.watch(hasMatchProvider(widget.post.userId));

    // can we delete this post?
    final canDeletePost = ref.watch(
      canCurrentUserDeletePostProvider(
        widget.post,
      ),
    );

    return postWithComments.when(
      data: (postWithComments) {
        final postId = postWithComments.post.postId;
        return Stack(
          alignment: Alignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PostImageOrVideoView(
              post: postWithComments.post,
            ),
            // like and comment buttons
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // like button if post allows liking it
                  if (postWithComments.post.allowsLikes)
                    LikeButton(
                      postId: postId,
                    ),
                  if (postWithComments.post.allowsLikes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: LikesCountView(
                        postId: postId,
                      ),
                    ),
                  if (postWithComments.post.allowsComments)
                    IconButton(
                      icon: const Icon(
                        Icons.mode_comment_outlined,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => PostCommentsView(
                            postId: postId,
                          ),
                        );
                      },
                    ),
                  IconButton(
                      onPressed: () => addToMatch.writeMatch(),
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
            //post details (shows divider at bottom)
            hasMatch.whenOrNull(
                    data: (isMatch) => isMatch
                        ? Container(
                            color: Colors.amber,
                            width: 60,
                            height: 60,
                          )
                        : Container(
                            color: Colors.black,
                            width: 60,
                            height: 60,
                          )) ??
                const SizedBox(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PostDisplayNameAndMessageView(
                    post: postWithComments.post,
                  ),
                  PostDateView(
                    dateTime: postWithComments.post.createdAt,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),

            // comments
            // CompactCommentsColumn(
            //   comments: postWithComments.comments,
            // ),
          ],
        );
      },
      error: (error, stackTrace) {
        return const ErrorAnimationView();
      },
      loading: () {
        return const LoadingAnimationView();
      },
    );
  }
}
