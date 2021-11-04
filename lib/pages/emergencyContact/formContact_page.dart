import 'package:flutter/material.dart';
import 'package:taxi_segurito_app/pages/emergencyContact/formContact_functionality.dart';

class FormContact_Page extends StatefulWidget 
{
  dynamic _dataContact;

  FormContact_Page();
  FormContact_Page.update(this._dataContact); //Aux para pasar datos de contacto

  _FormState createState() => _FormState(_dataContact);
}

class _FormState extends State<FormContact_Page> {

  dynamic _dataContact;//Aux para recibir datos de contacto
  _FormState(this._dataContact); //Aux para pasar datos de contacto
 
  FormContact_Functionality formContact_Functionality = new FormContact_Functionality();
  var aux; //Para esperar la respuesta del futureBuilder
  var isSession;

  @override
  void initState()
  {
    LoadData_Function();
  }

  void LoadData_Function() async
  {
    isSession = await formContact_Functionality.CheckID(); //Revisa si hay sesion,
    if(isSession && _dataContact!=null) // Si estamos haciendo un insert
    { 
      formContact_Functionality.contactName_Controller.text = _dataContact['nameContact'];
      formContact_Functionality.contactNumber_Controller.text = _dataContact['number'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: (_dataContact == null) ?Text("Registrar contacto"):Text("Editar contacto"),
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ));
            },
          ),
        ),
      body: SingleChildScrollView(
        child : Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 20.0),
        child:Column(
            children: <Widget>[
              //Inputs
              TextField(
                controller: formContact_Functionality.contactName_Controller,
                decoration: InputDecoration(
                  hintText: "  Apodo del contacto",
                  icon: const Icon(
                            Icons.person_outline,
                            size: 35,
                          ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20,bottom: 20),
                child :
              TextField(
                controller: formContact_Functionality.contactNumber_Controller,
                decoration: InputDecoration(
                  hintText: "  Numero del contacto",
                  icon: const Icon(
                            Icons.phone,
                            size: 35,
                          ),
                ),
              ),
              ),
              Padding(padding: EdgeInsets.only(top: 30.0)),
              ElevatedButton(
                child: (_dataContact == null) ?Text(
                  "Agregar contacto",
                  style: TextStyle(fontSize: 20)
                  ):Text(
                  "Editar contacto",
                  style: TextStyle(fontSize: 20)
                  )
                  ,
                onPressed: (){
                  if(_dataContact == null) // Si estamos haciendo un INSERT
                  {
                    formContact_Functionality.InsertContact_Function(context);
                  }
                  else                  // Si estamos haciendo un UPDATE
                  {
                    formContact_Functionality.EditContact_Function(context,_dataContact['idEmergencyContact']);
                  }
                },
              ),

            ],
          ),
         ),
        ),


      );
  }
}