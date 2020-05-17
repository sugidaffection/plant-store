import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/model/user.dart';
import 'package:plantstore/view/auth/register/register_detail.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserForm userForm = UserForm();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool isLoading = false;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text("Sign Up to connect",
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
                      subtitle: Text("This email is already in use"),
                    )
                  ),
                createForm(context)
              ],
            )));
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
              initialValue: userForm.email,
              enabled: !isLoading,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.mail),
                ),
                onSaved: (value) => userForm.email = value,
                validator: emailValidator),
            SizedBox(height: 20),
            isLoading ? Center(child: CircularProgressIndicator()) : FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
                onPressed: () => nextPage(context),
                child: Text("Get Started"))
          ],
        ));
  }

  String emailValidator(String input) {
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

  void nextPage(BuildContext context) {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      setState(() {
        isLoading = true;
      });

      FirebaseAuth.instance.fetchSignInMethodsForEmail(email: userForm.email)
        .then((value){
          setState(() {
            print(value.isEmpty);
            if(value.isEmpty)
              Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => RegisterDetail(userForm: userForm)));
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
}
