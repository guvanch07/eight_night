import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eight_night/state/auth/providers/user_id_provider.dart';
import 'package:eight_night/state/constants/firebase_collection_name.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final writeMatchProvider =
    StateNotifierProvider.autoDispose.family<WriteMatchData, bool, String>(
  (ref, uidMatch) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return WriteMatchData(false, '', '');
    }
    return WriteMatchData(false, userId, uidMatch);
  },
);

class WriteMatchData extends StateNotifier<bool> {
  WriteMatchData(super.state, this.userId, this.uidForMatch);
  final String userId;
  final String uidForMatch;
  final _store = FirebaseFirestore.instance;

  Future<bool> writeMatch() async {
    try {
      _store.collection(FirebaseCollectionName.users).doc(userId).update({
        'likedBy': FieldValue.arrayUnion([uidForMatch])
      });
      final currentUser = await _store
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .get();

      final otherUser = await _store
          .collection(FirebaseCollectionName.users)
          .doc(uidForMatch)
          .get();

      final likedByCurrent = currentUser['likedBy'] as List<dynamic>;
      final likedByOther = otherUser['likedBy'] as List<dynamic>;
      if (likedByCurrent.contains(uidForMatch) &&
          likedByOther.contains(userId)) {
        final matchId =
            _store.collection(FirebaseCollectionName.match).doc().id;
        _store.collection(FirebaseCollectionName.match).doc(matchId).set({
          'user1': uidForMatch,
          'user2': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return Future.value(true);
    } on FirebaseException catch (e) {
      log('$e');
      return Future.value(false);
    } catch (e) {
      log('$e');
      return Future.value(false);
    }
  }
}
