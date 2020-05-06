import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    animation = CurvedAnimation(parent: controller, curve: Curves.elasticIn);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
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
                      child: LoginFormCard()))
            ])));
  }
}

class LoginFormCard extends StatelessWidget {
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
              ),
              IconInputField(
                  icon: Icon(Icons.lock),
                  placeholder: "Password",
                  secureField: true),
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
                      onPressed: () {},
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
                      onPressed: () {},
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

  const IconInputField(
      {Key key, this.icon, this.secureField = false, this.placeholder = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: secureField,
      decoration: InputDecoration(
          prefixIcon: icon,
          labelText: placeholder,
          hasFloatingPlaceholder: false,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
    );
  }
}
