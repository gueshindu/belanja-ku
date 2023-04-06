import 'package:belanjaku/constant/routes.dart';
import 'package:belanjaku/services/auth_service.dart';
import 'package:flutter/material.dart';

class HalamanVerifikasi extends StatefulWidget {
  const HalamanVerifikasi({Key? key}) : super(key: key);

  @override
  State<HalamanVerifikasi> createState() => _HalamanVerifikasiState();
}

class _HalamanVerifikasiState extends State<HalamanVerifikasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Email'),
      ),
      body: Column(
        children: [
          const Text(
              "Sebuah email verifikasi telah dikirim. Silahkan cek email Anda.\nJika anda belum menerima maka kirim ulang dengan menekan tombol dibawah ini"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sentEmailVerification();
              await AuthService.firebase().logOut();

              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (_) => false,
              );
            },
            child: const Text("Kirim verifikasi ke email"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (_) => false,
              );
            },
            child: const Text("Halaman Login"),
          ),
        ],
      ),
    );
  }
}
