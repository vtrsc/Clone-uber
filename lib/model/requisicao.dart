import 'dart:convert';

import 'package:teste/model/destino.dart';

class RequisicaoModel {
  String? id;
  String? status;
  UsuarioModel? passageiro;
  UsuarioModel? motorista;
  DestinoModel? destino;
  CepCorreiosModel? enderecoDestino;

  RequisicaoModel({
    this.id,
    this.status,
    this.passageiro,
    this.motorista,
    this.destino,
    this.enderecoDestino,
     
  });

  factory RequisicaoModel.fromMap(Map<String, dynamic> map) {
    return RequisicaoModel(
      id: map['id'],
      status: map['status'],
      passageiro: UsuarioModel.fromMap(map['passageiro']),
      motorista: UsuarioModel.fromMap(map['motorista']),
      destino: DestinoModel.fromMap(map['destino']),
      enderecoDestino: CepCorreiosModel.fromMap(map['enderecoDestino']), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'passageiro': passageiro?.toMap(),
      'motorista': motorista?.toMap(),
      'destino': destino?.toMap(),
      'enderecoDestino': enderecoDestino?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());
}

class UsuarioModel {
  String? nome;
  String? email;
  String? tipoUsuario;
  String? idUsuario;
  double? latitude;
  double? longitude;

  UsuarioModel({
    this.nome,
    this.email,
    this.tipoUsuario,
    this.idUsuario,
    this.latitude,
    this.longitude,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      nome: map['nome'],
      email: map['email'],
      tipoUsuario: map['tipoUsuario'],
      idUsuario: map['idUsuario'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'tipoUsuario': tipoUsuario,
      'idUsuario': idUsuario,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class DestinoModel {
  String? rua;
  String? numero;
  String? bairro;
  String? cep;
  double? latitude;
  double? longitude;

  DestinoModel({
    this.rua,
    this.numero,
    this.bairro,
    this.cep,
    this.latitude,
    this.longitude,
  });

  factory DestinoModel.fromMap(Map<String, dynamic> map) {
    return DestinoModel(
      rua: map['rua'],
      numero: map['numero'],
      bairro: map['bairro'],
      cep: map['cep'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cep': cep,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class CepCorreiosModel {
  String? uf;
  String? localidade;
  String? logradouroDNEC;
  String? complemento;
  String? bairro;
  String? cep;

  CepCorreiosModel({
    this.uf,
    this.localidade,
    this.logradouroDNEC,
    this.complemento,
    this.bairro,
    this.cep,
  });

  factory CepCorreiosModel.fromMap(Map<String, dynamic> map) {
    return CepCorreiosModel(
      uf: map['uf'],
      localidade: map['localidade'],
      logradouroDNEC: map['logradouro'],
      complemento: map['complemento'],
      bairro: map['bairro'],
      cep: map['cep'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uf': uf,
      'localidade': localidade,
      'logradouro': logradouroDNEC,
      'complemento': complemento,
      'bairro': bairro,
      'cep': cep,
    };
  }
}
