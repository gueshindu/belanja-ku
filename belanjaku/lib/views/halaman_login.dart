import 'package:belanjaku/constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utility/error_dialog.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({Key? key}) : super(key: key);

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
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
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          const SizedBox(
            height: 7,
          ),
          const Text("Login"),
          const SizedBox(
            height: 7,
          ),
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
                    .signInWithEmailAndPassword(
                        email: myEmail, password: myPwd);
                if (userCred.user?.emailVerified ?? false) {
                  //Verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    mainRoute,
                    (route) => false,
                  );
                } else {
                  //Not verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                await showErrorDialog(context, e.message ?? '');
              } catch (e) {
                await showErrorDialog(
                    context, 'Terjadi kesalahan fatal ${e.toString()}');
              }
            },
            child: const Text("Masuk"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Belum punya akun? Daftar gratis'))
        ],
      ),
    );
  }
}
