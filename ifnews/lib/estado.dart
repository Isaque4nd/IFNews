import 'package:flutter/material.dart';
import 'package:ifnews/usuario.dart';

enum Situacao { mostrandoNoticias, mostrandoDetalhes }

class Estado extends ChangeNotifier {
  void login(Usuario? usuario) {
    _usuario = usuario;

    notifyListeners();
  }

  void logout() {
    _usuario = null;

    notifyListeners();
  }


  Situacao _situacao = Situacao.mostrandoNoticias;

  double _altura = 0, _largura = 0;
  double get altura => _altura;
  double get largura => _largura;

  late int _idNoticia;
  int get idNoticia => _idNoticia;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  void setDimensoes(double altura, double largura) {
    _altura = altura;
    _largura = largura;
  }

  void mostrarNoticias() {
    _situacao = Situacao.mostrandoNoticias;

    notifyListeners();
  }

  bool mostrandoNoticias() {
    return _situacao == Situacao.mostrandoNoticias;
  }

  void mostrarDetalhes(int idNoticia) {
    _situacao = Situacao.mostrandoDetalhes;
    _idNoticia = idNoticia;

    notifyListeners();
  }

  bool mostrandoDetalhes() {
    return _situacao == Situacao.mostrandoDetalhes;
  }
}

late Estado estadoApp;
