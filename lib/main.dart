import 'package:animator/animator.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:numberpicker/numberpicker.dart';

void main() => runApp(MyApp());

final bgColor = Color(0xff283044);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: 'PTMono',primaryColor: bgColor),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var _selectedIndex = 100;
  AnimationController animationController;
  Animation<double> animation;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );
  }

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: bgColor,
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              NumberPicker.integer(
                  itemExtent: MediaQuery.of(context).size.width / 3,
                  scrollDirection: Axis.horizontal,
                  numberToDisplay: 3,
                  initialValue: _selectedIndex,
                  minValue: 1,
                  maxValue: 210,
                  onChanged: (newValue) => setState(() {
                        _selectedIndex = newValue;
                      })),
              Stack(children: [
                CircularRevealAnimation(
                  child: Container(
                    child: Text("salihhh"),
                  ),
                  animation: animation,
                ),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    child: RaisedButton(
                      color: Color(0xfffd555b),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0)),
                      key: this.key,
                      onPressed: () {
                        setState(() {
                          RenderBox box = key.currentContext.findRenderObject();
                          Offset position = box.localToGlobal(
                              Offset.zero); //this is global position
                          double y = position.dy;
                          double x = position.dx;

                          showRevealDialog(
                              context,
                              x + 40,
                              y + 40,
                              _selectedIndex,
                              MediaQuery.of(context).size.height);
                        });

                        // if (animationController.status == AnimationStatus.forward ||
                        //     animationController.status == AnimationStatus.completed) {
                        //   animationController.reverse();
                        // } else {
                        //   animationController.forward();
                        // }
                      },
                    ),
                  ),
                ),
              ]),
            ],
          ),
          Container(
            width: 105,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                      color: bgColor,
                      blurRadius: 60,
                      spreadRadius: 20,
                      offset: Offset(-30, 0)),
                ]),
            child: Container(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 105,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                        color: bgColor,
                        blurRadius: 60,
                        spreadRadius: 20,
                        offset: Offset(30, 0)),
                  ]),
              child: Container(),
            ),
          )
        ]),
      ),
    );
  }
}

Future<void> showRevealDialog(
    BuildContext context, double x, double y, int num, double height) async {
  showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: true,
    barrierColor: Color(0xfffd555b).withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 1000),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xfffd555b),
        child: Material(
            type: MaterialType.transparency,
            child: Animator(
              repeats: 1,
              duration: Duration(seconds: num),
              tween: Tween<double>(begin: 0, end: height + (height / num)),
              cycles: 0,
              builder: (anim) {
                return Stack(children: [
                  Container(
                      width: double.infinity,
                      height: (anim.value / (height / num)) > 1
                          ? anim.value - (height / num)
                          : 0,
                      color: bgColor),
                  Center(
                      child: Text(
                    "${(anim.value / (height / num)) > 1 ? (num - (anim.value / (height / num))).round() + 1 : num}",
                    style: TextStyle(fontSize: 80, color: Colors.white),
                  ))
                ]);
              },
            )),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return CircularRevealAnimation(
        child: child,
        animation: anim1,
        centerOffset: Offset(x, y),
      );
    },
  );
}
