import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp0/model/user_model.dart';
import 'package:todoapp0/service/user_service.dart';
import 'package:todoapp0/service/auth.dart';
import 'package:todoapp0/screens/login_register_page.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserModel? currentUser;
  bool isLoading = true;
  final _auth = Auth();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final user = await UserService().getUserById(uid);
        setState(() {
          currentUser = user;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Hesabı Sil"),
      content: const Text(
          "Hesabını kalıcı olarak silmek istediğine emin misin? Bu işlem geri alınamaz."),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Vazgeç")),
        TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Sil", style: TextStyle(color: Colors.red))),
      ],
    ),
  );

  if (confirm != true) return;

  final password = await _showReauthDialog();
  if (password == null || password.isEmpty) return;

  setState(() => isLoading = true);

  final reauthSuccess = await _reauthenticateUser(password);
  if (!reauthSuccess) {
    setState(() => isLoading = false);
    return;
  }

  try {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await UserService().deleteDbUser(uid);
      await _auth.deleteAccount();
      await _auth.signOut();

      // 🔁 Uygulama yeniden başlatılmış gibi login ekranına yönlendirme
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginRegisterPage()),
          (route) => false,
        );
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bir şeyler ters gitti.")),
    );
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}


  Future<String?> _showReauthDialog() async {
    String? password;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Yeniden Kimlik Doğrulama"),
          content: TextField(
            obscureText: true,
            decoration: const InputDecoration(labelText: "Şifreni gir"),
            onChanged: (value) => password = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(password),
              child: const Text("Onayla"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _reauthenticateUser(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kimlik doğrulama başarısız.")),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesap Bilgileri"),
        backgroundColor: Colors.purple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentUser == null
              ? const Center(child: Text("Kullanıcı bilgileri bulunamadı."))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.purple.shade200,
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "${currentUser!.name ?? ''} ${currentUser!.surname ?? ''}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildInfoTile("Kullanıcı Adı", currentUser!.username),
                      _buildInfoTile("E-posta", currentUser!.mailAddress),
                      _buildInfoTile("UID", currentUser!.uid),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _deleteAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text("Hesabı Sil"),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.shade100),
        ),
        child: ListTile(
          title: Text(label),
          subtitle: Text(value ?? "-", style: const TextStyle(fontSize: 16)),
          leading: const Icon(Icons.info_outline, color: Colors.purple),
        ),
      ),
    );
  }
}
