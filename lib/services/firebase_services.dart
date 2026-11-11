import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<String> uploadProfileImage(String uid, Uint8List imageBytes) async {
  final storageRef = FirebaseStorage.instance.ref().child('usuarios/$uid/perfil.jpg');
  final task = await storageRef.putData(
    imageBytes,
    SettableMetadata(contentType: 'image/jpeg'),
  );
  return task.ref.getDownloadURL();
}

Future<List<Map<String, dynamic>>> getUsuarios() async {
  final query = await db.collection('usuarios').get();

  final usuarios = query.docs.map((documento) {
    final data = documento.data();
    return {
      'uid': documento.id,
      'nombre': data['nombre'] ?? '',
      'email': data['email'] ?? '',
      'nocuenta': data['nocuenta'] ?? '',
      'photoUrl': data['photoUrl'] ?? '',
    };
  }).toList();

  usuarios.sort((a, b) => (a['nombre'] as String)
      .toLowerCase()
      .compareTo((b['nombre'] as String).toLowerCase()));

  return usuarios;
}

Future<void> agregarUsuario(
  String nombre,
  String email,
  String cuenta, {
  Uint8List? photoBytes,
}) async {
  final docRef = await db.collection('usuarios').add({
    'nombre': nombre.trim(),
    'email': email.trim(),
    'nocuenta': cuenta.trim(),
  });

  if (photoBytes != null) {
    final photoUrl = await uploadProfileImage(docRef.id, photoBytes);
    await docRef.update({'photoUrl': photoUrl});
  }
}

Future<void> editUsuario(
  String uid,
  String nombre,
  String email,
  String cuenta, {
  Uint8List? photoBytes,
}) async {
  final data = {
    'nombre': nombre.trim(),
    'email': email.trim(),
    'nocuenta': cuenta.trim(),
  };

  if (photoBytes != null) {
    final photoUrl = await uploadProfileImage(uid, photoBytes);
    data['photoUrl'] = photoUrl;
  }

  await db.collection('usuarios').doc(uid).update(data);
}

Future<void> deleteUsuario(String uid) async {
  await db.collection('usuarios').doc(uid).delete();
}
