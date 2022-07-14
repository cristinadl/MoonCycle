import 'dart:math';

import 'package:first_project/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {

  const Calendar({required this.toHighlight, Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();

  final List<DateTime> toHighlight;
}

extension MyDateExtension on DateTime {
  DateTime getDateOnly(){
    return DateTime.utc(this.year, this.month, this.day);
  }
}

class _CalendarState extends State<Calendar> {

  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime focusedDay = DateTime.now().getDateOnly();
  DateTime selectedDay = DateTime.now().getDateOnly();

  bool onPeriod = false;

  int avgPeriod = 28;
  int avgDuration = 5;
  int ovulation = 14;

  List<DateTime> predictedPeriod = [];
  List<DateTime> approximateOvulation = [];

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    ovulation = avgPeriod - ovulation;
    selectedEvents = {};
    super.initState();
  }


  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose(){
    _eventController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format){
                setState((){
                  format = _format;
                });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekVisible: true,

            // Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              //print(focusDay);
            },
            selectedDayPredicate: (DateTime date){
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            calendarBuilders: CalendarBuilders(
              markerBuilder: (BuildContext context, date, events) {
                if (events.isEmpty) return SizedBox();
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 0),
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          //height: 20,
                          width: 190,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.pink.withOpacity(0.5),
                          ),
                        ),
                      );
                    });
              },

              // sets the predicted dates
              rangeHighlightBuilder: (context, day, date) {
                for (DateTime d in predictedPeriod) {
                  if (day.day == d.day &&
                      day.month == d.month &&
                      day.year == d.year) {
                    return Container(
                      margin: const EdgeInsets.only(top: 0, bottom: 43),
                      padding: const EdgeInsets.only(left: 30, right: 0),
                      child: Container(
                        height: 100,
                        width: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.pink.withOpacity(0.5),
                        ),
                      ),
                    );
                  }
                }
                for (DateTime d in approximateOvulation) {
                  if (day.day == d.day &&
                      day.month == d.month &&
                      day.year == d.year) {
                    return Container(
                      margin: const EdgeInsets.only(top: 0, bottom: 43),
                      padding: const EdgeInsets.only(left: 30, right: 0),
                      child: Container(
                        height: 100,
                        width: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.teal.withOpacity(0.7),
                        ),
                      ),
                    );
                  }
                }
                return null;
              }
            ),




            // To style Calendar
            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.only(top: 0, bottom: 20, left: 30), // toFix : check library to work an all devices
              //markerDecoration: const BoxDecoration( color: Colors.black, shape: BoxShape.circle, ),
              tableBorder: TableBorder.all(color: Colors.black, width: 0.25, style: BorderStyle.solid, borderRadius: BorderRadius.horizontal(left: Radius.elliptical(5, 4),right: Radius.elliptical(5, 4))),
              //cellMargin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              isTodayHighlighted: true,
              todayTextStyle: const TextStyle(color: Colors.cyan),
              selectedTextStyle: const TextStyle(color: Colors.pink),
              selectedDecoration: BoxDecoration(
                border: Border.all(color: Colors.pinkAccent),
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              todayDecoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
              headerPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
            ),
          ),
          ..._getEventsfromDay(selectedDay).map((event) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height/20,
              width: MediaQuery.of(context).size.width/2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey)
              ),
              child: Center(
                  child: Text(event.title,
                    style: const TextStyle(color: Colors.blue,
                        fontWeight: FontWeight.bold,fontSize: 16),)
              ),
            ),
          )),
        ],
      ),
      //Other method
      /*
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddDialog(),
          label: const Text("Add Event"),
          icon: const Icon(Icons.add),
      ),
      */
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: () =>_showAddDialog(),
      ),
    );
  }

  _showAddDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Event"),
        content: TextField(
            controller:  _eventController
        ),
        actions: <Widget> [
          TextButton(
              child: Text("Ok",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              onPressed: () {
                if(_eventController.text.isEmpty) return;
                setState(() {
                  if(selectedEvents[selectedDay] != null){
                    onPeriod = false;
                    selectedEvents[selectedDay]?.add(Event(title:_eventController.text, isPeriod: true, notes: []));
                    print(selectedEvents);
                  }else{
                    selectedEvents[selectedDay] = [Event(title:_eventController.text, isPeriod: false, notes: [])];
                    erasePredictedPeriod(selectedDay);
                    fillPredictedPeriod(selectedDay);
                    onPeriod = true;
                  }
                  print(onPeriod);
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

  void erasePredictedPeriod(DateTime date){
    if(!onPeriod){
      approximateOvulation = [];
      predictedPeriod = [];
    }

  }

  void fillPredictedPeriod(DateTime date){
    if(!onPeriod){
      for(int i = 0; i < 12 ; i++){
        approximateOvulation.add(date.add(Duration(days: ovulation)));
        date = date.add(Duration(days: avgPeriod));
        for(int i = 0; i < avgDuration; i++){
          predictedPeriod.add(date);
          date = date.add(const Duration(days: 1));
        }
      }
    }
  }

}
