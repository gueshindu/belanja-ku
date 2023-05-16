import 'package:belanjaku/auth/auth_exception.dart';
import 'package:belanjaku/bloc/auth/auth_bloc.dart';
import 'package:belanjaku/bloc/auth/auth_event.dart';
import 'package:belanjaku/bloc/auth/auth_state.dart';
import 'package:belanjaku/utility/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordException) {
            await showErrorDialog(context, 'Password lemah');
          } else if (state.exception is EmailAlreadyExistException) {
            await showErrorDialog(context, 'Email sudah terdaftar');
          } else if (state.exception is InvalidEmailException) {
            await showErrorDialog(context, 'Email tidak valid');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
                context, 'Terjadi kesalahan dalam pendaftaran');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Daftar Pengguna Baru"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Masukkan email dan password baru'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: true,
                autofocus: true,
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
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final eml = email.text;
                        final pwd = passwd.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventRegister(eml, pwd));
                      },
                      child: const Text("Daftar"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventLogout());
                      },
                      child: const Text('Kembali ke login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
