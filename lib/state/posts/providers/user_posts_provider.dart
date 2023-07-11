import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eight_night/state/auth/providers/user_id_provider.dart';
import 'package:eight_night/state/constants/firebase_collection_name.dart';
import 'package:eight_night/state/constants/firebase_field_name.dart';
import 'package:eight_night/state/posts/models/post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>(
  (ref) {
    final userId = ref.watch(userIdProvider);

    final controller = StreamController<Iterable<Post>>();

    controller.onListen = () {
      controller.sink.add([]);
    };

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .orderBy(FirebaseFieldName.createdAt, descending: true)
        //.where(PostKey.userId, isNotEqualTo: userId)
        .snapshots()
        .listen(
      (snapshot) {
        final documents = snapshot.docs;
        final posts =
            documents.where((doc) => !doc.metadata.hasPendingWrites).map(
                  (doc) => Post(
                    postId: doc.id,
                    json: doc.data(),
                  ),
                );
        log(posts.first.userId);
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
