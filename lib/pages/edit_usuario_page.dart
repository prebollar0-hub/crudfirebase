import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/firebase_services.dart';
import '../theme/app_theme.dart';
import '../widgets/usuario_form.dart';

class EditUsuario extends StatelessWidget {
  const EditUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String uid = arguments['uid'] ?? '';
    final String photoUrl = arguments['photoUrl'] ?? '';

    Future<void> borrarUsuario() async {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Confirmación',
              style: TextStyle(fontWeight: FontWeight.w700)),
          content: const Text('¿Deseas eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar',
                  style: TextStyle(color: AppColors.textMuted)),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              child: const Text('Sí, eliminar'),
            ),
          ],
        ),
      );

      if (confirmar != true || uid.isEmpty) return;

      await deleteUsuario(uid);
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }

    return Scaffold(
      appBar: AppTheme.appBar(
        'Editar usuario',
        actions: [
          IconButton(
            tooltip: 'Eliminar usuario',
            onPressed: borrarUsuario,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: UsuarioForm(
        titulo: 'Editar usuario',
        subtitulo: 'Modifica los datos y guarda los cambios',
        textoBoton: 'Actualizar',
        iconoEncabezado: Icons.edit_rounded,
        nombreInicial: arguments['nombre'] ?? '',
        emailInicial: arguments['email'] ?? '',
        nocuentaInicial: arguments['nocuenta'] ?? '',
        fotoInicial: photoUrl,
        onSubmit: (nombre, email, nocuenta, {Uint8List? fotoBytes}) =>
            editUsuario(uid, nombre, email, nocuenta, photoBytes: fotoBytes),
      ),
    );
  }
}
