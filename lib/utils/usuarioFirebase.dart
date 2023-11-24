import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:teste/model/usuario.dart';
import 'package:firebase_core/firebase_core.dart';


class UsuarioFirebase {
  static Future<User?> getUsuarioAtual() async {
   WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Erro ao inicializar o Firebase: $e");
  }

  WidgetsFlutterBinding.ensureInitialized();
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  static Future<Usuario> getDadosUsuarioLogado() async {
    User? firebaseUser = await getUsuarioAtual();

    if (firebaseUser != null) {
      String idUsuario = firebaseUser.uid;

      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentSnapshot snapshot = await db.collection("usuarios").doc(idUsuario).get();

      Map<String, dynamic>? dados = snapshot.data() as Map<String, dynamic>?;

      if (dados != null) {
        String tipoUsuario = dados["tipoUsuario"];
        String email = dados["email"];
        String nome = dados["nome"];

        Usuario usuario = Usuario();
        usuario.idUsuario = idUsuario;
        usuario.tipoUsuario = tipoUsuario;
        usuario.email = email;
        usuario.nome = nome;

        return usuario;
      } else {
        throw Exception("Usuário não encontrado no banco de dados");
      }
    } else {
      throw Exception("Usuário não autenticado");
    }
  }

  static atualizarDadosLocalizacao(String idRequisicao, double lat, double lon, String tipo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Usuario usuario = await getDadosUsuarioLogado();

    usuario.latitude = lat;
    usuario.longitude = lon;

    await db.collection("requisicoes").doc(idRequisicao).update({
      tipo: usuario.toMap(),
    });
  }
}
