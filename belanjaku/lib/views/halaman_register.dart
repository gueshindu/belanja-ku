import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({Key? key}) : super(key: key);

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  late final TextEditingController email;
  late final TextEditingController passwd;

  @override
  void initState() {
    email = TextEditingController();
    passwd = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    passwd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar"),
      ),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: true,
            decoration: const InputDecoration(hintText: 'Masukkan email Anda'),
            controller: email,
          ),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Password Aplikasi'),
            controller: passwd,
          ),
          TextButton(
            onPressed: () async {
              final myEmail = email.text;
              final myPwd = passwd.text;

              try {
                final userCred = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: myEmail, password: myPwd);
              } on FirebaseAuthException catch (e) {
                print(e.code);
              }
            },
            child: const Text("Daftar"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/login/", (route) => false);
              },
              child: const Text('Kembali ke login')),
        ],
      ),
    );
  }
}
