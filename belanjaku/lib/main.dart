import 'package:belanjaku/bloc/main_bloc.dart';
import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/services/auth_service.dart';
import 'package:belanjaku/views/halaman_login.dart';
import 'package:belanjaku/views/notes/halaman_note.dart';
import 'package:belanjaku/views/halaman_register.dart';
import 'package:belanjaku/views/halaman_verifikasi.dart';
import 'package:belanjaku/views/notes/halaman_note_edit_baru.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Belanja Ku',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HalamanUtama(),
    routes: {
      mainRoute: (context) => const HalamanUtama(),
      loginRoute: (context) => const HalamanLogin(),
      registerRoute: (context) => const HalamanDaftar(),
      notesRoute: (context) => const HalamanNotes(),
      verifyEmailRoute: (context) => const HalamanVerifikasi(),
      createOrUpdateRoute: (context) => const HalamanNewUpdate(),
    },
  ));
}
/* 
class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                writeLog("Logged & verified");
              } else {
                return const HalamanVerifikasi();
              }
            } else {
              return const HalamanLogin();
            }
            return const HalamanNotes();
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
} */

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  late final TextEditingController _txtCtrl;

  @override
  void initState() {
    _txtCtrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _txtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ngetest bloc'),
        ),
        body: BlocConsumer<CounterBloc, BlocCounterState>(
          builder: (context, state) {
            final invalidValue =
                (state is BlocCounterStateInvalid) ? state.invalidValue : '';
            return Column(
              children: [
                Text('Nilai saat ini: ${state.value}'),
                Visibility(
                  visible: state is BlocCounterStateInvalid,
                  child: Text('Input salah: $invalidValue'),
                ),
                TextField(
                  controller: _txtCtrl,
                  decoration: const InputDecoration(hintText: 'Masukkan nomor'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(BlocIncrementEvent(_txtCtrl.text));
                      },
                      child: const Icon(Icons.add),
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<CounterBloc>()
                            .add(BlocDecrementEvent(_txtCtrl.text));
                      },
                      child: const Icon(Icons.remove),
                    ),
                  ],
                )
              ],
            );
          },
          listener: (context, state) {
            _txtCtrl.clear();
          },
        ),
      ),
    );
  }
}
