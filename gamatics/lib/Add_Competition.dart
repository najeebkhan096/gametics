import 'package:flutter/material.dart';
import 'package:gamatics/form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'meet_name.dart';

class Add_competition extends StatefulWidget {
  static const routename = "add_competition";
  final String name;
  Add_competition({this.name});
  @override
  _Add_competitionState createState() => _Add_competitionState();
}

class _Add_competitionState extends State<Add_competition> {
  final _form = GlobalKey<FormState>();
  bool datepicked = false;
  String selected_value;
  DateTime date = DateTime.now();
  int selected_competition_location;
  List competition_location_list = [];
  TextEditingController name_controller = TextEditingController();
  TextEditingController Conpetitionlevel_controller = TextEditingController();
  TextEditingController Conpetition_location_controller =
      TextEditingController();

  Future get_competition_location_data() async {
    final response = await http.get(
        "http://hpsport.in/api/v3/get_competition_level.php?tag=fetchcompetitionlevel&LoggedinUserID=1");
    if (response.statusCode == 200) {
      var respoonsedata = response.body;
      var data = jsonDecode(respoonsedata);
      data = data['units_details'];

      for (var i in data) {
        competition_location_list.add(i['CompetitionLevelName']);
      }
      competition_location_list.forEach((element) {
        print(element);
      });
    } else {
      print(response.statusCode);
    }
  }

  Future<Null> selectDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1940),
      lastDate: DateTime(2022),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        print(date.toString());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_competition_location_data();
  }

  insert() async {
    var url =
        "http://www.hpsport.in/api/v3/put_new_competition_json.php?tag=retaincompetition";
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'USER': 'gamatics_api_key_v3',
        'KEY': '5b6e180b181a81f1ccbf0dc1e38aa843',
      },
      body: jsonEncode({
        "SportsID": 2,
        "LoggedInUserID": 1,
        "competitions_details": {
          "CompetitionID": 3600,
          "CompetitionName": name_controller.text,
          "CompetitionDescription": "test comp",
          "CompetitionStartDate": date.toString(),
          "CompetitionEndDate": "2021-01-23",
          "CompetitionLocation": Conpetition_location_controller.text,
          "CompetitionLevelID": selected_competition_location,
          "CompetitionLogo": ""
        }
      }),
    );
    print(response.body);

    Navigator.pushNamed(context, Form_screen.routename, arguments: {
      "CompName": name_controller.text,
      "CompLocation": Conpetition_location_controller.text,
      "CompetitionDate": date.toString(),
      "CompetitionLevel": selected_competition_location + 1,
    });
  }

  void _saveform() {
    final isvalid = _form.currentState.validate();

    if (!isvalid) {
      return;
    } else {
      _form.currentState.save();

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context).settings.arguments;
    name_controller.text = arg["name"];
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Composition"),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Competion/Meet Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(width: 0.4),
                ),
                elevation: 2,
                child: Container(
                    height: mediaquery.size.height * 0.09,
                    width: mediaquery.size.width * 0.40,
                    padding: EdgeInsets.only(left: 10, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Name"),
                      controller: name_controller,
                    )),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Competion/Meet Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(width: 0.4),
                ),
                elevation: 2,
                child: Container(
                  height: mediaquery.size.height * 0.09,
                  width: mediaquery.size.width * 0.40,
                  padding: EdgeInsets.only(left: 15, right: 12, top: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(datepicked
                          ? date.day.toString() +
                              " /" +
                              date.month.toString() +
                              " /" +
                              date.year.toString()
                          : "Select Competition Date"),
                      IconButton(
                        icon: Icon(
                          Icons.date_range,
                          color: Colors.lightBlueAccent,
                          size: 35,
                        ),
                        onPressed: () {
                          selectDatePicker(context);
                          setState(() {
                            datepicked = true;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Competion/Meet Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(width: 0.4),
                ),
                elevation: 2,
                child: Container(
                  height: mediaquery.size.height * 0.09,
                  width: mediaquery.size.width * 0.40,
                  padding: EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: Conpetition_location_controller,
                    decoration: InputDecoration(
                      hintText: "Location(City)",
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "invalid";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Competition Level",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Container(
                  height: mediaquery.size.height * 0.09,
                  width: mediaquery.size.width * 0.40,
                  padding: EdgeInsets.only(left: 15),
                  child: DropdownButton(
                    hint: Text(
                      "School/University",
                    ),
                    value: selected_competition_location,
                    onChanged: (value) {
                      setState(() {
                        selected_competition_location = value;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    isExpanded: true,
                    items: competition_location_list
                        .map((e) => DropdownMenuItem(
                            value: competition_location_list.indexOf(e),
                            child: Text(e)))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: mediaquery.size.height * 0.01,
              ),
              FlatButton(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                    side: BorderSide(color: Colors.teal, width: 1.3),
                  ),
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 35, top: 25, bottom: 25, right: 24),
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "Add Competition / Meet Result",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                onPressed: insert,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
