import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:fluttermail/recognizer.dart';


class HomePage extends StatefulWidget {
  final email,password;
  HomePage({this.email,this.password});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Trancription
  String transcription = '';
  String prevTranscription = '';
  bool authorized = false;

  bool isListening = false;

  bool get isNotEmpty => transcription != '';
  @override
  void initState() {
    super.initState();
    SpeechRecognizer.setMethodCallHandler(_platformCallHandler);
    _activateRecognition();
  }

  @override
  void dispose() {
    super.dispose();
    if (isListening) _cancelRecognitionHandler();
  }

  /*******************/
  String attachment;
  TextEditingController globalController;
  final _recipientController = TextEditingController(
    //Text: 'example@example.com',
  );

  final _subjectController = TextEditingController(
    //Text: 'The subject'
  );

  final _bodyController = TextEditingController(
     text: 'Mail body.',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

   send() {
    new  Email(widget.email,widget.password,_subjectController.text,_bodyController.text, [_recipientController.text],attachment,_scaffoldKey);

    // try {
    //   await FlutterEmailSender.send(email);
    //   platformResponse = 'success';
    // } catch (error) {
    //   platformResponse = error.toString();
    // }

    // if (!mounted) return;

    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(platformResponse),
    // ));
  }

  @override
  Widget build(BuildContext context) {

   // Size size = MediaQuery.of(context).size;/**transcription */


    final Widget imagePath = Text(attachment ?? '');

    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.red),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Compose Email'),
          actions: <Widget>[
            IconButton(
              onPressed: send,
              icon: Icon(Icons.send),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new Row(
                      children: [
                        Flexible(
                          child: TextField(
                          controller: _recipientController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Recipient',
                          ),
                      ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Subject',
                      ),
                    ),
                  ),
                  Padding(
                   
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _bodyController,
                      maxLines: 10,
                      decoration: InputDecoration(
                          labelText: 'Body', border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0) ,

                    child:buildSpeechButton(context)
                   ),
                  imagePath,
                ],
              ),
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   icon: Icon(Icons.camera),
        //   label: Text('Add Image'),
        //   onPressed: _openImagePicker,
        // ),
      
      ),
    );
  }
   Widget buildSpeechButton(BuildContext context) {

 
    List<Widget> blocks = [
      _buildButtonBar(),
    ];
    if (isListening || transcription != '')
      blocks.insert(
          1,
          _buildTranscriptionBox(
              text: transcription,
              onCancel: _cancelRecognitionHandler,
             ));
    return new Center(
        child: new Column(mainAxisSize: MainAxisSize.min, children: blocks));
  }
  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      attachment = pick.path;
    });
  }

   void _saveTranscription() {
    if (transcription.isEmpty) return;

    if(!prevTranscription.isEmpty)
    {
       if(prevTranscription=='recipient')
       {
         setState(() {
    
          transcription=transcription.toLowerCase();
          transcription=transcription.replaceAll(new RegExp(r"\s+\b|\b\s"), "");

          print(transcription);
         _recipientController.text=transcription;
         transcription = '';
       });
       }
       else if(prevTranscription=='subject')
       {
         setState(() {
         _subjectController.text=transcription;
         transcription = '';
       });
       }
       else if(prevTranscription=='body')
       {
         setState(() {
         _bodyController.text=transcription;
         transcription = '';
       });
       }
       else if(transcription=="cleanup")
       {
         prevTranscription='';
         transcription='';
         _recipientController.text='';
         _subjectController.text='';
         _bodyController.text='Mail Body.';
       }
       prevTranscription=transcription;
    }
    else
    {
      prevTranscription=transcription;
    }
    _cancelRecognitionHandler();
  }

  Future _startRecognition() async {
    final res = await SpeechRecognizer.start('en_US');
    if (!res)
      showDialog(
          context: context,
          child: new SimpleDialog(title: new Text("Error"), children: [
            new Padding(
                padding: new EdgeInsets.all(12.0),
                child: const Text('Recognition not started'))
          ]));
  }

  Future _cancelRecognitionHandler() async {
    final res = await SpeechRecognizer.cancel();

    setState(() {
      transcription = '';
      isListening = res;
    });
  }

  Future _activateRecognition() async {
    final res = await SpeechRecognizer.activate();
    setState(() => authorized = res);
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onSpeechAvailability":
        setState(() => isListening = call.arguments);
        break;
      case "onSpeech":
        //if (todos.isNotEmpty) if (transcription == todos.last.label) return;
        setState(() => transcription = call.arguments);
        break;
      case "onRecognitionStarted":
        setState(() => isListening = true);
        break;
      case "onRecognitionComplete":
        setState(() {
          if (globalController.text=='') {
            transcription = call.arguments;
          } else if (call.arguments == transcription)
            // on ios user can have correct partial recognition
            // => if user add it before complete recognition just clear the transcription
            transcription = '';
          else
            transcription = call.arguments;
        });
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }

 


 //Activate when we are writing something
  Widget _buildButtonBar() {
    List<Widget> buttons = [
      !isListening
          ? _buildIconButton(authorized ? Icons.mic : Icons.mic_off,
              authorized ? _startRecognition : null,
              color: Colors.white, fab: true)
          : _buildIconButton(Icons.add, isListening ? _saveTranscription : null,
              color: Colors.white,
              backgroundColor: Colors.redAccent,
              fab: true),
    ];
    Row buttonBar = new Row(
      children: buttons
      );
    return buttonBar;
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPress,
      {Color color: Colors.grey,
      Color backgroundColor: Colors.red,
      bool fab = false}) {
    return  new FloatingActionButton(
              child: new Icon(icon),
              onPressed: onPress,
              backgroundColor: backgroundColor);
  }

  Widget _buildTranscriptionBox(
          {String text, VoidCallback onCancel, double width}) =>
      new Container(
          width: width,
          color: Colors.grey.shade200,
          child: new Row(children: [
            new Expanded(
                child: new Padding(
                    padding: new EdgeInsets.all(8.0), child: new Text(text))),
            new IconButton(
                icon: new Icon(Icons.close, color: Colors.grey.shade600),
                onPressed: text != '' ? () => onCancel() : null),
          ]));


}