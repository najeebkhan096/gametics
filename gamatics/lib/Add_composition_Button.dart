import 'package:flutter/material.dart';


class Add_Competition_Button extends StatelessWidget {
  final Function _saveform;
  Add_Competition_Button(@required this._saveform);



  @override
  Widget build(BuildContext context) {

    return  FlatButton(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
          side: BorderSide(color: Colors.teal, width: 1.3),
        ),
        color: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 30, top: 17, bottom: 15, right: 20),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              "Add Competition / Meet Result",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      onPressed: _saveform,
    );
  }
}
