import 'package:belanjaku/bloc/auth/auth_bloc.dart';
import 'package:belanjaku/bloc/auth/auth_event.dart';
import 'package:belanjaku/bloc/auth/auth_state.dart';
import 'package:belanjaku/utility/dialog/error_dialog.dart';
import 'package:belanjaku/utility/dialog/password_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HalamanLupaPassword extends StatefulWidget {
  const HalamanLupaPassword({Key? key}) : super(key: key);

  @override
  State<HalamanLupaPassword> createState() => _HalamanLupaPasswordState();
}

class _HalamanLupaPasswordState extends State<HalamanLupaPassword> {
  late final TextEditingController _txtCtrl;

  @override
  void initState() {
    super.initState();
    _txtCtrl = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _txtCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _txtCtrl.clear();
            await showResetPasswordDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
                context, 'Tidak bisa memproses reset password.');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lupa password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Masukkan email untuk reset password'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _txtCtrl,
                decoration: const InputDecoration(hintText: 'Alamat email'),
              ),
              TextButton(
                onPressed: () {
                  final mail = _txtCtrl.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: mail));
                },
                child: const Text(
                  'Kirim link reset password',
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text(
                  'Ke halaman login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
