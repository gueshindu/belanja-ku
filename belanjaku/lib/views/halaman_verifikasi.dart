import 'package:firebase_auth/firebase_auth.dart';
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
          const Text("Vefifikasi email"),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text("Kirim verifikasi ke email"),
          ),
        ],
      ),
    );
  }
}
