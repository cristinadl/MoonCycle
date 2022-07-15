import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    _eventController.dispose();
    super.dispose();
  }

  late String today = DateFormat.yMMMMd().format(DateTime.now().getDateOnly());
  late bool onPeriod = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right:30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  today,
                  style:  const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: FittedBox(
                    child: FloatingActionButton.extended(
                      label: const Text("Add Event"),
                      icon: const Icon(Icons.add),
                      backgroundColor: Colors.blue,
                      onPressed: () =>_showAddDialog()
                    ),
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Calendar"),
        content:  const SizedBox( // toFix: check to change to FittedBox to mantain the same size
          height: 2000,
          width: 1000,
          //padding: const EdgeInsets.only(top:0),
          child: Calendar(),
        ),
        actions: <Widget> [
          TextButton(
              child: Text("Ok",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              onPressed: () {
                if(_eventController.text.isEmpty) return;
                setState(() {
                  onPeriod = true;
                  _eventController.clear();
                  Navigator.pop(context);
                  //print(predictedPeriod);
                });
              }

          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}


