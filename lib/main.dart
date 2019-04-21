import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(RootView());
List<TimeSnap> lapTimes = List();

class RootView extends StatefulWidget {
  @override
  State createState() {
    return RootViewState();
  }
}

//main widget
class RootViewState extends State<RootView> {
  int hours = 0, min = 0, sec = 0, milliSec = 0;
  Timer timer;
  bool isActive = false;

  //function to update hours, mins, sec, millisec
  void handleTimer() {
    if (isActive) {
      setState(() {
        if (milliSec == 99) {
          milliSec = 0;
          if (sec == 59) {
            sec = 0;
            if (min == 59) {
              min = 0;
              ++hours;
            } else {
              ++min;
            }
          } else {
            ++sec;
          }
        } else {
          ++milliSec;
        }
      });
    }
  }

  @override
  void initState() {
    //handleTimer gets called for every 1ms
    timer = Timer.periodic(Duration(milliseconds: 1), (Timer) {
      handleTimer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Stop Watch'),
            ),
            body: Container(
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment(0, -0.9),
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 5)),
                        child: Center(
                            child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClockText(hours, 40),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ClockText(min, 35),
                                  ClockText(sec, 30),
                                  ClockText(milliSec, 25),
                                ],
                              ),
                            ),
                          ],
                        )),
                      )),
                  Align(
                    alignment: Alignment(0, 0.3),
                    child: Container(
                      width: 250,
                      height: 200,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      child: ListView.builder(

                          itemBuilder: (context, position) {
                            return Card(
                              child: LapTimeWidget(
                                  time: lapTimes[position].getTime()),
                            );
                          },
                          itemCount: lapTimes.length),
                    ),
                  ),
                  //Reset  Button
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, bottom: 20),
                      child: RaisedButton(
                          color: Colors.black,
                          child: Text("Reset",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          onPressed: () {
                            setState(() {
                              lapTimes.clear();
                              isActive = false;
                              milliSec = 0;
                              sec = 0;
                              min = 0;
                              hours = 0;
                            });
                          }),
                    ),
                  ),
                  //Lap Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 20, bottom: 20),
                      child: RaisedButton(
                          color: Colors.black,
                          child: Text("Lap",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          onPressed: () {
                            TimeSnap temp = TimeSnap(
                                hours: hours,
                                min: min,
                                sec: sec,
                                millisec: milliSec);
                            lapTimes.add(temp);
                            debugPrint(temp.getTime());
                          }),
                    ),
                  ),
                  //Start Button
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          margin:
                              EdgeInsets.only(bottom: 20, left: 20, right: 20),
                          child: RaisedButton(
                              color: Colors.black,
                              child: Text(isActive ? "Stop" : "Start",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              onPressed: () {
                                setState(() {
                                  isActive = !isActive;
                                });
                              }))),
                ],
              ),
            )));
  }
}

//widget for Text inside the clock
class ClockText extends StatelessWidget {
  String value;
  double fontSize;

  ClockText(int value, double fontSize) {
    this.fontSize = fontSize;
    if (value >= 0 && value <= 9) {
      this.value = "0" + '$value';
    } else {
      this.value = '$value';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ));
  }
}

//Plain Old Flutter Object
class TimeSnap {
  int millisec;
  int sec;
  int min;
  int hours;

  TimeSnap({this.hours, this.min, this.sec, this.millisec});

  String getTime() {
    if (hours == 0) {
      return '$min' + " : " + '$sec' + " : " + '$millisec';
    } else {
      return '$hours' + " : " + '$min' + " : " + '$sec' + " : " + '$millisec';
    }
  }
}

//widget for showing laptime Text
class LapTimeWidget extends StatelessWidget {
  String time;

  LapTimeWidget({this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
            child: Center(
          child: Text(
            time,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )));
  }
}
