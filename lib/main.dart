import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/add_usuario_page.dart';
import 'pages/edit_usuario_page.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Firebase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      // Rutas con transición suave (fade + deslizamiento).
      // Los argumentos siguen disponibles con ModalRoute.of(context)!.settings.arguments
      onGenerateRoute: (settings) {
        late final Widget pagina;
        switch (settings.name) {
          case '/add':
            pagina = const AddUsuario();
            break;
          case '/edit':
            pagina = const EditUsuario();
            break;
          default:
            pagina = const Home();
        }

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 260),
          pageBuilder: (context, animation, secondaryAnimation) => pagina,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curva = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curva,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(curva),
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}