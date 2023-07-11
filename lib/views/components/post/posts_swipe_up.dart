import 'package:eight_night/state/posts/models/post.dart';
import 'package:eight_night/views/post_details/post_details_view.dart';
import 'package:flutter/material.dart';

class PostsSwipeUpView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsSwipeUpView({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts.elementAt(index);
        return PostDetailsView(post: post);
      },
    );
  }
}
