import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:taxi_segurito_app/components/dialogs/CustomShowDialog.dart';
import 'package:taxi_segurito_app/services/auth_service.dart';
import 'package:taxi_segurito_app/services/server.dart';
import 'widgets/ContainerListView.dart';
import 'package:taxi_segurito_app/components/inputs/CustomTextField.dart';

import 'package:taxi_segurito_app/components/inputs/CustomTextFieldArea.dart';

class MyHomePageForgetObject extends StatefulWidget {
  dynamic dynamicObject;
  MyHomePageForgetObject({Key? key}) : super(key: key);

  @override
  _ForgeObjects createState() => _ForgeObjects();
}

class _ForgeObjects extends State<MyHomePageForgetObject> {
  ContainerListView containerListView = new ContainerListView();
  Color colorMain = Color.fromRGBO(255, 193, 7, 1);

  CustomTextField txtNameObject = new CustomTextField(
    multiValidator: MultiValidator([
      RequiredValidator(errorText: "Nombre del objeto requerido"),
    ]),
    hint: "Nombre del Objeto",
    obscureText: false,
  );
  CustomTextFieldArea txtDescription = new CustomTextFieldArea(
    multiValidator: MultiValidator([
      RequiredValidator(errorText: "Descripción del objeto requerido"),
    ]),
    hint: "Descripción del objeto",
    maxLines: 5,
  );

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    //Image photo = Image.asset("lib/logoPrincipal.png");

    int idVehicle = 0;
    containerListView.setCallbak = (value) {
      idVehicle = value;
      print(value);
    };

    Future<bool> insertObjects() async {
      String path = "${Server.url}/forgetObjects/forgetobject_controller.php";
      int userId = await _authService.getCurrentId();
      final response;
      try {
        response = await http.post(Uri.parse(path),
            body: jsonEncode({
              "nameObject": txtNameObject.getValue(),
              "description": txtDescription.getValue(),
              "Vehicle_idVehicle": idVehicle,
              "clientuser_idclientuser": userId
            }));
        var res = response.body;
        if (res == '{"result":"1"}') {
          log("Exito");
          return true;
        } else {
          log("error: " + res);
          return false;
        }
      } catch (exception) {
        print(exception);
        return false;
      }
    }

    showDialog(String text, String content) {
      final dialog = CustomDialogShow(
        buttonText: 'Ok',
        context: context,
        buttonColor: Color.fromRGBO(255, 193, 7, 1),
        buttonColorText: Colors.white,
        titleShowDialog: text,
        message: content,
      );

      dialog.show();
    }

    Container contanierButtons = Container(
      margin:
          new EdgeInsets.only(top: 5.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
              color: Colors.white,
              textColor: colorMain,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () async {
                final success = await insertObjects();
                if (success) {
                  showDialog(
                    "Registro exitoso",
                    "Se ha registrado el objeto perdido.",
                  );
                }
              },
              child: Text("Insertar"),
              color: colorMain,
            ),
          ),
        ],
      ),
    );

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar objeto perdido'),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          child: Container(
              width: width,
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  txtNameObject,
                  txtDescription,
                  Text("Elija el vehÍculo donde se extravio el objeto"),
                  Expanded(
                    child: Container(child: containerListView),
                  ),
                  contanierButtons,
                ],
              )),
        ),
      ),
    );
  }
}
