import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eight_night/state/constants/firebase_collection_name.dart';
import 'package:eight_night/state/constants/firebase_field_name.dart';
import 'package:eight_night/state/posts/typedefs/user_id.dart';
import 'package:eight_night/state/user_info/models/user_info_payload.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();
  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      // first check if we have this user's info from before
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .get();

      if (userInfo.exists) {
        // we already have this user's profile, save the new data instead
        await userInfo.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }

      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .doc(userId)
          .set(payload);
      return true;
    } catch (_) {
      return false;
    }
  }
}
