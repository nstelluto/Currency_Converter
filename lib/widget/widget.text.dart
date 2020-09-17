import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  String label = '';
  String prefixo = '';
  Function funcaoChanged;
  TextEditingController ctr;

  InputText({
    this.label,
    this.prefixo,
    this.funcaoChanged,
    this.ctr,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.ctr,
      onChanged: (value) {
        this.funcaoChanged();
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: this.label,
        labelStyle: TextStyle(color: Colors.amber),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber, width: 2.0),
        ),
        prefixText: this.prefixo,
      ),
      style: TextStyle(color: Colors.amber),
    );
  }
}
