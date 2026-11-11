import 'package:flutter/material.dart';

import 'dart:typed_data';

import '../services/firebase_services.dart';
import '../theme/app_theme.dart';
import '../widgets/usuario_form.dart';

class AddUsuario extends StatelessWidget {
  const AddUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBar('Agregar usuario'),
      body: UsuarioForm(
        titulo: 'Nuevo usuario',
        subtitulo: 'Completa los datos para guardarlo en Firestore',
        textoBoton: 'Guardar',
        iconoEncabezado: Icons.person_add_alt_1_rounded,
        onSubmit: (nombre, email, nocuenta, {Uint8List? fotoBytes}) =>
            agregarUsuario(nombre, email, nocuenta, photoBytes: fotoBytes),
      ),
    );
  }
}