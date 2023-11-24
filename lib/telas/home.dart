import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teste/telas/cadastro.dart';
import 'package:teste/telas/painelPassageiro.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

TextEditingController _controllerEmail = TextEditingController();
TextEditingController _controllerSenha = TextEditingController();
 final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();


class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SingleChildScrollView(
      child: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: Image.asset(
                'assets/logo.png',
                width: 200,
                height: 150,
              ),
            ),
           Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 20, bottom: 10),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    controller:
                     _controllerEmail,
                  
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Login',
                      hintText: 'Digite o Login',
                    ),
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    //  textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller:
                       _controllerSenha,
                   
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                        hintText: 'Digite a Senha'),
                   
                  ),
                ),


            Padding(padding: EdgeInsets.only(top: 16 , bottom: 10),
            child: ElevatedButton(onPressed: (){
             Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => painelPassageiro()));
              },
            child: Text('Entrar')),
            ),

                ElevatedButton(onPressed: (){
             Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => cadastro()));
              },
            child: Text('Cadastrar')),


          ],
        ),
      )),
    ));
  }
}
