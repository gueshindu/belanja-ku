import 'package:belanjaku/auth/auth_exception.dart';
import 'package:belanjaku/bloc/auth/auth_bloc.dart';
import 'package:belanjaku/bloc/auth/auth_event.dart';
import 'package:belanjaku/bloc/auth/auth_state.dart';
import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/utility/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utility/dialog/loading_dialog.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({Key? key}) : super(key: key);

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  late final TextEditingController email;
  late final TextEditingController passwd;

  //CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLogout) {
          if (state.exception is UserNotFoundException ||
              state.exception is WrongPasswordException) {
            await showErrorDialog(context, 'Email atau password tidak sesuai');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Terjadi kesalahan pada aplikasi');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 7,
              ),
              const Text("Masuk aplikasi dengan email dan password"),
              const SizedBox(
                height: 7,
              ),
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
                  context.read<AuthBloc>().add(
                        AuthEventLogin(
                          myEmail,
                          myPwd,
                        ),
                      );
                },
                child: const Text("Masuk"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text('Belum punya akun? Daftar gratis'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventForgotPassword());
                },
                child: const Text('Lupa password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
