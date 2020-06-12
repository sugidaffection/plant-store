import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/model/user.dart';

class RegisterPassword extends StatefulWidget {

  final UserForm userForm;

  RegisterPassword({Key key, this.userForm}): super(key: key);

  @override
  _RegisterPasswordState createState() => _RegisterPasswordState(this.userForm);
}

class _RegisterPasswordState extends State<RegisterPassword> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;
  final UserForm userForm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;

  _RegisterPasswordState(this.userForm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: loading ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text("Create your password",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                createForm(context)
              ])));
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
              initialValue: userForm.password,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onSaved: (value) => userForm.password = value,
                validator: validator),
            SizedBox(height: 20),
            FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
                onPressed: () => register(context),
                child: Text("Create Account"))
          ],
        ));
  }

  String validator(String input) {
    if (input.isEmpty) {
      return "Password can't be empty";
    }
    if (input.length < 6) {
      return "Password need to be atleast 6 characters";
    }
    return null;
  }

  void register(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      auth
      .createUserWithEmailAndPassword(
              email: userForm.email, password: userForm.password)
          .then((result) {
            db.collection("user").document(result.user.uid).setData(userForm.toJson());
            UserUpdateInfo userUpdate = UserUpdateInfo();
            userUpdate.displayName = userForm.fullName;
            result.user.updateProfile(userUpdate).then((value) {
              Navigator.of(context).pushReplacementNamed("/");
            })
            .catchError((error)=>print(error));
      }).catchError((error) {
        print(userForm.email);
        print(error);
          if (error.code == "ERROR_EMAIL_ALREADY_IN_USE")
            {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(error.message),
                  backgroundColor: Colors.red));
            }
        });
    }
  }


}
