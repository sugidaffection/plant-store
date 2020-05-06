import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  void auth(TextEditingController email, TextEditingController password) {
    print("Login");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(body: Container(
            color: Colors.white,
            child: Stack(children: [
              Container(
                  width: size.width,
                  height: size.height * .5,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/background.jpeg"),
                    fit: BoxFit.fitHeight,
                  ))),
              SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      height: size.height,
                      child: LoginFormCard(onAction: auth)))
            ])));
  }
}

class LoginFormCard extends StatefulWidget {
  final Function(TextEditingController, TextEditingController) onAction;

  const LoginFormCard({Key key, @required this.onAction}) : super(key: key);

  @override
  _LoginFormCardState createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        height: size.height * .7,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(43), topRight: Radius.circular(43)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 30,
                  // spreadRadius: 1,
                  offset: Offset(0, -4)),
              BoxShadow(
                  spreadRadius: 5, color: Colors.white, offset: Offset(0, 30))
            ]),
        child: SafeArea(
          child: Wrap(
            runSpacing: 20,
            children: [
              Center(
                  child: Text("Sign In",
                      style: TextStyle(
                          fontSize: 36, fontWeight: FontWeight.w500))),
              SizedBox(height: 60),
              IconInputField(
                icon: Icon(Icons.person),
                placeholder: "Email or Phone Number",
                controller: email,
              ),
              IconInputField(
                  icon: Icon(Icons.lock),
                  placeholder: "Password",
                  secureField: true,
                  controller: password,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot your password?")),
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).pushNamed("/main");
                        });
                      },
                      child: Text("Sign In",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500)))),
              Center(child: Text("OR")),
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlineButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      textColor: Colors.grey.shade600,
                      onPressed: () {
                        setState(() {
                          Navigator.pushReplacementNamed(context, "/register");
                        });
                      },
                      child: Text("Sign Up",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500))))
            ],
          ),
        ));
  }
}

class IconInputField extends StatelessWidget {
  final bool secureField;
  final Icon icon;
  final String placeholder;
  final TextEditingController controller;

  const IconInputField(
      {Key key, this.icon, this.secureField = false, this.placeholder = "", this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      autovalidate: false,
      controller: controller,
      obscureText: secureField,
      decoration: InputDecoration(
          prefixIcon: icon,
          labelText: placeholder,
          hasFloatingPlaceholder: false,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
    );
  }
}
