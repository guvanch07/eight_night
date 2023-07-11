import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eight_night/state/auth/providers/user_id_provider.dart';
import 'package:eight_night/state/constants/firebase_collection_name.dart';
import 'package:eight_night/state/constants/firebase_field_name.dart';
import 'package:eight_night/state/posts/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final allPostsProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    final userId = ref.watch(userIdProvider);
    final controller = StreamController<Iterable<Post>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .where(FirebaseFieldName.userId, isEqualTo: userId)
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        .snapshots()
        .listen(
      (snapshots) {
        final posts = snapshots.docs.map(
          (doc) => Post(
            json: doc.data(),
            postId: doc.id,
          ),
        );
        controller.sink.add(posts);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
