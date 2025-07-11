import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp0/model/user_model.dart';

class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // create user
  Future<void> createDbUser(UserModel user) async {
    try {
      await firestore.collection("users").doc(user.uid).set(user.toJson());
    } catch (e) {
      // hata loglanabilir
    }
  }

  // get user by uid
  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection("users").doc(uid).get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  // ✅ YENİ EKLENECEK: Kullanıcı belgesini sil
  Future<void> deleteDbUser(String uid) async {
    try {
      await firestore.collection("users").doc(uid).delete();
    } catch (e) {
      print("Kullanıcı silinirken hata oluştu: $e");
    }
  }
}
