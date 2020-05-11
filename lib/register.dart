import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
            Text("Sign Up to connect", style: Theme.of(context).textTheme.headline),
            SizedBox(height: 40),
            Form(child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.mail),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              FlatButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.body1.color,
                onPressed: (){}, 
                child: Text("Create Account"))
            ],))
          ],
        )
      ))))
    );
  }
}
