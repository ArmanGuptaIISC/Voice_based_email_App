import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:fluttermail/MailUI.dart';
import 'package:fluttermail/recognizer.dart';

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

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
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
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Important Notice"),
          content: new Text("1.Make sure your email and password are valid otherwise your message wouldn't be sent.\n\n2.For Security purpose only one time access authentication is created and as soon as you leave this app your session will be deleted."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                //Navigator.of(context).pop();
                Navigator.popUntil(context, (_) => !Navigator.canPop(context));
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomePage(email:widget.email,password:_password)));
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
}