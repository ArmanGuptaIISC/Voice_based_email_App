import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluttermail/MailUI.dart';
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
       body: new Stack(
         fit: StackFit.expand,
         children: <Widget>[
           new Image(
               image: new AssetImage("assets/dragon.jpg"),
               fit: BoxFit.cover,
               color: Colors.black87,
               colorBlendMode: BlendMode.darken,
           ),
           new Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               new FlutterLogo(
               size: _iconAnimation.value * 100.0
             ),
             new Form(
               key: _formkey,
               autovalidate: _autoValidate,
               child: new Theme(
                 data: new ThemeData(
                   brightness: Brightness.dark,
                   primarySwatch: Colors.teal,
                   inputDecorationTheme: new InputDecorationTheme(
                     labelStyle: new TextStyle(
                     color: Colors.teal,
                     fontSize: 24.0
                     )
                   )
                 ),
                 child: new Container(
                    padding: const EdgeInsets.all(20.0),
                    child: new Column(
                     children: <Widget>[
                       new TextFormField(
                         validator: _validateEmail,
                         onSaved:(input)=> _email=input,
                         decoration: new InputDecoration(
                           labelText: "Enter Email"
                         ),
                         keyboardType: TextInputType.emailAddress,
                       ),
                       new Padding(
                         padding: const EdgeInsets.only(top:10.0),
                       ),
                       new TextFormField(
                          validator: (input){
                           if(input.length<6)
                            return 'Your password need to be atleast 6 characters';
                         },
                         onSaved:(input)=> _password=input,
                         decoration: new InputDecoration(
                           labelText: "Enter Password" 
                         ),
                         keyboardType: TextInputType.text,
                         obscureText: true,
                       ),
                      
                       new MaterialButton(
                         onPressed: signIn,
                         color: Colors.teal,
                         child: new Icon(Icons.arrow_forward_ios),
                         splashColor: Colors.amberAccent,

                       )                  
                     ],
                   ),
                 ),
               ),
             )

             ],
           )
           
         ],
       ),
    );
  }

  Future<void> signIn() async
  {
    final form = _formkey.currentState;
    if (form.validate()) {
    form.save();
     
    // try{
    // FirebaseUser user= await  auth.signInWithEmailAndPassword(email: _email,password: _password);
    // assert(user != null);
    // assert(await user.getIdToken() != null);

    // final FirebaseUser currentUser = await auth.currentUser();
    // assert(user.uid == currentUser.uid);

    // print('signInEmail succeeded: $user')
    //}

    //catch(e){

     // print (e.message);
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
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomePage(email:_email,password:_password)));
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

}