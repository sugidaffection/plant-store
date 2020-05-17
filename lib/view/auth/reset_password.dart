import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool error = false;

  bool success = false;

  Timer timer;
  int time = 10;
  bool canResend = false;

  String _email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer){
        setState(() {
          if(!canResend && time <= 1){
            time = 10;
            canResend = true;
          }

          if(!canResend){
            time--;
          }

        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: success ? checkEmail() : SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                    "Reset your password",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 40),
                if(this.error)
                  Container(
                    color: Colors.amberAccent,
                    child: ListTile(
                      leading: Icon(Icons.warning),
                      title: Text("Sorry"),
                      subtitle: Text("This email is not assosiated to any account"),
                    )
                  ),
                createForm(context)
              ],
            )));
  }

  Widget checkEmail(){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Text("Password reset link sent", style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.center),
        Text("Please check your email and click on provided link to reset your password.", style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center),
        SizedBox(height: 40),
        RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
                onPressed: canResend ? sendLink : null,
                child: canResend ? Text("Resend email") : Text("Retry in $time"))
      ]));
  }

  Widget createForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              autocorrect: false,
              enableSuggestions: false,
              initialValue: _email,
              enabled: !isLoading,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.mail),
                ),
                onSaved: (value) => _email = value,
                validator: validator),
            SizedBox(height: 20),
            isLoading ? Center(child: CircularProgressIndicator()) : FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
                onPressed: sendResetPassword,
                child: Text("Send reset password link"))
          ],
        ));
  }

  String validator(String input) {
    if (input.isEmpty) {
      return "Email can't be empty";
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(input)) {
      return "Not a valid email";
    }
    return null;
  }

  void sendResetPassword(){
    FormState formState = _formKey.currentState;
        if (formState.validate()) {
          formState.save();

          setState(() {
            isLoading = true;
          });

          FirebaseAuth.instance.fetchSignInMethodsForEmail(email: _email)
            .then((value){
              setState(() {
                if(value.isNotEmpty){
                  success = true;
                  sendLink();
                }
                else error = true;
                isLoading = false;


              });
              
            })
            .catchError((error){
              setState(() {
                isLoading = false;
              });
            });

          
        }
  }

  void sendLink(){
    setState(() {
      canResend = false;
      time = 10;
    });
    FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    timer = null;
  }
}