import 'dart:convert';

import 'package:apli/Services/auth.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../HomeLoginWrapper.dart';

class UpdatePassword extends StatefulWidget {
  final String email;
  UpdatePassword({this.email});
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

double width, height;

class _UpdatePasswordState extends State<UpdatePassword> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String password;

  bool validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.length < 8) {
      return false;
    } else {
      if (!regex.hasMatch(value))
        return false;
      else
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        :  Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: height * 0.3, right: width * 0.5),
                child: Image.asset("Assets/Images/logo.png"),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.1,
                      left: width * 0.1,
                      right: width * 0.1),
                  child: TextFormField(
                    obscureText: true,
                    decoration: loginFormField.copyWith(
                        labelText: 'Password',
                        icon:
                        Icon(Icons.lock_outline, color: basicColor)),
                    onChanged: (text) {
                      setState(() => password = text);
                    },
                    validator: (value) {
                      if (!validatePassword(value)) {
                        return 'password must contain 8 characters with atleast \n one lowercase, one uppercase, one digit, \n and one special character';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.02,
                      left: width * 0.1,
                      right: width * 0.1),
                  child: TextFormField(
                    obscureText: true,
                    decoration: loginFormField.copyWith(
                        labelText: 'Re Enter Password',
                        icon:
                        Icon(Icons.lock_outline, color: basicColor)),
                    validator: (value) {
                      if (value != password) {
                        return 'Passowrd do not match';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.1,
                      left: width * 0.1,
                      right: width * 0.1),
                  child: Container(
                    height: height * 0.08,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                      color: basicColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            await http.post(
                              passHash,
                              body: json.decode(
                            '{'
                            '"secret" : $passHashSecret", '
                                '"password": "$password"'
                                '}')).then((response) async {
                                  if(response.statusCode == 200) {
                                    var decodedData =
                                    jsonDecode(
                                        response
                                            .body);
                                    if (decodedData[
                                    "secret"] ==
                                        passHashSecret) {
                                      String hash =
                                      decodedData[
                                      "hash"];
                                      await Firestore
                                          .instance
                                          .collection(
                                          'users')
                                          .document(
                                          widget.email)
                                          .updateData({
                                        'password':
                                        hash,
                                      });
                                      setState(() {
                                        loading = false;
                                      });
                                      Toast.show('Password updated successfully', context);
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                          Wrapper()), (Route<dynamic> route) => false);
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                      Toast.show('Cannot connect server', context);
                                    }
                                  }
                                  else {
                                    setState(() {
                                      loading = false;
                                    });
                                    Toast.show('Cannot connect server', context);
                                  }
                            });
                            var net =
                            await Connectivity().checkConnectivity();
                            if (net == ConnectivityResult.none) {
                              Toast.show(
                                  'No Internet Connection', context,
                                  duration: 5,
                                  backgroundColor: Colors.red);
                              setState(() {
                                loading = false;
                              });
                            }
                          }
                        }),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
