import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eight_night/state/auth/providers/user_id_provider.dart';
import 'package:eight_night/state/constants/firebase_collection_name.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hasMatchProvider = StreamProvider.family.autoDispose<bool, String>(
  (ref, String uidForMatch) {
    final userId = ref.watch(userIdProvider);

    if (userId == null) {
      return Stream<bool>.value(false);
    }
    final controller = StreamController<bool>();
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sub;

    FirebaseFirestore.instance
        .collection(FirebaseCollectionName.match)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        sub = FirebaseFirestore.instance
            .collection(FirebaseCollectionName.match)
            .where('user2', isEqualTo: userId)
            .where('user1', isEqualTo: uidForMatch)
            .snapshots()
            .listen((event) {
          if (event.docs.isNotEmpty) {
            controller.sink.add(true);
          }
        });
      } else {
        controller.sink.add(false);
      }
    });

    ref.onDispose(() {
      sub?.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
