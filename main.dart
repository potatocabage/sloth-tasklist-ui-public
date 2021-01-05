import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
//import 'dart:js' as js;

String savedTask = "saved";
String savedSubject = "saved";

void main() => runApp(MaterialApp(
  home: MyList(),
));

class TaskSize {
  double width;
  double height;
  String task;
  String subject;
  DateTime date;
  bool auto;
  TaskSize({Key key, this.width, this.height, this.task: "", this.subject: "", this.date: null, this.auto: false});
}

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  List<TaskSize> sizeList = [
    TaskSize(width: 320, height: 270, key: UniqueKey(), task: "Ch 5 Webassign", subject: 'APC', date: DateTime.utc(2020, 9, 15)),
    TaskSize(width: 320, height: 270, key: UniqueKey(), task: "Read pg. 74 - 99", subject: 'AE', date: DateTime.utc(2020, 9, 15)),
    TaskSize(width: 320, height: 270, key: UniqueKey(), task: "Study for test", subject: 'AP Lit', date: DateTime.utc(2020, 9, 14)),
  ];

  @override
//  List<MyApp> listViews2 = sizeList.map((taskSize) => MyApp(
//      width: taskSize.width,
//      height: taskSize.height,
//      key: UniqueKey(),
//      delete: () {
//        setState(() {
//          sizeList.remove(taskSize);
//        });
//        print('yay');
//      }
//  )).toList();
  List<Widget> listViews = <Widget>[MyApp(
    key: UniqueKey(),
    width: 320,
    height: 270,
  ), MyApp(
    key: UniqueKey(),
    width: 320,
    height: 270,
  ), MyApp(
    key: UniqueKey(),
    width: 320,
    height: 270,
  ),
  ];
  List<Widget> listViews2 = [];
  void initState() {
//    setState(() {
//      listViews2 = sizeList.map((taskSize) =>
//          MyApp(
//              width: taskSize.width,
//              height: taskSize.height,
//              key: UniqueKey(),
//              delete: () {
//                setState(() {
//                  listViews2.remove(taskSize);
//                });
//                print('yay');
//                print(listViews2);
//              }
//          )).toList();
//    });
    _getList();
    super.initState();
  }
  List<Widget> _getList(){
    listViews2 = [];
    for(int i = 0; i<sizeList.length; i++){
      listViews2.add(
        MyApp(
          width: sizeList[i].width,
          height: sizeList[i].height,
          task: sizeList[i].task,
          subject: sizeList[i].subject,
          date: sizeList[i].date,
          auto: sizeList[i].auto,
          key: UniqueKey(),
          delete: () {
            setState(() {
              sizeList.removeAt(i);
            });
          },
          saveTask: (){
            setState(() {
              sizeList[i].task = savedTask;
            });
          },
          saveSubject: (){
            setState(() {
              sizeList[i].subject = savedSubject;
            });
          },
        )
      );
    }
    return listViews2;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            RealAdd(
              addTask: () {
                setState(() {
                  sizeList.add(TaskSize(width: 320, height: 270, key: UniqueKey(), task: "", subject: '', date: DateTime.utc(2020, 9, 15), auto: true));
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => sizeList.last.auto = false);

                });
              },
            ),
            Expanded(
              child: ReorderableListView(
                onReorder: (int oldIndex, int newIndex) {
                  if(oldIndex < newIndex){
                    newIndex -= 1;
                  }
                  setState(() {
                    sizeList.insert(newIndex, sizeList.removeAt(oldIndex));
                  });
                },
                //children: listViews != null ? listViews: <Widget> [Container(child: Text('pain'), key: UniqueKey(),)],
//                children: sizeList.map((taskSize) => MyApp(
//                  width: taskSize.width,
//                  height: taskSize.height,
//                  key: UniqueKey(),
//                  delete: () {
//                    setState(() {
//                      sizeList.remove(taskSize);
//                    });
//                    print('yay');
//                  }
//                )).toList(),
//              children: listViews2 != null ? listViews2: <Widget> [Container(child: Text('pain'), key: UniqueKey(),)],
                children: _getList() != null ? listViews2: <Widget> [Container(child: Text('pain'), key: UniqueKey(),)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final double width;
  final double height;
  final Function delete;
  final Function saveTask;
  final Function saveSubject;
  bool auto;
  String task;
  String subject;
  DateTime date;
  Color color = Colors.lightBlueAccent;
  MyApp(
      {Key key,
        this.width: 320,
        this.height: 270,
        this.task,
        this.subject,
        this.date,
        this.auto: false,
        this.color: Colors.lightBlueAccent,
        this.delete,
        this.saveTask,
        this.saveSubject,
      })
      : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool complete = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      //heightFactor: 0.93,
      heightFactor: 1,
      child: ColumnSuper(
        alignment: Alignment.center,
        invert: false,
        innerDistance: -40.0,
        children: <Widget>[
          MyAdd(
            width: widget.width,
            height: 40,
            color: widget.color,
          ),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              MyBase(
                width: widget.width,
                height: widget.height,
                task: widget.task,
                subject: widget.subject,
                date: widget.date,
                auto: widget.auto,
                saveTask: widget.saveTask,
                saveSubject: widget.saveSubject,
              ),
              Positioned(
                top: 0,
                child: MyButton(
                  width: widget.width*.4,
                  height: 40,
                  onComplete: (){
                    setState(() {
                      if(complete == false){
                        widget.color = Colors.green;
                        complete = true;
                      }else{
                        widget.color = Colors.lightBlueAccent;
                        complete = false;
                      }
                    });
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: MyButton(
                  width: widget.width*.4,
                  height: 40,
                  onComplete: (){
                    print('delete pain');
                    widget.delete();
                  },
                ),
              ),
            ],
          ),
//              MyButton(
//                width: widget.width*.4,
//                height: 40,
//                onComplete: (){
//                  setState(() {
//                    if(complete == false){
//                      widget.color = Colors.green;
//                      complete = true;
//                    }else{
//                      widget.color = Colors.lightBlueAccent;
//                      complete = false;
//                    }
//                  });
//                },
//              ),
        ],
      ),
    );
  }
}


class MyBase extends StatefulWidget {
  final double width;
  final double height;
  final String task;
  final saveTask;
  final saveSubject;
  String subject;
  DateTime date;
  bool auto;
  MyBase(
      {Key key,
        this.width: 320,
        this.height: 270,
        this.task,
        this.subject,
        this.date,
        this.auto: false,
        this.saveTask,
        this.saveSubject,
      })
      : super(key: key);
  @override
  _MyBaseState createState() => _MyBaseState();
}
//const textFieldTextStyle = TextStyle(fontSize: 17.0);

class _MyBaseState extends State<MyBase> {
  //GlobalKey keyBase = GlobalKey();
  DateTime  _dateTime;
  FocusNode _taskFocusNode;
  FocusNode _subjectFocusNode;
  TextEditingController _taskTextController = TextEditingController();
  TextEditingController _subjectTextController = TextEditingController();
//  double _textHeight = 0.0;
//  double _fontSize = textFieldTextStyle.fontSize;
//  int maxlines = 7;
//  bool increased = false;
  @override
  void initState(){
    super.initState();
    _taskTextController = TextEditingController(text: widget.task);
    _subjectTextController = TextEditingController(text: widget.subject);
    _dateTime = widget.date;
    _taskFocusNode = FocusNode();
    _subjectFocusNode = FocusNode();
    _taskFocusNode.addListener(() {
      print("Task has focus: ${_taskFocusNode.hasFocus}");
      if(_taskFocusNode.hasFocus == false) {
        print(_taskTextController.text);
        savedTask = _taskTextController.text;
        widget.saveTask();

      }
    });
    _subjectFocusNode.addListener(() {
      print("Subject has focus: ${_subjectFocusNode.hasFocus}");
      if(_subjectFocusNode.hasFocus == false) {
        print(_subjectTextController.text);
        savedSubject = _subjectTextController.text;
        widget.saveSubject();
      }
    });
    if(widget.auto == true){
      _taskFocusNode.requestFocus();
      print(widget.auto);
    }
  }
  @override
  void dispose(){
    _taskFocusNode.dispose();
    _subjectFocusNode.dispose();
    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        FocusScope.of(context).unfocus();
        print('unfocused');
      },
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (screenSize.width-widget.width)/2),
        child: Transform(
          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
          child: PhysicalShape(
            clipper: MyClipper(),
            color: Colors.white,
            elevation: 16.0,
            //key: keyBase,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Container(         //save
                width: widget.width,
                //height: widget.height,
                child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(widget.width*.6,0,0,10),
                        child: Container(
                          width: widget.width*.3,
                          height: 40,
                          child: TextField(
                            controller: _subjectTextController,
                            focusNode: _subjectFocusNode,
                            decoration: InputDecoration.collapsed(hintText: 'Subject'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Container(
                          width: widget.width-40,
                          //height: widget.height-120,
                          child: TextField( //remember contain
                            decoration: InputDecoration.collapsed(hintText: 'Task'),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _taskTextController,
                            focusNode: _taskFocusNode,
                            //style: textFieldTextStyle.copyWith(fontSize: _fontSize),
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5,10,200,5),
                        child: InkWell(
                          onTap: (){
                            showDatePicker(
                              context: context,
                              initialDate: _dateTime == null ? DateTime.now(): _dateTime,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year+1,DateTime.now().month,31,0,0,0,0,0),
                            ).then((date) {
                              setState(() {
                                _dateTime = date;
                              });
                            });
                            FocusScope.of(context).unfocus();
                            print('unfocused');
                          },
                          child: Container(
                            width: widget.width*.3,
                            height: 40,
                            //color: Colors.red,
                            child: Center(
                              child: Text(
                                _dateTime == null ? 'Due Date': '${_dateTime.month}/${_dateTime.day}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 20.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
//Size getSize() {
//final RenderBox renderBoxBase = keyBase.currentContext.findRenderObject();
//return renderBoxBase.size;
//}
}
class MyAdd extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  const MyAdd(
      {Key key,
        this.width: 320,
        this.height: 270,
        this.color: Colors.lightBlueAccent,
      })
      : super(key: key);
  @override
  _MyAddState createState() => _MyAddState();
}

class _MyAddState extends State<MyAdd> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(0, 0, 0),
          child: PhysicalShape(
            elevation: 10.0,
            color: widget.color,
            clipper: PlusClipper(),
            child: Container(
              width: widget.width,
              height: widget.height,
            ),
          ),
        ),
        Positioned(
          left: widget.width*.43,
          top: -5,
          height: 50,
          width: 50,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class MyButton extends StatefulWidget {
  final double width;
  final double height;
  final Function onComplete;
  const MyButton(
      {Key key,
        this.width: 320,
        this.height: 270,
        this.onComplete,
      })
      : super(key: key);
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
        print('unfocused');
        widget.onComplete();
      },
      child: ClipPath(
        clipper: ButtonClipper(),
        child: Container(
          width: widget.width,
          height: widget.height,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class RealAdd extends StatefulWidget {
  final Function addTask;
  const RealAdd(
      {Key key, this.addTask,})
      : super(key: key);
  @override
  _RealAddState createState() => _RealAddState();
}

class _RealAddState extends State<RealAdd> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.grey,
          width: screenSize.width,
          height: 70,
        ),
        Positioned(
          right: 15,
          top: 10,
          child: RawMaterialButton(
            onPressed: widget.addTask,
            elevation: 2.0,
            fillColor: Colors.lightBlueAccent,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30.0,
            ),
            padding: EdgeInsets.all(10.0),
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }
}


class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 40, size.width, size.height-80), Radius.circular(16)));
    path.moveTo(size.width/2, 40);
    path.quadraticBezierTo(size.width*.55, 40, size.width*.6, 20);
    path.quadraticBezierTo(size.width*.65, 0, size.width*.7, 0);
    path.lineTo(size.width-16, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 16);
    path.lineTo(size.width, 56);
    path.moveTo(size.width/2, size.height-40);
    path.quadraticBezierTo(size.width*.45, size.height-40, size.width*.4, size.height-20);
    path.quadraticBezierTo(size.width*.35, size.height, size.width*.3, size.height);
    path.lineTo(16, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height-16);
    path.lineTo(0, size.height - 56);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}
class PlusClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.moveTo(size.width*.3, 40);
    path.lineTo(size.width*.5, 40);
    path.quadraticBezierTo(size.width*.55, 40, size.width*.6, 20);
    path.quadraticBezierTo(size.width*.65, 0, size.width*.7, 0);
    path.lineTo(size.width*.5, 0);
    path.quadraticBezierTo(size.width*.45, 0, size.width*.4, 20);
    path.quadraticBezierTo(size.width*.35, 40, size.width*.3, 40);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}
class ButtonClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.moveTo(0, 40);
    path.lineTo(size.width/2, 40);
    path.quadraticBezierTo(size.width*5/8, 40, size.width*3/4, 20);
    path.quadraticBezierTo(size.width*7/8, 0, size.width, 0);
    path.lineTo(size.width/2, 0);
    path.quadraticBezierTo(size.width*3/8, 0, size.width*1/4, 20);
    path.quadraticBezierTo(size.width*1/8, 40, 0, 40);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}