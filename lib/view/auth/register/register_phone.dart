import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantstore/view/auth/register/register_password.dart';
import 'package:plantstore/model/user.dart';

class RegisterPhone extends StatefulWidget {

  final UserForm userForm;

  RegisterPhone({Key key, this.userForm}): super(key: key);

  @override
  _RegisterPhoneState createState() => _RegisterPhoneState(userForm);
}

class _RegisterPhoneState extends State<RegisterPhone> {
  final UserForm userForm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _RegisterPhoneState(this.userForm);
  
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
                Text(
                    "Setting up your phone number",
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
                      subtitle: Text("This phone number is already in use"),
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
              initialValue: userForm.phone,
              enabled: !isLoading,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  prefixIcon: Icon(Icons.phone),
                  hintText: "+62123456789"
                ),
                onSaved: (value) => userForm.phone = value,
                validator: validator,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(15)
                ],
              ),
            SizedBox(height: 20),
            isLoading ? Center(child: CircularProgressIndicator()) : FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
                onPressed: () => nextPage(context),
                child: Text("Add phone number"))
          ],
        ));
  }

  String validator(String input) {
    if (input.isEmpty) {
      return "Phone number can't be empty";
    }
    if (!RegExp(
            r"(\+62 ((\d{3}([ -]\d{3,})([- ]\d{4,})?)|(\d+)))|(\(\d+\) \d+)|\d{3}( \d+)+|(\d+[ -]\d+)|\d+")
        .hasMatch(input)) {
      return "Not a valid phone number";
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

      Firestore.instance.collection("user").where("phone", isEqualTo: userForm.phone).limit(1).getDocuments()
        .then((value){
          setState(() {
            print(value.documents);
            if(value.documents.isEmpty)
              Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => RegisterPassword(userForm: userForm)));
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