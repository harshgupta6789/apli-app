import 'package:apli/Services/auth.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/functions.dart';
import 'package:apli/Shared/loading.dart';
import 'package:apli/Shared/scroll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../HomeLoginWrapper.dart';
import 'collegeNotFound.dart';

class Register extends StatefulWidget {
  String phoneNo;
  Register(String phoneNo) {
    this.phoneNo = phoneNo;
  }
  @override
  _RegisterState createState() => _RegisterState();
}

double height, width;

class _RegisterState extends State<Register> {
  // ONCE THE USER VERIFIES THE OTP , HE IS REDIRECTED TO SIGN UP PAGE...//
  // THIS PAGE USES STREAMBUILDER TO FETCH ALL THE DATA REGARDING COLLEGE , COURSE , BATCH ETC //
  // THE FLOW GOES LIKE THIS : USER CHOOSES A COLLEGE => COURSE IS SHOWN ONCE WE GET COLLEGE NAME => SAME WITH BATCH //
  // ONCE USER FILLS ALL THE FIELDS THEN THE REGISTER BUTTON IS MADE CLICKABLE //
  // ALL THE DIALOG BOXES OR DROWPDOWNS ARE PRESENT IN THE SEPARATE UNIFIED CLASS PRESENT AT THE BOTTOM OF THIS DART FILE //

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool obscure = true;

  String fname = '', lname = '', email = '', dateOfBirth = '', password = '';
  String collegeText, yearText, courseText, branchText, batchText;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text(
              'Your details will not be saved and you will have to start over again !!!\n\nAre you sure you want to leave?',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.justify,
            ),
//            content: new Text(
//              'Are you sure you want to leave?',
//              style: TextStyle(fontSize: 12),
//            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => Wrapper(
                                currentTab: 2,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: new Text(
                  'YES',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  Map<String, dynamic> map = {};

  bool collegeSet = false;
  bool yearSet = false;
  bool courseSet = false;
  bool branchSet = false;
  bool batchSet = false;
  bool allSet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        _onWillPop();
        return;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: loading
            ? Loading()
            : StreamBuilder(
                stream: Firestore.instance
                    .collection('batches')
                    .orderBy('college')
                    .snapshots(),
                builder: (context2, snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data.documents.forEach((f) {
                      String collegeTemp = f.data['college'];
                      String yearTemp = f.data['batch_year'];
                      String courseTemp = f.data['course'];
                      String branchTemp = f.data['branch'];
                      String batchTemp = f.data['batch_name'];
                      String batchIDTemp = f.data['batch_id'];

                      if (collegeTemp != null) {
                        if (!map.containsKey(collegeTemp)) {
                          map[collegeTemp] = {};
                        }
                        if (yearTemp != null) {
                          var temp = map[collegeTemp];
                          if (!temp.containsKey(yearTemp)) {
                            temp[yearTemp] = {};
                            map[collegeTemp] = temp;
                          }
                          if (courseTemp != null) {
                            var temp1 = map[collegeTemp][yearTemp];
                            if (!temp1.containsKey(courseTemp)) {
                              temp1[courseTemp] = {};
                              map[collegeTemp][yearTemp] = temp1;
                            }
                            if (branchTemp != null) {
                              var temp2 =
                                  map[collegeTemp][yearTemp][courseTemp];
                              if (!temp2.containsKey(branchTemp)) {
                                temp2[branchTemp] = {};
                                map[collegeTemp][yearTemp][courseTemp] = temp2;
                              }
                              if (batchTemp != null) {
                                var temp3 = map[collegeTemp][yearTemp]
                                    [courseTemp][branchTemp];
                                if (!temp3.containsKey(batchTemp)) {
                                  temp3[batchTemp] = batchIDTemp;
                                  map[collegeTemp][yearTemp][courseTemp]
                                      [branchTemp] = temp3;
                                }
                              }
                            }
                          }
                        }
                      }
                    });
                    return ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.2, right: width * 0.5),
                                child: Image.asset("Assets/Images/logo.png"),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    left: width * 0.1,
                                    right: width * 0.1),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      obscureText: false,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: loginFormField.copyWith(
                                          hintText: 'First Name',
                                          prefixIcon: Icon(
                                            EvaIcons.personOutline,
                                            color: basicColor,
                                          )),
                                      onChanged: (text) {
                                        setState(() => fname = text);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'first name cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: loginFormField.copyWith(
                                          hintText: 'Last Name',
                                          prefixIcon: Icon(
                                            EvaIcons.personAddOutline,
                                            color: basicColor,
                                          )),
                                      onChanged: (text) {
                                        setState(() => lname = text);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'last name cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: loginFormField.copyWith(
                                          hintText: 'Email ID',
                                          prefixIcon: Icon(
                                              EvaIcons.emailOutline,
                                              color: basicColor)),
                                      onChanged: (text) {
                                        setState(() {
                                          email = text;
                                        });
                                      },
                                      validator: (value) {
                                        if (!validateEmail(value)) {
                                          return 'please enter valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    TextFormField(
                                      obscureText: obscure,
                                      enableInteractiveSelection: false,
                                      toolbarOptions: ToolbarOptions(
                                          copy: false,
                                          paste: false,
                                          selectAll: false,
                                          cut: false),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      decoration: loginFormField.copyWith(
                                          hintText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: !obscure
                                                ? Icon(
                                                    EvaIcons.eyeOffOutline,
                                                    color: basicColor,
                                                  )
                                                : Icon(
                                                    EvaIcons.eyeOutline,
                                                    color: Colors.grey,
                                                  ),
                                            onPressed: () {
                                              setState(() {
                                                obscure = !obscure;
                                              });
                                            },
                                          ),
                                          prefixIcon: Icon(EvaIcons.lockOutline,
                                              color: basicColor)),
                                      onChanged: (text) {
                                        setState(() => password = text);
                                      },
                                      validator: (value) {
                                        if (!validatePassword(value)) {
                                          return 'password must contain 8 characters with atleast \n one lowercase, one uppercase, one digit, \n and one special character';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    collegeSet || collegeText != null
                                        ? InkWell(
                                            onTap: () {
                                              setState(() {
                                                collegeText = null;
                                                collegeSet = false;
                                                yearText = null;
                                                yearSet = false;
                                                courseText = null;
                                                courseSet = false;
                                                branchText = null;
                                                branchSet = false;
                                                batchText = null;
                                                batchSet = false;
                                                allSet = false;
                                              });
                                            },
                                            child: TextFormField(
                                              enabled: false,
                                              initialValue: collegeText,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600]),
                                              decoration:
                                                  loginFormField.copyWith(
                                                      hintText: collegeText ??
                                                          "College",
                                                      hintStyle: TextStyle(
                                                          color: Colors.black),
                                                      prefixIcon: Icon(
                                                          Icons.school,
                                                          color: basicColor),
                                                      suffixIcon:
                                                          Icon(Icons.delete)),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();
                                              String x = await showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return MyDialogContent(
                                                      listToSearch:
                                                          map.keys.toList(),
                                                      isClg: true,
                                                      phoneNo: widget.phoneNo,
                                                    );
                                                  });
                                              setState(() {
                                                collegeText = x;
                                                if (collegeText != null) {
                                                  collegeSet = true;
                                                }
                                              });
                                            },
                                            child: TextFormField(
                                              enabled: false,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600]),
                                              decoration:
                                                  loginFormField.copyWith(
                                                      hintText: collegeText ??
                                                          "College",
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[600]),
                                                      prefixIcon: Icon(
                                                          Icons.school,
                                                          color: basicColor),
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_up)),
                                            ),
                                          ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Visibility(
                                      visible: collegeSet,
                                      child: Container(
                                        child: yearSet || yearText != null
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    yearText = null;
                                                    yearSet = false;
                                                    courseText = null;
                                                    courseSet = false;
                                                    branchText = null;
                                                    branchSet = false;
                                                    batchText = null;
                                                    batchSet = false;
                                                    allSet = false;
                                                  });
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                  decoration:
                                                      loginFormField.copyWith(
                                                          hintText: yearText ??
                                                              "Year",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(
                                                              Icons
                                                                  .collections_bookmark,
                                                              color:
                                                                  basicColor),
                                                          suffixIcon: Icon(
                                                              Icons.delete)),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  String x = await showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return MyDialogContent(
                                                          listToSearch:
                                                              map[collegeText]
                                                                  .keys
                                                                  .toList(),
                                                        );
                                                      });
                                                  setState(() {
                                                    yearText = x;
                                                    if (yearText != null) {
                                                      yearSet = true;
                                                    }
                                                  });
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                  decoration: loginFormField.copyWith(
                                                      hintText: "Year",
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[600]),
                                                      prefixIcon: Icon(
                                                          Icons
                                                              .collections_bookmark,
                                                          color: basicColor),
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_up)),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Visibility(
                                      visible: yearSet,
                                      child: Container(
                                        child: courseSet || courseText != null
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    courseText = null;
                                                    courseSet = false;
                                                    branchText = null;
                                                    branchSet = false;
                                                    batchText = null;
                                                    batchSet = false;
                                                    allSet = false;
                                                  });
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                  decoration:
                                                      loginFormField.copyWith(
                                                          hintText:
                                                              courseText ??
                                                                  "Course",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(
                                                              Icons
                                                                  .collections_bookmark,
                                                              color:
                                                                  basicColor),
                                                          suffixIcon: Icon(
                                                              Icons.delete)),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  String x = await showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return MyDialogContent(
                                                          listToSearch:
                                                              map[collegeText]
                                                                      [yearText]
                                                                  .keys
                                                                  .toList(),
                                                        );
                                                      });
                                                  setState(() {
                                                    courseText = x;
                                                    if (courseText != null) {
                                                      courseSet = true;
                                                    }
                                                  });
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                  decoration: loginFormField.copyWith(
                                                      hintText: "Course",
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.grey[600]),
                                                      prefixIcon: Icon(
                                                          Icons
                                                              .collections_bookmark,
                                                          color: basicColor),
                                                      suffixIcon: Icon(Icons
                                                          .keyboard_arrow_up)),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Visibility(
                                      visible: courseSet,
                                      child: Container(
                                        child: branchSet || branchText != null
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    branchText = null;
                                                    branchSet = false;
                                                    batchText = null;
                                                    batchSet = false;
                                                    allSet = false;
                                                  });
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                  decoration:
                                                      loginFormField.copyWith(
                                                          hintText:
                                                              branchText ??
                                                                  "Branch",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(
                                                              Icons
                                                                  .library_books,
                                                              color:
                                                                  basicColor),
                                                          suffixIcon: Icon(
                                                              Icons.delete)),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  String x = await showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return MyDialogContent(
                                                          listToSearch:
                                                              map[collegeText][
                                                                          yearText]
                                                                      [
                                                                      courseText]
                                                                  .keys
                                                                  .toList(),
                                                        );
                                                      });
                                                  setState(() {
                                                    branchText = x;
                                                    if (branchText != null) {
                                                      branchSet = true;
                                                    }
                                                  });
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                  decoration:
                                                      loginFormField.copyWith(
                                                          hintText: "Branch",
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                          prefixIcon: Icon(
                                                              Icons
                                                                  .library_books,
                                                              color:
                                                                  basicColor),
                                                          suffixIcon: Icon(Icons
                                                              .keyboard_arrow_up)),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    Visibility(
                                      visible: branchSet,
                                      child: Container(
                                        child: batchSet || batchText != null
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    batchText = null;
                                                    batchSet = false;
                                                    allSet = false;
                                                  });
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                  decoration:
                                                      loginFormField.copyWith(
                                                          hintText: batchText ??
                                                              "Batch",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          prefixIcon: Icon(
                                                              Icons.book,
                                                              color:
                                                                  basicColor),
                                                          suffixIcon: Icon(
                                                              Icons.delete)),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  String x = await showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return MyDialogContent(
                                                          listToSearch: map[collegeText]
                                                                          [
                                                                          yearText]
                                                                      [
                                                                      courseText]
                                                                  [branchText]
                                                              .keys
                                                              .toList(),
                                                        );
                                                      });
                                                  setState(() {
                                                    batchText = x;
                                                    if (batchText != null) {
                                                      batchSet = true;
                                                      allSet = true;
                                                    }
                                                  });
                                                },
                                                child: TextFormField(
                                                  enabled: false,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[600]),
                                                  decoration:
                                                      loginFormField.copyWith(
                                                          hintText: "Batch",
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .grey[600]),
                                                          prefixIcon: Icon(
                                                              Icons.book,
                                                              color:
                                                                  basicColor),
                                                          suffixIcon: Icon(Icons
                                                              .keyboard_arrow_up)),
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.05,
                                    ),
                                    Container(
                                      height: 70,
                                      width: width * 0.8,
                                      decoration: BoxDecoration(
                                        color: basicColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: MaterialButton(
                                          disabledColor: Colors.grey,
                                          child: Text(
                                            'Register',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          onPressed: !allSet
                                              ? null
                                              : () async {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    var net =
                                                        await Connectivity()
                                                            .checkConnectivity();
                                                    if (net ==
                                                        ConnectivityResult
                                                            .none) {
                                                      showToast(
                                                          'No internet connection',
                                                          context);
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                    } else {
                                                      dynamic result = await _auth
                                                          .registerWithoutAuth(
                                                              fname,
                                                              lname,
                                                              email,
                                                              password,
                                                              widget.phoneNo,
                                                              collegeText,
                                                              yearText,
                                                              courseText,
                                                              branchText,
                                                              batchText,
                                                              map[collegeText][
                                                                              yearText]
                                                                          [
                                                                          courseText]
                                                                      [
                                                                      branchText]
                                                                  [batchText]);
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      if (result != 1) {
                                                        collegeText = null;
                                                        collegeSet = false;
                                                        yearText = null;
                                                        yearSet = false;
                                                        courseText = null;
                                                        courseSet = false;
                                                        branchText = null;
                                                        branchSet = false;
                                                        batchText = null;
                                                        batchSet = false;
                                                        allSet = false;
                                                      }
                                                      if (result == -1) {
                                                        //already exists
                                                        showToast(
                                                            'Account already exists, try logging in',
                                                            context);
                                                      } else if (result == -2) {
                                                        //server
                                                        showToast(
                                                            'Could not connect to server',
                                                            context);
                                                      } else if (result == 0) {
                                                        //failed
                                                        showToast(
                                                            'Failed, try again later',
                                                            context);
                                                        //Navigator.pop(context);
                                                      } else if (result == 1) {
                                                        //success
                                                        showToast(
                                                            'Successfully registered, kindly login again',
                                                            context);
                                                        Navigator.of(context)
                                                            .pushAndRemoveUntil(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Wrapper()),
                                                                (Route<dynamic>
                                                                        route) =>
                                                                    false);
                                                      } else {
                                                        showToast(
                                                            'Failed, try again later',
                                                            context);
                                                        //Navigator.pop(context);
                                                      }
                                                    }
                                                  }
                                                }),
                                    ),
                                    SizedBox(
                                      height: height * 0.05,
                                    ),
                                    Center(child: Text('Welcome Aboard!!')),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else
                    return Loading();
                },
              ),
      ),
    );
  }
}

class MyDialogContent extends StatefulWidget {
  MyDialogContent({
    Key key,
    this.listToSearch,
    this.phoneNo,
    this.isClg,
  }) : super(key: key);
  final listToSearch;
  final String phoneNo;
  final bool isClg;

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  TextEditingController editingController = TextEditingController();
  String val;
  var items = List<dynamic>();

  @override
  void initState() {
    items.addAll(widget.listToSearch);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<dynamic> dummySearchList = List<dynamic>();
    dummySearchList.addAll(widget.listToSearch);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      query = query.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), "");
      query = query.replaceAll(new RegExp(r'[^\w\s]+'), '');
      print(query);
      dummySearchList.forEach((item) {
        String temp = item;
        temp = temp.replaceAll(new RegExp(r"\s+\b|\b\s|\s|\b"), "");
        temp = temp.replaceAll(new RegExp(r'[^\w\s]+'), '');
        if (temp.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
        val = query;
      });

      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.listToSearch);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              autofocus: false,
              controller: editingController,
              decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: basicColor),
                      borderRadius: BorderRadius.all(Radius.circular(6.0)))),
            ),
            SizedBox(
              height: 15,
            ),
            items.isEmpty
                ? ListTile(
                    title: Text(
                      widget.isClg == true
                          ? "College Not found?"
                          : "Please choose from the list",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: basicColor),
                    ),
                    onTap: () {
                      if (widget.isClg != null && widget.isClg == true) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            (context),
                            MaterialPageRoute(
                                builder: (context) =>
                                    CollegeNotFound(phoneNo: widget.phoneNo)));
                      }
                    })
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            '${items[index]}',
                          ),
                          onTap: () {
                            Navigator.pop(context, '${items[index]}');
                          },
                          subtitle: Divider(thickness: 2),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
