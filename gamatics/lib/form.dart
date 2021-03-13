import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gamatics/Add_composition_Button.dart';
import 'package:flutter/material.dart';
import 'package:gamatics/Add_Competition.dart';
import 'package:gamatics/upload_image.dart';
import 'package:provider/provider.dart';
import 'upload_image.dart';

import 'meet_name.dart';

class Form_screen extends StatefulWidget {
  static const routename = "Form_screen";

  @override
  _Form_screenState createState() => _Form_screenState();
}

class _Form_screenState extends State<Form_screen> {
  @override
  List<String> rank_position = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  Future get_distance_data() async {
    final response = await http.get(
        "http://hpsport.in/api/v3/get_measurement_units.php?tag=fetchunits&measuringtype=Distance&LoggedinUserID=1");
    if (response.statusCode == 200) {
      var respoonsedata = response.body;
      var data = jsonDecode(respoonsedata);
      data = data['units_details'];

      for (var i in data) {
        distance.add(i['UnitsCode']);
      }
      distance.forEach((element) {
        print(element);
      });
    } else {
      print(response.statusCode);
    }
  }

  Future get_event_data() async {
    final response = await http.get(
        "http://hpsport.in/api/v3/get_sports_events.php?tag=fetchsportevents&SportsID=2&LoggedinUserID=1");
    if (response.statusCode == 200) {
      var respoonsedata = response.body;
      var data = jsonDecode(respoonsedata);
      data = data['sports_events_details'];

      for (var i in data) {
        event_items.add(i['SportsEventName']);
      }
      event_items.forEach((element) {
        print(element);
      });
    } else {
      print(response.statusCode);
    }
  }

  Future get_Qualification_data() async {
    final response = await http.get(
        "http://hpsport.in/api/v3/get_sports_event_types.php?tag=fetcheventtype&SportsID=2&LoggedinUserID=1");
    if (response.statusCode == 200) {
      var respoonsedata = response.body;
      var data = jsonDecode(respoonsedata);
      data = data['sports_event_types_details'];

      for (var i in data) {
        Qualification_items.add(i['EventTypeName']);
      }
      Qualification_items.forEach((element) {
        print(element);
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    get_event_data();
    get_Qualification_data();
    get_distance_data();
  }

  final _form = GlobalKey<FormState>();
  String compName = "";
  String selected_distance_unit;
  List event_items = [];
  List distance = [];
  List Qualification_items = [];
  bool turn = true;
  String rank_value;
  String selected_quali;
  String selected_event;
  bool checkboxvalue = false;

  void _saveform() {
    final isvalid = _form.currentState.validate();

    if (!isvalid) {
      return;
    } else {
      _form.currentState.save();
      Navigator.of(context).pushNamed(Add_competition.routename);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    if (data != null) {
      compName = data["CompName"];
    }
    print("Data on form screen: " + data.toString());
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Performance"),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 25),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                "Competition/Meet Name",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            //Name
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
                    controller: TextEditingController(text: compName),
                    decoration: InputDecoration(hintText: "Name"),
                    onTap: () async {
                      var selectedItem = await Navigator.pushNamed(
                          context, Competition_name.routename);
                      if (selectedItem != null)
                        setState(() {
                          compName = selectedItem.toString();
                          print(compName);
                        });
                    },
                  )),
            ),

            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            //Event
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
                    "Event",
                  ),
                  value: selected_event,
                  onChanged: (value) {
                    setState(() {
                      selected_event = value;
                      if (value == "1000m") {
                        turn = false;
                      } else {
                        turn = true;
                      }
                    });
                  },
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  isExpanded: true,
                  items: event_items
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
              ),
            ),

            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            turn
                ?
                //Result/Time
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Result/Time",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: mediaquery.size.height * 0.007,
                      ),
                      Row(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Container(
                              height: mediaquery.size.height * 0.09,
                              width: mediaquery.size.width * 0.20,
                              padding: EdgeInsets.only(left: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "HR",
                                  hintStyle: TextStyle(
                                      color: Colors.black87, fontSize: 13),
                                  border: InputBorder.none,
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                onSaved: (value) {
                                  setState(() {});
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "invalid";
                                  }
                                  if (int.parse(value) < 1) {
                                    return "Invalid";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Container(
                              height: mediaquery.size.height * 0.09,
                              width: mediaquery.size.width * 0.20,
                              padding: EdgeInsets.only(left: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Min",
                                  hintStyle: TextStyle(
                                      color: Colors.black87, fontSize: 13),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "0:59";
                                  }
                                  if (int.parse(value) >= 60 ||
                                      int.parse(value) < 1) {
                                    return "0:59";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Container(
                              height: mediaquery.size.height * 0.09,
                              width: mediaquery.size.width * 0.20,
                              padding: EdgeInsets.only(left: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "SEC",
                                  hintStyle: TextStyle(
                                      color: Colors.black87, fontSize: 13),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                  ),
                                  border: InputBorder.none,
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "0:59";
                                  }
                                  if (int.parse(value) >= 60 ||
                                      int.parse(value) < 1) {
                                    return "0:59";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Container(
                              height: mediaquery.size.height * 0.09,
                              width: mediaquery.size.width * 0.20,
                              padding: EdgeInsets.only(left: 15),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "MS",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.black87, fontSize: 13),
                                  errorStyle: TextStyle(
                                    color: Colors.red,
                                  ),
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
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Result/Distance",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: mediaquery.size.height * 0.007,
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: Row(
                            children: [
                              Container(
                                height: mediaquery.size.height * 0.09,
                                width: mediaquery.size.height * 0.2,
                                padding: EdgeInsets.only(left: 15),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Distance",
                                    hintStyle: TextStyle(
                                        color: Colors.black87, fontSize: 13),
                                    border: InputBorder.none,
                                    errorStyle: TextStyle(
                                      color: Colors.red,
                                    ),
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
                              Container(
                                  height: mediaquery.size.height * 0.09,
                                  width: mediaquery.size.height * 0.2,
                                  child: DropdownButton(
                                    value: selected_distance_unit,
                                    onChanged: (value) {
                                      setState(() {
                                        selected_distance_unit = value;
                                      });
                                    },
                                    icon: Icon(Icons.arrow_drop_down),
                                    isExpanded: true,
                                    items: distance
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList(),
                                  )),
                            ],
                          )),
                    ],
                  ),

            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            //Rank/Position
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Rank /Position",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            //Select Ranking
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
                  hint: Text("Select Ranking"),
                  value: rank_value,
                  onChanged: (value) {
                    setState(() {
                      rank_value = value;
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  items: rank_position
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
              ),
            ),

            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            //Resluts In

            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Results In",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            //Qualification
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
                    "Qualifications",
                  ),
                  value: selected_quali,
                  onChanged: (value) {
                    setState(() {
                      selected_quali = value;
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  isExpanded: true,
                  items: Qualification_items.map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
              ),
            ),

            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            //Checkbox
            Row(
              children: [
                Checkbox(
                  value: checkboxvalue,
                  onChanged: (bool value) {
                    setState(
                      () {
                        checkboxvalue = value;
                      },
                    );
                  },
                  activeColor: Colors.white,
                  checkColor: Colors.teal,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Is this a record?"),
              ],
            ),

            SizedBox(
              height: mediaquery.size.height * 0.007,
            ),

            checkboxvalue
                ? Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: Container(
                      height: mediaquery.size.height * 0.09,
                      width: mediaquery.size.width * 0.40,
                      padding: EdgeInsets.only(left: 15),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "National/State Meet Record (NMR/SMR)",
                          hintStyle:
                              TextStyle(color: Colors.black87, fontSize: 13),
                          errorStyle: TextStyle(
                            color: Colors.red,
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.black12,
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
                  )
                : Text(""),

            //Athlete Comments
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Athlete Comments",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText:
                        "Jot down your memories and info about this event on record",
                    hintStyle: TextStyle(color: Colors.black87, fontSize: 13),
                    errorStyle: TextStyle(
                      color: Colors.red,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black12,
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
              height: mediaquery.size.height * 0.007,
            ),

            Upload_image(),
            SizedBox(
              height: mediaquery.size.height * 0.008,
            ),
            Add_Competition_Button(_saveform),
          ],
        ),
      ),
    );
  }
}
