import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fluttermail/MailUI.dart';
import 'package:fluttermail/login_page.dart';
import 'package:fluttermail/recognizer.dart';
import 'package:mailer2/mailer.dart';

class PassPage extends StatefulWidget {
  final email;
  PassPage({this.email});

  @override
  _PassPageState createState() => _PassPageState();
}

class _PassPageState extends State<PassPage> with SingleTickerProviderStateMixin{

  final GlobalKey<ScaffoldState> _scaffoldKey= GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formkey= GlobalKey<FormState>();
  String _password='';
  bool _autoValidate=false;
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;
  
  final _passController=new TextEditingController();


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
      super.initState();

       SpeechRecognizer.setMethodCallHandler(_platformCallHandler);
      _activateRecognition();

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
                  _textbox(widget.email),
                  _sizedBox(20.0),
                  _passwordInput(),
                  _sizedBox(30.0),
                  _submitButton(),
                  Padding(
                    padding:const EdgeInsets.all(8.0) ,
                    child: _buildButtonBar(),
                    )
                
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
     
      showDialog(
      context: context,
      builder: (BuildContext context) {
        // re_buildButtonBar()turn object of type Dialog
        return AlertDialog(
          title: new Text("Important Notice"),
          content: new Text("1.Make sure your email and password are valid otherwise your message wouldn't be sent.\n\n2.For Security purpose only one time access authentication is created and as soon as you leave this app your session will be deleted."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                send_mail();
                //Navigator.of(context).pop();
                //Navigator.popUntil(context, (_) => !Navigator.canPop(context));
                //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomePage(email:widget.email,password:_password)));
              },
            ),
          ],
        );
      },
    );
   // }
    }
    else {
    setState(() => _autoValidate = true);
  }
  }

   Widget _logo() {
    return new Hero(
      tag: 'hero',
      
        child: new FlutterLogo(
               size: _iconAnimation.value * 100.0
       ),
    );
  }

  Widget _passwordInput() {
    return new TextFormField(
          obscureText: true,
          autofocus: false,
          controller: _passController,
          decoration: new InputDecoration(
              labelText: 'Password',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (input){
                           if(input.length<6)
                            return 'Your password need to be atleast 6 characters';
          },
          onSaved: (value) => _password = value,
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
                  child: new Text('Login',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: signIn,
                )));
  }
  Widget _sizedBox(_height) {
    return new SizedBox(height: _height);
  }

  Widget _textbox(_email)
  {
    return
        new FlatButton(
          child: new Text(_email,
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300), textAlign: TextAlign.center,),
          onPressed: ()=>{}
        );
  }


  send_mail() {
    var options = new GmailSmtpOptions()
    ..username = widget.email
    ..password = _passController.text; 

    var emailTransport = new SmtpTransport(options);
  
  // Create our message.
   var envelope = new Envelope()
    ..from = widget.email
    ..recipients.add(widget.email)
   // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
   // ..bccRecipients.add(new Address('bccAddress@example.com'))
    ..subject = "Verification email"
    ..text = "Hello there"
    ..html = "<p></p>";
  
   emailTransport.send(envelope)
    .then((envelope){
     print('Email Verified!');
     Navigator.popUntil(context, (_) => !Navigator.canPop(context));
     Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomePage(email:widget.email,password:_password)));
    })
    .catchError((e){
      print('Error occurred: $e');
        Navigator.of(context).pop();
        showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Wrong Credentials"),
          content: new Text("Email or password is not valid or may be you forget to turn off google security for your email."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.popUntil(context, (_) => !Navigator.canPop(context));
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
              },
            ),
          ],
        );
      },
    );
      });
  }



   void _saveTranscription() {
    if (transcription.isEmpty) return;
    
    setState(() {
     
          transcription=transcription.toLowerCase();
          transcription=transcription.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
          if(transcription=="clearemail")
          {
           _passController.text='';  
          }
          else if(transcription=='clearall')
          {
            _passController.text='';  
          }
          else if(transcription=='proceed')
          {
            signIn();
          }
          else
          {
          print(transcription);
         _passController.text=transcription;
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
              fab: true),
    ];
    Row buttonBar = new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons
      );
    return buttonBar;
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPress,
      {
        Color color: Colors.black87,
        bool fab = false
      }) {
    return  new IconButton(
              icon: new Icon(icon),
              onPressed: onPress,
             );
  }
}