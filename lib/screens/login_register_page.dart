import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp0/model/user_model.dart';
import 'package:todoapp0/service/auth.dart';
import 'package:todoapp0/service/user_service.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  UserService userService = UserService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String? errorMessage;

  void showMessage(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  bool isLogin = true;

  Future<void> createUser() async {
    try {
      final userCred = await Auth().createUser(
        email: emailController.text,
        password: passwordController.text,
      );

      showMessage("Kayıt başarılı!", false);

      UserModel newUser = UserModel(
        uid: userCred.user!.uid,
        name: nameController.text,
        surname: surnameController.text,
        mailAddress: userCred.user!.email,
        username: usernameController.text,
      );

      userService.createDbUser(newUser);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      showMessage("Kayıt başarısız", true);
    }
  }

  Future<void> signIn() async {
    try {
      await Auth().signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      showMessage("Giriş başarılı!", false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      showMessage("Giriş başarısız!", true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // tasarım buradan aşağısı
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLogin ? "Giriş Yap" : "Kayıt Ol",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (!isLogin) ...[
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "İsim",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: surnameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Soyisim",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Kullanıcı Adı",
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "E-posta",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Şifre",
                      ),
                    ),
                    const SizedBox(height: 15),

                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (isLogin) {
                          signIn();
                        } else {
                          createUser();
                        }
                      },
                      child: Text(
                        isLogin ? "Giriş Yap" : "Kayıt Ol",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? "Henüz hesabın yok mu? Tıkla!"
                            : "Zaten hesabın var mı? Tıkla!",
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
