class Usuario {

  String? _nome;
  String? get nome => _nome;

  String? _email;
  String? get email => _email;

  Usuario(String? nome, String? email) {
    _email = email;
    _nome = nome;
  }
  
}