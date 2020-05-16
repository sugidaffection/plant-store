import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _name;
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: size.width,
        color: Colors.white,
        child: SingleChildScrollView(child: Container(height: size.height, color: Colors.white, child: Padding(padding: EdgeInsets.all(20), child: Column(
          children: [
            Text("Sign Up to connect", style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
                onSaved: (value) => _name = value,
                validator: (input){
                  if(input.isEmpty){
                    return "Full Name can't be empty";
                  }
                  return null;
                }
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.mail),
                ),
                onSaved: (value) => _email = value,
                validator: (input){
                  if(input.isEmpty){
                    return "Email can't be empty";
                  }
                  if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(input)){
                    return "Not a valid email";
                  }
                  return null;
                }
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
                onSaved: (value) => _password = value,
                validator: (input){
                  if(input.isEmpty){
                    return "Password can't be empty";
                  }
                  if(input.length < 6){
                    return "Password need to be atleast 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
                onPressed: register, 
                child: Text("Create Account"))
            ],))
          ],
        )
      ))))
    );
  }

  void register(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)
        .then((result){
          setState((){
            UserUpdateInfo userUpdate = UserUpdateInfo();
            userUpdate.displayName = _name;
            result.user.updateProfile(userUpdate)
              .then((value){
                Navigator.of(context).pushReplacementNamed("/");
              });
          });
        })
        .catchError((error)=>{
          setState(()=>{
            if(error.code == "ERROR_EMAIL_ALREADY_IN_USE"){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.message), backgroundColor: Colors.red))
            }
          })
        });
    }
  }
}
