import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
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
                                Text("Sign In", style: Theme.of(context).textTheme.headline4,),
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
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.person),
            ),
            validator: (input) {
              if(input.isEmpty){
                return "Please type an email address";
              }
              if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(input)){
                return "Not a valid email";
              }

              return null;
            },
            onSaved: (value) => _email = value,
          ),
          TextFormField(
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (input){
              if(input.isEmpty){
                return "Password can't be empty";
              }else if(input.length < 6){
                return "Your password need to be atleast 6 characters";
              }

              return null;
            },
            onSaved: (value) => _password = value,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: 
          FlatButton(onPressed: (){
            Navigator.of(context).pushNamed("/resetPassword");
          }, child: Text("Forgot your password?"))
          ),
          SizedBox(height: 20),
          FlatButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
            onPressed: signIn,
            child: Text("Sign In")
          ),
          SizedBox(height: 10,),
          Center(child: Text("OR", style: Theme.of(context).textTheme.subtitle1)),
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

      setState(() {
        loading = true;
      });

      FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)
      .catchError((e){
        setState(() {
        loading = false;
          if(e.code == "ERROR_USER_NOT_FOUND"){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("User not found"), backgroundColor: Colors.red));
          }else if(e.code == "ERROR_WRONG_PASSWORD"){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Wrong password"), backgroundColor: Colors.red));
          }
          
        });
      });
      
    }
  }
}
