import 'dart:async';

import 'package:eight_night/state/auth/providers/user_id_provider.dart';
import 'package:eight_night/state/comments/models/post_comments_request.dart';
import 'package:eight_night/state/comments/providers/post_comments_provider.dart';
import 'package:eight_night/state/comments/providers/send_comment_provider.dart';
import 'package:eight_night/state/posts/typedefs/post_id.dart';
import 'package:eight_night/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:eight_night/views/components/animations/error_animation_view.dart';
import 'package:eight_night/views/components/animations/loading_animation_view.dart';
import 'package:eight_night/views/components/comment/comment_tile.dart';
import 'package:eight_night/views/constants/strings.dart';
import 'package:eight_night/views/extensions/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostCommentsView extends HookConsumerWidget {
  final PostId postId;

  const PostCommentsView({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final hasText = useState(false);
    final request = useState(
      RequestForPostAndComments(
        postId: postId,
      ),
    );
    final comments = ref.watch(
      postCommentsProvider(
        request.value,
      ),
    );

    // enable Post button when text is entered in the textfield
    useEffect(
      () {
        commentController.addListener(() {
          hasText.value = commentController.text.isNotEmpty;
        });
        return () {};
      },
      [commentController],
    );

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: comments.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const SingleChildScrollView(
                    child: EmptyContentsWithTextAnimationView(
                      text: Strings.noCommentsYet,
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () {
                    ref.refresh(
                      postCommentsProvider(
                        request.value,
                      ),
                    );
                    return Future.delayed(
                      const Duration(
                        seconds: 1,
                      ),
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments.elementAt(index);
                      return CommentTile(
                        comment: comment,
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) {
                return const ErrorAnimationView();
              },
              loading: () {
                return const LoadingAnimationView();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: commentController,
              onSubmitted: (comment) {
                if (comment.isNotEmpty) {
                  _submitCommentWithController(
                    commentController,
                    ref,
                  );
                }
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: hasText.value
                      ? () {
                          _submitCommentWithController(
                            commentController,
                            ref,
                          );
                        }
                      : null,
                ),
                border: const OutlineInputBorder(),
                labelText: Strings.writeYourCommentHere,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final isSent = await ref
        .read(
          sendCommentProvider.notifier,
        )
        .sendComment(
          fromUserId: userId,
          onPostId: postId,
          comment: controller.text,
        );
    if (isSent) {
      controller.clear();
      dismissKeyboard();
    }
  }
}
