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

  CloseDialog? _closeDialogHandle; 

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
      listener: (context, state)  async{
        if (state is AuthStateLogout) {

final closeDialog = _closeDialogHandle;
if (!state.isLoading && closeDialog != null ) {
  closeDialog();
  _closeDialogHandle = null;
}else if (state.isLoading && closeDialog ==null) {
  _closeDialogHandle = showLoadingDialog(context: context, txt: "Membuka aplikasi....",);
}

                  if (state.exception is UserNotFoundException ||
                      state.exception is WrongPasswordException) {
                    await showErrorDialog(context, 'Pengguna tidak berhak masuk');
                  } else if (state.exception is GenericAuthException) {
                    await showErrorDialog(context, 'Terjadi kesalahan pada aplikasi');
                  }
                }
      },
      child: Scaffold(
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
              decoration:
                  const InputDecoration(hintText: 'Masukkan email Anda'),
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
                onPressed: ()   {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister()); 
                  
                 /*  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  ); */
                },
                child: const Text('Belum punya akun? Daftar gratis'))
          ],
        ),
      ),
    );
  }
}
