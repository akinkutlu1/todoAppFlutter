import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp0/model/user_model.dart';
 // firebase e istek yapacağımız yer
class UserService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // create user
  Future<void> createDbUser(UserModel user) async{
    try {
      await firestore.collection("users").doc(user.uid).set(user.toJson());
    } catch (e) {
      
    }
  }
}