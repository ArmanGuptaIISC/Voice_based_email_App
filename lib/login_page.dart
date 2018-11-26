import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:fluttermail/MailUI.dart';
import 'package:fluttermail/password_page.dart';
import 'package:fluttermail/recognizer.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  

  final GlobalKey<ScaffoldState> _scaffoldKey= GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formkey= GlobalKey<FormState>();
  String _email='',_password='';
  bool _autoValidate=false;
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  
  final _passController=new TextEditingController();
  final _emailController=new TextEditingController();
  /**For speech recognition */
  String transcription = '';
  String prevTranscription = '';
  bool authorized = false;

  bool isListening = false;

  bool get isNotEmpty => transcription != '';

  @override
  void dispose() {
    super.dispose();
    if (isListening) _cancelRecognitionHandler();
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      /************* */
      SpeechRecognizer.setMethodCallHandler(_platformCallHandler);
      _activateRecognition();
    /************ */
      _iconAnimationController =new AnimationController(
        vsync: this,duration: new Duration(milliseconds: 500) 
      );
      _iconAnimation= new CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.elasticOut
      );
      _iconAnimation.addListener(()=>this.setState((){}));
      _iconAnimationController.forward();
    }
  
  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
       body: new Stack(
         fit: StackFit.expand,
         children: <Widget>[
           Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 775.0
                    ? MediaQuery.of(context).size.height
                    : 775.0,
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        loginGradientStart,
                        loginGradientEnd
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                )
           ),
          
           new Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: _formkey,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _sizedBox(50.0),
                  _logo(),
                  _sizedBox(100.0),
                  _emailInput(),
                  _sizedBox(15.0),
                 // _passwordInput(),
                  _sizedBox(30.0),
                  _submitButton(),
                
                ],
              ),
            ))
         ],
       ),
    );
  }

  Future<void> signIn() async
  {
    final form = _formkey.currentState;
    if (form.validate()) {
    form.save();
    Navigator.push(context,MaterialPageRoute(builder: (context)=>PassPage(email:_email)));
    }
    else {
    setState(() => _autoValidate = true);
  }
  }

  String _validateEmail(String value) {
  if (value.isEmpty) {
    // The form is empty
    return "Enter email address";
  }
  // This is just a regular expression for email addresses
  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
  RegExp regExp = new RegExp(p);

  if (regExp.hasMatch(value)) {
    // So, the email is valid
    return null;
  }

  // The pattern of the email didn't match the regex above.
  return 'Email is not valid';
}
/*Ingredient of login form starts*/

Widget _logo() {
    return new Hero(
      tag: 'hero',
      
        child: new FlutterLogo(
               size: _iconAnimation.value * 100.0
       ),
    );
  }

Widget _emailInput() {
    return Row(
      children:[ 
        Flexible(
          child: new TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              controller: _emailController,
              decoration: new InputDecoration(
                  labelText: 'Email',
                  icon: new Icon(
                    Icons.mail,
                    color: Colors.grey,
                  )),
              validator: _validateEmail,
              onSaved:(input)=> _email=input,
            ),
        ),
          _buildButtonBar()
          ]
    );
  }

  Widget _submitButton() {
      return
        new Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: new Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.blueAccent.shade100,
                elevation: 5.0,
                child: new MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  color: Colors.blue,
                  child: new Text('Proceed',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: signIn,
                )));
  }


  Widget _sizedBox(_height) {
    return new SizedBox(height: _height);
  }


  /****************** */
   Widget buildSpeechButton(BuildContext context) {

 
    List<Widget> blocks = [
      _buildButtonBar(),
    ];
    if (isListening || transcription != '')_emailController.text=transcription;
      // blocks.insert(
      //     1,
      //     _buildTranscriptionBox(
      //         text: transcription,
      //         onCancel: _cancelRecognitionHandler,
      //        ) );
    return new Center(
        child: new Column(mainAxisSize: MainAxisSize.min, children: blocks));
  }
   void _saveTranscription() {
    if (transcription.isEmpty) return;
    
    setState(() {
    
          
          transcription=transcription.toLowerCase();
          transcription=transcription.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
          if(transcription=="clearemail")
          {
           _emailController.text='';  
          }
          else if(transcription=='clearall')
          {
            _emailController.text='';  
            _passController.text='';
          }
          else
          {
          print(transcription);
         _emailController.text=transcription;
          }
         transcription = '';

       });

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
              color: Colors.black,
            //  backgroundColor: Colors.transparent,
              fab: true),
    ];
    Row buttonBar = new Row(
      children: buttons
      );
    return buttonBar;
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPress,
      {Color color: Colors.black87,
      //Color backgroundColor: Colors.transparent,
      bool fab = false}) {
    return  new IconButton(
              icon: new Icon(icon),
              onPressed: onPress,

             // backgroundColor: backgroundColor
             );
  }


}