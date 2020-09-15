import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:japfooduser/grocerry_kit/SignIn.dart';
import 'package:japfooduser/grocerry_kit/home_page.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = "signUpPage";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  bool _isObscured = true;
  Color _eyeButtonColor = Colors.grey[700];
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scacffoldKey,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/japsignin.jpg"),
                  fit: BoxFit.cover)),
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
//              Container(height: 200,
//                margin: EdgeInsets.all(20),
//                decoration: BoxDecoration(
//                  // color: product.color,
//                    borderRadius: BorderRadius.circular(16),
//                    image: DecorationImage(
//                        image: AssetImage("images/logo.jpeg"), fit: BoxFit.fitHeight)),
//              ),

                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: TextFormField(
                              validator: (val) {
                                return val.trim().isEmpty
                                    ? "email cannot be empty."
                                    : null;
                              },
                              onSaved: (val) {
                                _email = val.trim();
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                hintText: 'E-Mail Address',
                                errorStyle: TextStyle(
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).buttonColor,
                                        width: 1.5)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.5)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: TextFormField(
                              validator: (String val) {
                                if (val.trim().isEmpty) {
                                  return "Password cannot be empty";
                                } else if (val.trim().length < 8) {
                                  return "Password must be 8 characters.";
                                }
                                return null;
                              },
                              onSaved: (val) {
                                _password = val.trim();
                              },
                              obscureText: _isObscured,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w400),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                  fontSize: 16,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (_isObscured) {
                                      setState(() {
                                        _isObscured = false;
                                        _eyeButtonColor =
                                            Theme.of(context).accentColor;
                                      });
                                    } else {
                                      setState(() {
                                        _isObscured = true;
                                        _eyeButtonColor =
                                            Theme.of(context).primaryColor;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: _eyeButtonColor,
                                  ),
                                ),
                                hintText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).buttonColor,
                                        width: 1.5)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.5)),
                              ),
                            ),
                          ),

//                          Container(
//                            margin: EdgeInsets.only(top: 8, right: 12),
//                            alignment: Alignment.centerRight,
//                            child: GestureDetector(
//                              onTap: () {
//                                _formKey.currentState.save();
//                                _resetPassword(_email, context);
//                              },
//                              child: Padding(
//                                padding: const EdgeInsets.all(6.0),
//                                child: Text(
//                                  "Forgot Password",
//                                  style: TextStyle(fontSize: 17),
//                                ),
//                              ),
//                            ),
//                          ),
                          if (_isLoading) CircularProgressIndicator(),
                          if (!_isLoading)
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              ),
                              width: 200,
                              child: FlatButton(
                                child: Text('Sign Up',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    //Only gets here if the fields pass
                                    _formKey.currentState.save();
                                    _signup(_email, _password, context);
                                  }
                                },
                              ),
                            ),


                          if (!_isLoading)
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                              ),
                              width: 200,
                              child: FlatButton(
                                child: Text('Sign in',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return SignInPage();
                                  }));
                                },
                              ),
                            ),

                        ],
                      ),
                    ),
                  ),

//                    SizedBox(
//                      height: 20,
//                    )
                ],
              ),
            ),
          ),
        ));
  }

  void _signup(email, password, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(authResult.user.uid);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    } on PlatformException catch (err) {
      var message = "An error has occured, please check your credentials.";

      if (err.message != null) {
        message = err.message;
      }

      _scacffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetPassword(String email, BuildContext ctx) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _scacffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "A recovery email has been sent to you.",
        ),
        backgroundColor: Theme.of(ctx).primaryColor,
      ));
    } on PlatformException catch (err) {
      var message = "An error has occured, please check your credentials.";

      if (err.message != null) {
        message = err.message;
      }

      if (email == null || email.isEmpty) {
        message = "Please enter your registered email";
      }

      _scacffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);

      setState(() {
        _isLoading = false;
      });
    }
  }
}
