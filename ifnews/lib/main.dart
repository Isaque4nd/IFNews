import 'package:flutter/material.dart';
import 'package:ifnews/estado.dart';

import 'package:provider/provider.dart';

import 'telas/detalhes.dart';
import 'telas/noticias.dart';

void main() {
  runApp(const IFNews());
}

class IFNews extends StatelessWidget {
  const IFNews({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Estado(),
        child: MaterialApp(
          title: 'IFNews',
          theme: ThemeData(
              colorScheme: const ColorScheme.light(),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.blueGrey)),
          home: const TelaPrincipal(title: 'IFNews'),
        ));
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key, required this.title});

  final String title;

  @override
  State<TelaPrincipal> createState() => _EstadoTelaPrincipal();
}

class _EstadoTelaPrincipal extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    estadoApp = context.watch<Estado>();

    final media = MediaQuery.of(context);
    estadoApp.setDimensoes(media.size.height, media.size.width);

    Widget tela = const SizedBox.shrink();
    if (estadoApp.mostrandoNoticias()) {
      tela = const Noticias();
    } else if (estadoApp.mostrandoDetalhes()) {
      tela = const Detalhes();
    }

    return tela;
  }
}
