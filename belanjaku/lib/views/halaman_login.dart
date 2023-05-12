import 'package:belanjaku/auth/auth_exception.dart';
import 'package:belanjaku/bloc/auth/auth_bloc.dart';
import 'package:belanjaku/bloc/auth/auth_event.dart';
import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/utility/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                context.read<AuthBloc>().add(
                      AuthEventLogin(
                        myEmail,
                        myPwd,
                      ),
                    );
                /* await AuthService.firebase()
                    .login(email: myEmail, passwd: myPwd);
                final userCred = AuthService.firebase().currentUser;
                if (userCred?.isEmailVerified ?? false) {
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
                } */
              } on UserNotFoundException {
                await showErrorDialog(context, 'Pengguna tidak ditemukan');
              } on WrongPasswordException {
                await showErrorDialog(context, 'Password salah');
              } on GenericAuthException {
                await showErrorDialog(context, 'Terjadi kesalahan fatal');
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
