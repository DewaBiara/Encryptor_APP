import 'dart:convert';
import 'package:app_login/blocs/bloc/auth_bloc.dart';
import 'package:app_login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pointycastle/export.dart' as pc;

class Decryption extends StatefulWidget {
  const Decryption({Key? key}) : super(key: key);

  @override
  State<Decryption> createState() => _DecryptionState();
}

class _DecryptionState extends State<Decryption> {
  final TextEditingController cipherText = TextEditingController();
  final TextEditingController keyController = TextEditingController();
  String decryptedText = '';

  String encryptAes(String plainText, String key) {
    final keyParam = pc.KeyParameter(utf8.encode(key));
    final paddedParams = pc.PaddedBlockCipherParameters(keyParam, null);
    final cipher = pc.PaddedBlockCipher('AES/PKCS7')
      ..init(true, paddedParams);

    final input = utf8.encode(plainText);
    final output = cipher.process(input);

    return base64.encode(output);
  }

  String decryptAes(String cipherText, String key) {
    final keyParam = pc.KeyParameter(utf8.encode(key));
    final paddedParams = pc.PaddedBlockCipherParameters(keyParam, null);
    final cipher = pc.PaddedBlockCipher('AES/PKCS7')
      ..init(false, paddedParams);

    final input = base64.decode(cipherText);
    final output = cipher.process(input);

    return utf8.decode(output);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decryption'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(Logout());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: cipherText,
              decoration: const InputDecoration(
                labelText: 'Ciphertext',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Key',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String key = keyController.text;
                String cipherTextValue = cipherText.text;
                setState(() {
                  decryptedText = decryptAes(cipherTextValue, key);
                });
              },
              child: const Text('Decrypt Text'),
            ),
            const SizedBox(height: 16.0),
            Text('Decrypted Text: $decryptedText'),
          ],
        ),
      ),
    );
  }
}