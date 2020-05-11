import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = true;
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              height: size.height,
                color: Colors.white,
                child: Stack(
                  children: [
                  Container(
                      height: size.height * .5,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/background.jpeg"),
                              fit: BoxFit.fitHeight))),
                  Column(children: [
                    Spacer(),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: SafeArea(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
                              child: Column(children: [
                                Text("Sign In", style: Theme.of(context).textTheme.display1,),
                                SizedBox(height: 20),
                                loginForm()
                                ]))))])
                ]))));
  }

  Form loginForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.person)
            ),
            onSaved: (value) {
              _email = value;
            },
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock),
            ),
            onSaved: (value) {
              _password = value;
            },
          ),
          SizedBox(height: 20),
          FlatButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryTextTheme.body1.color,
            onPressed: signIn,
            child: Text("Sign In")
          ),
          SizedBox(height: 10,),
          Center(child: Text("OR", style: Theme.of(context).textTheme.subhead)),
          SizedBox(height: 10,),
          OutlineButton(
            onPressed: (){
              Navigator.of(context).pushNamed("/register");
            },
            child: Text("Create an account"),
            )
        ]));
  }

  signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var sharedPrefrences = await SharedPreferences.getInstance();
      sharedPrefrences.setString("token", "123");
      Navigator.of(context).pushReplacementNamed("/");
    }
  }
}
