import 'dart:convert';

import 'package:apli/Screens/Login-Signup/review.dart';
import 'package:apli/Services/mailer.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

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
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String fname = '',
      lname = '',
      email = '',
      dateOfBirth = '',
      password = '',
      error = '';
  String fieldOfStudy = '', state = '', city = '';
  String collegeText, courseText, branchText, batchText;
  Timestamp timestamp;

  bool validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    if (value.length < 8) {
      return false;
    } else {
      if (!regex.hasMatch(value))
        return false;
      else
        return true;
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
              style: TextStyle(color: basicColor),
            ),
            content: new Text(
                'Your details will not be saved and you will have to start over again !!!'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'CANCEL',
                  style: TextStyle(color: basicColor),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.pop(context);
                },
                child: new Text(
                  'YES',
                  style: TextStyle(color: basicColor),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  Map<String, List<String>> course = {
    '': ['']
  };
  Map<String, List<String>> branch = {
    '': ['']
  };
  Map<String, List<String>> batch = {
    '': ['']
  };
  Map<String, String> batchID = {'': ''};

  bool collegeSet = false;
  bool courseSet = false;
  bool branchSet = false;
  bool batchSet = false;
  bool allSet = false;

  bool collegeNotFound = false;

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
        body: loading
            ? Loading()
            : StreamBuilder(
                stream: Firestore.instance.collection('batches').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    snapshot.data.documents.forEach((f) {
                      String collegeTemp = f.data['college'];
                      String courseTemp = f.data['course'];
                      String branchTemp = f.data['branch'];
                      String batchTemp = f.data['batch_name'];
                      String batchIDTemp = f.data['batch_id'];

                      batchID[batchTemp] = batchIDTemp;

                      if (collegeTemp != null) {
                        if (!course.containsKey(collegeTemp)) {
                          course[collegeTemp] = [];
                        }
                        if (courseTemp != null) {
                          var temp1 = course[collegeTemp];
                          if (!temp1.contains(courseTemp)) {
                            temp1.add(courseTemp);
                            course[collegeTemp] = temp1;
                            branch[courseTemp] = [];
                          }
                          if (branchTemp != null) {
                            var temp2 = branch[courseTemp];
                            if (!temp2.contains(branchTemp)) {
                              temp2.add(branchTemp);
                              branch[courseTemp] = temp2;
                              batch[branchTemp] = [];
                            }
                            if (batchTemp != null) {
                              var temp3 = batch[branchTemp];
                              if (!temp3.contains(batchTemp)) {
                                temp3.add(batchTemp);
                                batch[branchTemp] = temp3;
                              }
                            }
                          }
                        }
                      }
                    });
                    course.remove('');
                    return SingleChildScrollView(
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
                                child: TextFormField(
                                  obscureText: false,
                                  decoration: loginFormField.copyWith(
                                      labelText: 'First Name',
                                      icon: Icon(
                                        Icons.person,
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
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    left: width * 0.1,
                                    right: width * 0.1),
                                child: TextFormField(
                                  obscureText: false,
                                  decoration: loginFormField.copyWith(
                                      labelText: 'Last Name',
                                      icon: Icon(
                                        Icons.person_add,
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
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.02,
                                    left: width * 0.1,
                                    right: width * 0.1),
                                child: TextFormField(
                                  obscureText: false,
                                  decoration: loginFormField.copyWith(
                                      labelText: 'Email ID',
                                      icon:
                                          Icon(Icons.email, color: basicColor)),
                                  onChanged: (text) {
                                    setState(() {
                                      error = '';
                                      email = text;
                                    });
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'please enter valid email';
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
                                      labelText: 'Password',
                                      icon: Icon(Icons.vpn_key,
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
                                )),
                            collegeSet || collegeText != null
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        collegeText = null;
                                        collegeSet = false;
                                        courseText = null;
                                        courseSet = false;
                                        branchText = null;
                                        branchSet = false;
                                        batchText = null;
                                        batchSet = false;
                                        allSet = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: height * 0.02,
                                          left: width * 0.1,
                                          right: width * 0.1),
                                      child: TextFormField(
                                        enabled: false,
                                        onChanged: (text) {
                                          setState(() {
                                            collegeText = text;
                                          });
                                        },
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]),
                                        decoration: loginFormField.copyWith(
                                            labelText: collegeText,
                                            icon: Icon(Icons.school,
                                                color: basicColor),
                                            suffixIcon: Icon(Icons.delete)),
                                      ),
                                    ),
                                  )
                                : SearchWidget<String>(
                                    dataList: course.keys.toList(),
                                    hideSearchBoxWhenItemSelected: false,
                                    listContainerHeight:
                                        MediaQuery.of(context).size.height / 4,
                                    queryBuilder:
                                        (String query, List<String> list) {
                                      return list.where((String item) {
                                        return item
                                            .toLowerCase()
                                            .contains(query.toLowerCase());
                                      }).toList();
                                    },
                                    popupListItemBuilder: (String item) {
                                      return PopupListItemWidget(item);
                                    },
                                    selectedItemBuilder: (String selectedItem,
                                        VoidCallback deleteSelectedItem) {
                                      return Container();
                                    },
                                    onItemSelected: (item) {
                                      setState(() {
                                        collegeText = item;
                                        collegeSet = true;
                                        collegeNotFound = false;
                                        allSet = false;
                                      });
                                      if (course[item].length == 0)
                                        setState(() {
                                          allSet = true;
                                          collegeSet = false;
                                        });
                                    },
                                    // widget customization
                                    noItemsFoundWidget: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.folder_open,
                                          size: 24,
                                          color:
                                              Colors.grey[900].withOpacity(0.7),
                                        ),
                                        const SizedBox(width: 10),
                                        FlatButton(
                                          onPressed: () {
                                            setState(() {
                                              collegeNotFound = true;
                                              allSet = true;
                                            });
                                          },
                                          child: Text(
                                            "College not found?",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: basicColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    textFieldBuilder:
                                        (TextEditingController controller,
                                            FocusNode focusNode) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            top: height * 0.02,
                                            left: width * 0.1,
                                            right: width * 0.1),
                                        child: TextFormField(
                                          controller: controller,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]),
                                          decoration: loginFormField.copyWith(
                                              labelText: 'College Name',
                                              icon: Icon(
                                                Icons.school,
                                                color: basicColor,
                                              )),
                                        ),
                                      );
                                    },
                                  ),
                            Visibility(
                              visible: collegeSet,
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
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.02,
                                              left: width * 0.1,
                                              right: width * 0.1),
                                          child: TextFormField(
                                            enabled: false,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600]),
                                            decoration: loginFormField.copyWith(
                                                labelText: courseText,
                                                icon: Icon(
                                                    Icons.collections_bookmark,
                                                    color: basicColor),
                                                suffixIcon: Icon(Icons.delete)),
                                          ),
                                        ),
                                      )
                                    : SearchWidget<String>(
                                        dataList: course[collegeText],
                                        hideSearchBoxWhenItemSelected: false,
                                        listContainerHeight:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        queryBuilder:
                                            (String query, List<String> list) {
                                          return list.where((String item) {
                                            return item
                                                .toLowerCase()
                                                .contains(query.toLowerCase());
                                          }).toList();
                                        },
                                        popupListItemBuilder: (String item) {
                                          return PopupListItemWidget(item);
                                        },
                                        selectedItemBuilder: (String
                                                selectedItem,
                                            VoidCallback deleteSelectedItem) {
                                          return Container();
                                        },
                                        onItemSelected: (item) {
                                          setState(() {
                                            courseText = item;
                                            courseSet = true;
                                          });
                                          if (branch[item].length == 0)
                                            setState(() {
                                              allSet = true;
                                              courseSet = false;
                                            });
                                        },
                                        // widget customization
                                        noItemsFoundWidget: NoItemsFound(),
                                        textFieldBuilder:
                                            (TextEditingController controller,
                                                FocusNode focusNode) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                top: height * 0.02,
                                                left: width * 0.1,
                                                right: width * 0.1),
                                            child: TextFormField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600]),
                                              decoration:
                                                  loginFormField.copyWith(
                                                      labelText: 'Course',
                                                      icon: Icon(
                                                        Icons
                                                            .collections_bookmark,
                                                        color: basicColor,
                                                      )),
                                            ),
                                          );
                                        },
                                      ),
                              ),
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
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.02,
                                              left: width * 0.1,
                                              right: width * 0.1),
                                          child: TextFormField(
                                            enabled: false,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600]),
                                            decoration: loginFormField.copyWith(
                                                labelText: branchText,
                                                icon: Icon(Icons.library_books,
                                                    color: basicColor),
                                                suffixIcon: Icon(Icons.delete)),
                                          ),
                                        ),
                                      )
                                    : SearchWidget<String>(
                                        dataList: branch[courseText],
                                        hideSearchBoxWhenItemSelected: false,
                                        listContainerHeight:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        queryBuilder:
                                            (String query, List<String> list) {
                                          return list.where((String item) {
                                            return item
                                                .toLowerCase()
                                                .contains(query.toLowerCase());
                                          }).toList();
                                        },
                                        popupListItemBuilder: (String item) {
                                          return PopupListItemWidget(item);
                                        },
                                        selectedItemBuilder: (String
                                                selectedItem,
                                            VoidCallback deleteSelectedItem) {
                                          return Container();
                                        },
                                        onItemSelected: (item) {
                                          setState(() {
                                            branchText = item;
                                            branchSet = true;
                                          });
                                          if (batch[item].length == 0)
                                            setState(() {
                                              allSet = true;
                                              branchSet = false;
                                            });
                                        },
                                        // widget customization
                                        noItemsFoundWidget: NoItemsFound(),
                                        textFieldBuilder:
                                            (TextEditingController controller,
                                                FocusNode focusNode) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                top: height * 0.02,
                                                left: width * 0.1,
                                                right: width * 0.1),
                                            child: TextFormField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600]),
                                              decoration:
                                                  loginFormField.copyWith(
                                                      labelText: 'Branch',
                                                      icon: Icon(
                                                        Icons.library_books,
                                                        color: basicColor,
                                                      )),
                                            ),
                                          );
                                        },
                                      ),
                              ),
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
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.02,
                                              left: width * 0.1,
                                              right: width * 0.1),
                                          child: TextFormField(
                                            enabled: false,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600]),
                                            decoration: loginFormField.copyWith(
                                                labelText: batchText,
                                                icon: Icon(Icons.book,
                                                    color: basicColor),
                                                suffixIcon: Icon(Icons.delete)),
                                          ),
                                        ),
                                      )
                                    : SearchWidget<String>(
                                        dataList: batch[branchText],
                                        hideSearchBoxWhenItemSelected: false,
                                        listContainerHeight:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        queryBuilder:
                                            (String query, List<String> list) {
                                          return list.where((String item) {
                                            return item
                                                .toLowerCase()
                                                .contains(query.toLowerCase());
                                          }).toList();
                                        },
                                        popupListItemBuilder: (String item) {
                                          return PopupListItemWidget(item);
                                        },
                                        selectedItemBuilder: (String
                                                selectedItem,
                                            VoidCallback deleteSelectedItem) {
                                          return Container();
                                        },
                                        onItemSelected: (item) {
                                          setState(() {
                                            batchText = item;
                                            batchSet = true;
                                            allSet = true;
                                          });
                                        },
                                        // widget customization
                                        noItemsFoundWidget: NoItemsFound(),
                                        textFieldBuilder:
                                            (TextEditingController controller,
                                                FocusNode focusNode) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                top: height * 0.02,
                                                left: width * 0.1,
                                                right: width * 0.1),
                                            child: TextFormField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600]),
                                              decoration:
                                                  loginFormField.copyWith(
                                                      labelText: 'Batch',
                                                      icon: Icon(
                                                        Icons.book,
                                                        color: basicColor,
                                                      )),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            Visibility(
                              visible: collegeNotFound,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height * 0.02,
                                          left: width * 0.1,
                                          right: width * 0.1),
                                      child: TextFormField(
                                        obscureText: false,
                                        decoration: loginFormField.copyWith(
                                            labelText: 'Field of Study',
                                            icon: Icon(
                                              Icons.book,
                                              color: basicColor,
                                            )),
                                        onChanged: (text) {
                                          setState(() => fieldOfStudy = text);
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'field of study cannot be empty';
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
                                        obscureText: false,
                                        decoration: loginFormField.copyWith(
                                            labelText: 'State',
                                            icon: Icon(
                                              Icons.location_on,
                                              color: basicColor,
                                            )),
                                        onChanged: (text) {
                                          setState(() => state = text);
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'state cannot be empty';
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
                                        obscureText: false,
                                        decoration: loginFormField.copyWith(
                                            labelText: 'City',
                                            icon: Icon(Icons.location_city,
                                                color: basicColor)),
                                        onChanged: (text) {
                                          setState(() => city = text);
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'city cannot be empty';
                                          }
                                          return null;
                                        },
                                      )),
                                ],
                              ),
                            ),
                            Visibility(
                                visible: allSet || collegeNotFound,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.05,
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
                                            'Register',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              if (!collegeNotFound) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                DocumentReference temp =
                                                    Firestore.instance
                                                        .collection('users')
                                                        .document(email);
                                                var getDoc =
                                                    await temp.get().then((doc) {
                                                  if (doc.exists) {
                                                    Toast.show(
                                                        'Account already exists',
                                                        context);
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  } else {
                                                    try {
                                                      Future.wait([
                                                        Firestore.instance
                                                            .collection(
                                                                'candidates')
                                                            .document(email)
                                                            .setData({
                                                          'First_name': fname,
                                                          'Last_name': lname,
                                                          'email': email,
                                                          'name': fname +
                                                              ' ' +
                                                              lname,
                                                          'ph_no':
                                                              widget.phoneNo,
                                                          'batch_id': batchID[
                                                              batchText],
                                                        }),
                                                        Firestore.instance
                                                            .collection(
                                                                'rel_batch_candidates')
                                                            .document(batchID[
                                                                batchText])
                                                            .setData({
                                                          'batch_id': batchID[
                                                              batchText],
                                                          'candidate_id': email
                                                        }),
                                                        http
                                                            .post(
                                                                "https://staging.apli.ai/accounts/passHash",
                                                                body: json.decode(
                                                                    '{'
                                                                    '"secret" : "h&%RD89itr#\$dTHioG\$s", '
                                                                    '"password": "$password"'
                                                                    '}'))
                                                            .then(
                                                                (response) async {
                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            var decodedData =
                                                                jsonDecode(
                                                                    response
                                                                        .body);
                                                            if (decodedData[
                                                                    "secret"] ==
                                                                "h&%RD89itr#\$dTHioG\$s") {
                                                              String hash =
                                                                  decodedData[
                                                                      "hash"];
                                                              await Firestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .document(
                                                                      email)
                                                                  .setData({
                                                                'name': fname +
                                                                    '' +
                                                                    lname,
                                                                'password':
                                                                    hash,
                                                                'timestamp':
                                                                    Timestamp
                                                                        .now(),
                                                                'user_type':
                                                                    'Candidate'
                                                              });
                                                            } else
                                                              Toast.show(
                                                                  'Could not connect to server',
                                                                  context);
                                                          } else
                                                            Toast.show(
                                                                'Could not connect to server',
                                                                context);
                                                        })
                                                      ]);
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                    } catch (e) {
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                      Toast.show(
                                                          'Signup failed',
                                                          context);
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                });

                                                var net = await Connectivity()
                                                    .checkConnectivity();
                                                if (net ==
                                                    ConnectivityResult.none) {
                                                  Toast.show(
                                                      'No internet connection',
                                                      context);
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                }
                                              } else if (collegeNotFound) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                //add to excel sheet
                                                MailerService(
                                                    username: apliEmailID,
                                                    password: apliPassword,
                                                    college: collegeText,
                                                    state: state,
                                                    city: city);
                                                setState(() {
                                                  loading = false;
                                                });

                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Review(false)));
                                              }
                                            }
                                          }),
                                    ))),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.05,
                                    left: width * 0.1,
                                    right: width * 0.1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Welcome Aboard!!'),
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
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

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "Please choose from the list",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item);

  final String item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
