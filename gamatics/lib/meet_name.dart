import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gamatics/Add_Competition.dart';
import 'package:gamatics/form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Competition_name extends StatefulWidget {
  static const routename = "Competition_name";

  @override
  _Competition_nameState createState() => _Competition_nameState();
}

class _Competition_nameState extends State<Competition_name> {
  String get_select_value() {
    return selected_value;
  }

  Future get_competition_location_data() async {
    final response = await http.get(
        "http://hpsport.in/api/v3/get_competitions.php?tag=fetchcompetitions&SportsID=2&qLimit=50&qOffset=0&LoggedinUserID=1");
    if (response.statusCode == 200) {
      var respoonsedata = response.body;
      var data = jsonDecode(respoonsedata);
      data = data['competitions_details'];

      for (var i in data) {
        names.add(i['CompetitionName']);
      }
      names.forEach((element) {
        print(element);
      });
    } else {
      print(response.statusCode);
    }
  }

  List names = [];
  String selected_value;
  TextEditingController _controller = TextEditingController();
  bool filter = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_competition_location_data();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Gametics"),
      ),
      body: ListView(
        children: [
          Container(
            height: mediaquery.size.height * 0.09,
            width: mediaquery.size.width * 0.40,
            padding: EdgeInsets.only(left: 15),
            child: AutoCompleteTextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: "Search",
                  icon: Icon(Icons.search),
                  hintStyle: TextStyle(color: Colors.black)),
              suggestions: names,
              textChanged: (str) {
                setState(() {});
              },
              itemFilter: (item, query) {
                return item.toLowerCase().startsWith(query.toLowerCase());
              },
              clearOnSubmit: false,
              itemSorter: (a, b) {
                return a.compareTo(b);
              },
              itemSubmitted: (value) {
                selected_value = value;
              },
              itemBuilder: (context, item) {
                return ListTile(
                  title: Text(item,
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  leading: Icon(Icons.add_location),
                  onTap: () {
                    selected_value = item;
                    Navigator.pop(context, item);
                  },
                );
              },
            ),
          ),
          if (!names.contains(_controller.text) && _controller.text.isNotEmpty)
            ListTile(
              title: Text(_controller.text,
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              subtitle: Text("Did not find your competition"),
              leading: Icon(Icons.add_location),
              trailing: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, Add_competition.routename,
                      arguments: {"name": _controller.text});
                },
                child: Text("Add New"),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            )
        ],
      ),
    );
  }
}
