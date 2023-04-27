import 'package:belanjaku/auth/auth_exception.dart';
import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/services/auth_service.dart';
import 'package:belanjaku/utility/dialog/error_dialog.dart';
import 'package:flutter/material.dart';

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
        title: const Text("Daftar Pengguna Baru"),
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

              if (myEmail.isEmpty) {
                showErrorDialog(context, 'Email belum diisikan');
                return;
              }

              try {
                await AuthService.firebase()
                    .createUser(email: myEmail, passwd: myPwd);

                await AuthService.firebase().sentEmailVerification();

                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordException {
                await showErrorDialog(context, 'Password lemah');
              } on EmailAlreadyExistException {
                await showErrorDialog(context, 'Email sudah terdaftar');
              } on InvalidEmailException {
                await showErrorDialog(context, 'Email tidak valid');
              } on GenericAuthException {
                await showErrorDialog(
                    context, 'Terjadi kesalahan dalam pendaftaran');
              }
            },
            child: const Text("Daftar"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Kembali ke login')),
        ],
      ),
    );
  }
}
