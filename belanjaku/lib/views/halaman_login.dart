import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:belanjaku/firebase_options.dart';

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
      appBar: AppBar(
        title: const Text('Masuk'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: true,
                    decoration:
                        const InputDecoration(hintText: 'Masukkan email Anda'),
                    controller: email,
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        const InputDecoration(hintText: 'Password Aplikasi'),
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
                      } on FirebaseAuthException catch (e) {
                        print(e.code);
                      }
                    },
                    child: const Text("Masuk"),
                  ),
                ],
              );
            default:
              return const Text("Membuka...");
          }
        },
      ),
    );
  }
}
