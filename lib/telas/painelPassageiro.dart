import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:teste/model/destino.dart';
import 'package:teste/model/requisicao.dart';
import 'package:teste/model/usuario.dart';
import 'package:teste/utils/statusRequisicao.dart';
import 'package:firebase_core/firebase_core.dart';

import '../utils/usuarioFirebase.dart';
class painelPassageiro extends StatefulWidget {
  const painelPassageiro({super.key});
  

  @override
  State<painelPassageiro> createState() => _painelPassageiroState();


  
}
 
class _painelPassageiroState extends State<painelPassageiro> {

TextEditingController _controllerDestino = TextEditingController(text: "av.paulista, 807");
Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =
   CameraPosition(target: LatLng(-23.563999 , -46.653256));
  Set<Marker> _marcadores = {};
  String? _idRequisicao;
  Position? _localPassageiro;
  Map<String, dynamic>? _dadosRequisicao;
  StreamSubscription<DocumentSnapshot>? _streamSubscriptionRequisicoes;
  
 Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
  
_onMapCreated(GoogleMapController controller){
  _controller.complete(controller);
}
Future<void> _recuperaUltimaLocalizacao() async {
  try {
    Position? position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    if (position != null) {
      setState(() {
        _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );
        _movimentaCamera(_posicaoCamera);
      });
    }
  } catch (e) {
    print("Error: $e");
  }
}

_movimentaCamera(CameraPosition cameraPosition) async{
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition)
    );
}

  
  _chamarUber(LatLng latLng) async {
   
    
  String enderecoDestino = _controllerDestino.text;
  if (enderecoDestino.isNotEmpty) {
    List<Placemark> listaEnderecos = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    if (listaEnderecos.isNotEmpty) {
      Placemark endereco = listaEnderecos[0];
      Destino destino = Destino();
      destino.cidade = endereco.administrativeArea;
      destino.cep = endereco.postalCode;
      destino.bairro = endereco.subLocality;
      destino.rua = endereco.thoroughfare;
      destino.numero = endereco.subThoroughfare;

      String enderecoConfirmacao;
      enderecoConfirmacao = "\n Cidade: ${destino.cidade}";
      enderecoConfirmacao += "\n Rua: ${destino.rua}, ${destino.numero}";
      enderecoConfirmacao += "\n Bairro: ${destino.bairro}";
      enderecoConfirmacao += "\n Cep: ${destino.cep}";

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirmação do endereço"),
              content: Text(enderecoConfirmacao),
            contentPadding: EdgeInsets.all(16),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text(
                  "Confirmar",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                 _salvarRequisicao();
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }
}


 
  _salvarRequisicao() async {
    
      Usuario passageiro = await UsuarioFirebase.getDadosUsuarioLogado();
      passageiro.latitude = _localPassageiro!.latitude;
      passageiro.longitude = _localPassageiro!.longitude;

      RequisicaoModel requisicao = RequisicaoModel(
       
        status: StatusRequisicao.AGUARDANDO,
      );

      FirebaseFirestore db = FirebaseFirestore.instance;

      // Salvar requisição
      await db.collection("requisicoes").doc(requisicao.id).set(requisicao.toMap());

      // Salvar requisição ativa
      Map<String, dynamic> dadosRequisicaoAtiva = {
        "id_requisicao": requisicao.id,
        "id_usuario": passageiro.idUsuario,
        "status": StatusRequisicao.AGUARDANDO,
      };

      await db.collection("requisicao_ativa").doc(passageiro.idUsuario).set(dadosRequisicaoAtiva);

      // Adicionar listener requisicao
    
  }

@override
void initState(){
  super.initState();
  _recuperaUltimaLocalizacao();
  _determinePosition();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _posicaoCamera,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            ),  Positioned(
              top: 0,
              left: 0,
              right: 0,
              child:  Padding(
                  padding: const EdgeInsets.all(20),
                      
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                   
                  
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Local Atual',
                    ),
                    
                  ),
                ),
                

            ),
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child:  Padding(
                   padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                   controller:_controllerDestino,
                  
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Destino',
                    ),
                    
                  ),
                ),
                

            ),
           
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(onPressed: 
                ( ) {
                  LatLng latLng = _posicaoCamera.target;

                  _chamarUber(latLng);
                }, child: Text('Acionar Veiculo')),
              )
            )
         ],
        )
            
      ),
    );
  }
}