import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Formulario compartido por "Agregar" y "Editar".
/// Al guardar con éxito cierra la página devolviendo `true`.
class UsuarioForm extends StatefulWidget {
  final String titulo;
  final String subtitulo;
  final String textoBoton;
  final IconData iconoEncabezado;
  final String nombreInicial;
  final String emailInicial;
  final String nocuentaInicial;
  final Future<void> Function(String nombre, String email, String nocuenta)
      onSubmit;

  const UsuarioForm({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.textoBoton,
    required this.iconoEncabezado,
    required this.onSubmit,
    this.nombreInicial = '',
    this.emailInicial = '',
    this.nocuentaInicial = '',
  });

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _email;
  late final TextEditingController _nocuenta;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.nombreInicial);
    _email = TextEditingController(text: widget.emailInicial);
    _nocuenta = TextEditingController(text: widget.nocuentaInicial);
  }

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _nocuenta.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_guardando) return;
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _guardando = true);

    try {
      await widget.onSubmit(_nombre.text, _email.text, _nocuenta.text);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _guardando = false);
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('No se pudo guardar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          builder: (context, valor, child) => Opacity(
            opacity: valor,
            child: Transform.translate(
              offset: Offset(0, (1 - valor) * 24),
              child: child,
            ),
          ),
          child: Column(
            children: [
              // Encabezado
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: AppTheme.gradiente,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.sombra,
                ),
                child: Icon(widget.iconoEncabezado,
                    color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                widget.titulo,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitulo,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),

              // Tarjeta del formulario
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.sombra,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nombre,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: AppTheme.campo(
                            'Nombre', Icons.person_outline_rounded),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Escribe el nombre'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration:
                            AppTheme.campo('Email', Icons.mail_outline_rounded),
                        validator: (v) {
                          final texto = v?.trim() ?? '';
                          if (texto.isEmpty) return 'Escribe el email';
                          final valido =
                              RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(texto);
                          return valido ? null : 'Email no válido';
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nocuenta,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _enviar(),
                        decoration: AppTheme.campo(
                            'No. cuenta', Icons.badge_outlined),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Escribe el número de cuenta'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _guardando ? null : _enviar,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: _guardando
                                ? const SizedBox(
                                    key: ValueKey('cargando'),
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    widget.textoBoton,
                                    key: const ValueKey('texto'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}