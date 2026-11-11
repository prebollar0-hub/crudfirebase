import 'package:flutter/material.dart';

import '../services/firebase_services.dart';
import '../theme/app_theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> _futuro;
  final TextEditingController _busqueda = TextEditingController();
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _futuro = getUsuarios();
  }

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  void _recargar() {
    setState(() {
      _futuro = getUsuarios();
    });
  }

  void _aviso(String mensaje) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(mensaje)));
  }

  List<Map<String, dynamic>> _filtrar(List<Map<String, dynamic>> todos) {
    final q = _filtro.trim().toLowerCase();
    if (q.isEmpty) return List.of(todos);
    return todos.where((u) {
      return '${u['nombre']}'.toLowerCase().contains(q) ||
          '${u['email']}'.toLowerCase().contains(q) ||
          '${u['nocuenta']}'.toLowerCase().contains(q);
    }).toList();
  }

  // Navega a una página y recarga si devolvió true (guardado correcto).
  Future<void> _ir(String ruta, {Object? arguments, required String ok}) async {
    final resultado =
        await Navigator.pushNamed(context, ruta, arguments: arguments);
    if (!mounted) return;
    if (resultado == true) {
      _recargar();
      _aviso(ok);
    }
  }

  Future<bool> _confirmarBorrado(String nombre) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirmación',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('¿Estás seguro de querer eliminar a $nombre?'),
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
    return resultado ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBar(
        'Usuarios',
        actions: [
          IconButton(
            tooltip: 'Recargar',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _recargar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ir('/add', ok: 'Usuario agregado'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Agregar'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppTheme.gradiente,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: AppTheme.sombra,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.people_alt_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Gestión de usuarios',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Consulta, actualiza y administra tu base de datos.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppTheme.sombra,
                ),
                child: TextField(
                  controller: _busqueda,
                  onChanged: (v) => setState(() => _filtro = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, email o cuenta',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.primary),
                    suffixIcon: _filtro.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _busqueda.clear();
                              setState(() => _filtro = '');
                            },
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futuro,
                builder: (context, snapshot) {
                  Widget contenido;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    contenido = const Center(
                      key: ValueKey('cargando'),
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    contenido = _estado(
                      key: const ValueKey('error'),
                      icono: Icons.cloud_off_rounded,
                      titulo: 'No se pudo cargar',
                      detalle: '${snapshot.error}',
                    );
                  } else {
                    final todos = snapshot.data ?? [];
                    final lista = _filtrar(todos);

                    if (lista.isEmpty) {
                      contenido = _estado(
                        key: const ValueKey('vacio'),
                        icono: Icons.people_outline_rounded,
                        titulo: _filtro.isEmpty
                            ? 'Aún no hay usuarios'
                            : 'Sin resultados',
                        detalle: _filtro.isEmpty
                            ? 'Pulsa "Agregar" para crear el primero'
                            : 'Prueba con otra búsqueda',
                      );
                    } else {
                      contenido = RefreshIndicator(
                        key: const ValueKey('lista'),
                        color: AppColors.primary,
                        onRefresh: () async {
                          _recargar();
                          await _futuro;
                        },
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 90, top: 4),
                          itemCount: lista.length,
                          itemBuilder: (context, index) =>
                              _tarjeta(todos, lista[index], index),
                        ),
                      );
                    }
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: contenido,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estado({
    required Key key,
    required IconData icono,
    required String titulo,
    required String detalle,
  }) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icono, size: 44, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(titulo,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark)),
            const SizedBox(height: 6),
            Text(detalle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta(
      List<Map<String, dynamic>> todos, Map<String, dynamic> usuario, int index) {
    final String uid = usuario['uid'];
    final String nombre = usuario['nombre'];
    final String inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
    final String photoUrl = '${usuario['photoUrl'] ?? ''}';

    final retraso = (index.clamp(0, 8)) * 60;

    return TweenAnimationBuilder<double>(
      key: ValueKey('anim_$uid'),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + retraso),
      curve: Curves.easeOutCubic,
      builder: (context, valor, child) => Opacity(
        opacity: valor,
        child: Transform.translate(
          offset: Offset(0, (1 - valor) * 18),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.sombra,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Dismissible(
              key: ValueKey(uid),
              direction: DismissDirection.startToEnd,
              background: Container(
                color: AppColors.danger,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Eliminar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              confirmDismiss: (direction) => _confirmarBorrado(nombre),
              onDismissed: (direction) async {
                setState(() => todos.removeWhere((u) => u['uid'] == uid));
                try {
                  await deleteUsuario(uid);
                  if (mounted) _aviso('Usuario eliminado');
                } catch (e) {
                  if (!mounted) return;
                  _aviso('No se pudo eliminar: $e');
                  _recargar();
                }
              },
              child: Material(
                color: AppColors.surface,
                child: InkWell(
                  onTap: () => _ir(
                    '/edit',
                    ok: 'Usuario actualizado',
                    arguments: {
                      'uid': uid,
                      'nombre': usuario['nombre'],
                      'email': usuario['email'],
                      'nocuenta': usuario['nocuenta'],
                      'photoUrl': photoUrl,
                    },
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                      child: photoUrl.isEmpty ? Text(
                        inicial,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ) : null,
                    ),
                    title: Text(
                      nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${usuario['email']}\nCuenta: ${usuario['nocuenta']}',
                        style: const TextStyle(
                            color: AppColors.textMuted, height: 1.35),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            final confirmar = await _confirmarBorrado(nombre);
                            if (!confirmar) return;
                            try {
                              setState(() => todos.removeWhere((u) => u['uid'] == uid));
                              await deleteUsuario(uid);
                              if (mounted) _aviso('Usuario eliminado');
                            } catch (e) {
                              if (!mounted) return;
                              _aviso('No se pudo eliminar: $e');
                              _recargar();
                            }
                          },
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: AppColors.danger),
                          tooltip: 'Eliminar usuario',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}