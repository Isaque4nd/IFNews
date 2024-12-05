import 'package:google_sign_in/google_sign_in.dart';
import '../usuario.dart';

class Autenticador {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<Usuario?> login() async {
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser != null) {
        return Usuario(gUser.displayName, gUser.email);
      }
    } catch (e) {
      throw Exception("Erro ao autenticar com Google: $e");
    }
    return null;
  }

  static Future<void> logout() async {
    await _googleSignIn.signOut();
  }

  static Future<Usuario?> recuperarUsuario() async {
    final GoogleSignInAccount? gUser = await _googleSignIn.signInSilently();
    if (gUser != null) {
      return Usuario(gUser.displayName, gUser.email);
    }
    return null;
  }
}
