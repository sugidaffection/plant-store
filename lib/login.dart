import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        child: Stack(
          children: [
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpeg"),
                  fit: BoxFit.fitHeight,
                )
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                  height: size.height * 0.7,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(43),
                      topRight: Radius.circular(43)
                    )
                  ),
                  child: Wrap(
                    runSpacing: 20,
                    children: [
                      Center(child: Text("Sign In", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500))),
                      SizedBox(height: 60),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: "Email or Phone Number",
                          hasFloatingPlaceholder: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4)
                          )
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Password",
                          hasFloatingPlaceholder: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4)
                          )
                        )
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("Forgot your password?")
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)
                          ),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: (){},
                          child: Text("Sign In", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500))
                        )
                      ),
                      Center(child: Text("OR")),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: Colors.grey.shade600)
                          ),
                          textColor: Colors.grey.shade600,
                          onPressed: (){},
                          child: Text("Sign Up", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500))
                        )
                      )

                      
                      
                    ],
                  ),
                )
              )
            )
           ]
        )
      )
    );
  }
}