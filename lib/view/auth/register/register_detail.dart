import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantstore/model/user.dart';
import 'package:plantstore/view/auth/register/register_phone.dart';

class RegisterDetail extends StatefulWidget {
  final UserForm userForm;

  const RegisterDetail({Key key, this.userForm}) : super(key: key);

  @override
  _RegisterDetailState createState() =>
      _RegisterDetailState(this.userForm);
}

class _RegisterDetailState extends State<RegisterDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UserForm userForm;

  _RegisterDetailState(this.userForm);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20),
          child: Column(children: [
            SizedBox(height: 30),
            Text(
              "Complete Your Registration",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            createForm(context)
          ])),
    );
  }

  Widget createForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        TextFormField(
          enableSuggestions: false,
          autocorrect: false,
          initialValue: userForm.fullName,
          decoration: InputDecoration(
            labelText: "Full Name",
            hintText: "John Doe",
          ),
          onSaved: (value) => userForm.fullName = value,
          validator: validator,
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text("Your gender:"),
            SizedBox(width: 20),
            GestureDetector(
              onTap: (){
                setState(() {
                      userForm.gender = true;
                    });
              },
              child: Row(children: [
              Radio(
                  value: 1,
                  groupValue: userForm.gender ? 1 : 2,
                  onChanged: (v) {
                    setState(() {
                      userForm.gender = true;
                    });
                  }),
              Text("Male"),
            ])
            )
            ,
            GestureDetector(
              onTap: (){
                setState(() {
                      userForm.gender = false;
                    });
              },
              child: Row(children: [
              Radio(
                  value: 2,
                  groupValue: userForm.gender ? 1 : 2,
                  onChanged: (v) {
                    setState(() {
                      userForm.gender = false;
                    });
                  }),
              Text("Female"),
            ])
            )
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          enableSuggestions: false,
          autocorrect: false,
          initialValue: userForm.address,
          decoration: InputDecoration(
              labelText: "Address Line 1", hintText: "123 Main Street"),
          onSaved: (value) => userForm.address = value,
          validator: validator,
        ),
        SizedBox(height: 10),
        TextFormField(
          enableSuggestions: false,
          autocorrect: false,
          initialValue: userForm.address,
          decoration: InputDecoration(labelText: "Address Line 2 (Optional)"),
          onSaved: (value) => userForm.address2 = value,
        ),
        SizedBox(height: 40),
        FlatButton(
            textTheme: ButtonTextTheme.primary,
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryTextTheme.bodyText2.color,
            onPressed: () => nextPage(context),
            child: Text("Add your phone"))
      ]),
    );
  }

  String validator(String input) {
    if (input.isEmpty) {
      return "This field is required.";
    }

    return null;
  }

  void nextPage(BuildContext context) {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => RegisterPhone(userForm: userForm)));
    }
  }
}
