// ignore_for_file: dead_code

import 'dart:convert';

import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifnews/componentes/card_noticia.dart';
import 'package:ifnews/estado.dart';
import 'package:ifnews/usuario.dart';
import 'package:ifnews/utils/autenticador.dart';
import 'package:toast/toast.dart';

class Noticias extends StatefulWidget {
  const Noticias({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EstadoNoticias();
  }
}

const int tamanhoDaPagina = 6;

class _EstadoNoticias extends State<Noticias> {
  late dynamic _feedDeNoticias;
  bool _carregando = false;
  List<dynamic> _noticias = [];

  final TextEditingController _controladorDoFiltro = TextEditingController();
  String _filtro = "";

  int _proximaPagina = 1;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);

    _lerFeedEstatico();
  }

  Future<void> _lerFeedEstatico() async {
    final String resposta =
        await rootBundle.loadString('lib/recursos/jsons/feed.json');
    _feedDeNoticias = await jsonDecode(resposta);

    _carregarNoticias();
  }

  void _carregarNoticias() {
    setState(() {
      _carregando = true;
    });

    if (_filtro.isNotEmpty) {
      _noticias = _noticias
          .where((noticia) =>
              noticia["noticia"]["titulo"].toLowerCase().contains(_filtro))
          .toList();
    } else {
      final totalDeNoticiasParaCarregar = _proximaPagina * tamanhoDaPagina;
      if (_feedDeNoticias["noticias"].length >= totalDeNoticiasParaCarregar) {
        _noticias =
            _feedDeNoticias["noticias"].sublist(0, totalDeNoticiasParaCarregar);
      }
    }

    setState(() {
      _carregando = false;
      _proximaPagina++;
    });
  }

  Future<void> _atualizarNoticias() async {
    _noticias = [];
    _proximaPagina = 1;

    _controladorDoFiltro.text = "";
    _filtro = "";

    _carregarNoticias();
  }

  void _aplicarFiltro(String filtro) {
    _filtro = filtro;

    _carregarNoticias();
  }

  @override
  Widget build(BuildContext context) {
    bool usuarioLogado = estadoApp.usuario != null;

    return _carregando
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(actions: [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 60, right: 20),
                      child: TextField(
                        controller: _controladorDoFiltro,
                        onSubmitted: (filtro) {
                          _aplicarFiltro(filtro);
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.search)),
                      ))),
              usuarioLogado
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          estadoApp.logout();
                        });

                        Toast.show("Você foi desconectado com sucesso!",
                            duration: Toast.lengthLong, gravity: Toast.bottom);
                      },
                      icon: const Icon(Icons.logout))
                  : IconButton(
                      onPressed: () async {
                        try {
                          Usuario? usuario = await Autenticador.login();
                          if (usuario != null) {
                            setState(() {
                              estadoApp.login(usuario);
                            });
                            Toast.show("Login bem-sucedido: ${usuario.nome}",
                                duration: Toast.lengthLong,
                                gravity: Toast.bottom);
                          } else {
                            Toast.show("Login cancelado pelo usuário.",
                                duration: Toast.lengthLong,
                                gravity: Toast.bottom);
                          }
                        } catch (e) {
                          Toast.show("Erro ao fazer login: ${e.toString()}",
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom);
                        }
                      },
                      icon: const Icon(Icons.login))
            ]),
            body: FlatList(
                data: _noticias,
                loading: _carregando,
                numColumns: 2,
                onRefresh: () => _atualizarNoticias(),
                onEndReached: () => _carregarNoticias(),
                buildItem: (item, index) {
                  return SizedBox(
                      height: estadoApp.altura * 0.45,
                      child: CardNoticia(noticia: item));
                }));
  }
}
