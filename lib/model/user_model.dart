
class UserModel {
  final String? uid; //unique ıd
  final String? name;
  final String? surname;
  final String? mailAddress;
  final String? username;

  UserModel({
    required this.uid,
    required this.name,
    required this.surname,
    required this.mailAddress,
    required this.username,
  });

  //json PARSE
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      name: json["name"],
      surname: json["surname"],
      mailAddress: json["mailAdress"],
      username: json["username"],
    );
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data ={};
      data["uid"] = uid;
      data["name"] = name;
      data[ "surname"]= surname;
      data["mailAdress"]= mailAddress;
      data["username"]=username;
    return data;
  }
}
