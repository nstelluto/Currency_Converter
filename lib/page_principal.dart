import 'dart:convert';

import 'package:aula09/widget/widget.text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeCotacao extends StatefulWidget {
  @override
  _HomeCotacaoState createState() => _HomeCotacaoState();
}

class _HomeCotacaoState extends State<HomeCotacao> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double cotacaoDolar;
  double cotacaoEuro;

  Future<Map> consultaCotacao() async {
    http.Response response = await http.get(
        'https://api.hgbrasil.com/finance/?format=json-cors&key=development');

    this.cotacaoDolar =
        jsonDecode(response.body)['results']['currencies']['USD']['buy'];
    this.cotacaoEuro =
        jsonDecode(response.body)['results']['currencies']['EUR']['buy'];

    return json.decode(response.body);
  }

  void _limparCampos() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
  }

  void _realAlterado() {
    double vReal = double.parse(realController.text);
    dolarController.text = (vReal / this.cotacaoDolar).toStringAsFixed(2);
    euroController.text = (vReal / this.cotacaoEuro).toStringAsFixed(2);
  }

  void _dolarAlterado() {
    double vDolar = double.parse(dolarController.text);
    realController.text = (vDolar * this.cotacaoDolar).toStringAsFixed(2);
    euroController.text =
        (vDolar * this.cotacaoDolar / this.cotacaoEuro).toStringAsFixed(2);
  }

  void _euroAlterado() {
    double vEuro = double.parse(euroController.text);
    realController.text = (vEuro * this.cotacaoEuro).toStringAsFixed(2);
    dolarController.text =
        (vEuro * this.cotacaoEuro / this.cotacaoDolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('\$ Conversor de Moedas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              consultaCotacao();
              final snackBar = SnackBar(
                content: Text(
                  'Atualizando Cotações...',
                  style: TextStyle(color: Colors.black),
                ),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.amber,
                action: SnackBarAction(
                  label: 'FECHAR',
                  textColor: Colors.black,
                  onPressed: () {},
                ),
              );
              _scaffoldKey.currentState.showSnackBar(snackBar);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {},
        child: FutureBuilder<Map>(
          future: consultaCotacao(),
          builder: (BuildContext contex, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ),
                    Divider(),
                    Center(
                      child: Text(
                        'carregando Cotação...',
                        style: TextStyle(color: Colors.amber, fontSize: 18),
                      ),
                    ),
                  ],
                );
                break;
              default:
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text(
                        'Ocorreu um erro ao carregar: \n' +
                            snapshot.error.toString(),
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: Colors.amber,
                          size: 100.0,
                        ),
                        Divider(),
                        InputText(
                          label: 'Real',
                          prefixo: 'R\$ ',
                          funcaoChanged: this._realAlterado,
                          ctr: realController,
                        ),
                        Divider(),
                        InputText(
                          label: 'Dólar',
                          prefixo: 'U\$\$ ',
                          funcaoChanged: this._dolarAlterado,
                          ctr: dolarController,
                        ),
                        Divider(),
                        InputText(
                          label: 'Euro',
                          prefixo: '€ ',
                          funcaoChanged: this._euroAlterado,
                          ctr: euroController,
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _limparCampos();
          final snackBar = SnackBar(
            content: Text(
              'Campos limpos com sucesso!',
              style: TextStyle(color: Colors.black),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.amber,
            action: SnackBarAction(
              label: 'FECHAR',
              textColor: Colors.black,
              onPressed: () {},
            ),
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        },
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        child: Icon(Icons.clear),
      ),
    );
  }
}
