
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
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String selectedValueSingleDialogEllipsis;
  bool toDisplayClear = false, obscure = true;

  String fname = '',
      lname = '',
      email = '',
      dateOfBirth = '',
      password = '',
      error = '';
  String fieldOfStudy = '', state = '', city = '';
  String collegeText, courseText, branchText, batchText;
  Timestamp timestamp;
  List collegeList = [];
  TextEditingController editingController = TextEditingController();

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
            ),
            content: new Text(
                'Your details will not be saved and you will have to start over again !!!'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text(
                  'CANCEL',
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.pop(context);
                },
                child: new Text(
                  'YES',
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
                stream: Firestore.instance.collection('batches').snapshots(),
                builder: (context2, snapshot) {
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
                    collegeList = course.keys.toList();
                    //duplicateCollegeList = List.from(collegeList);
                    // for (int i = 0; i < x.length; i++) {
                    //   var temp = DropdownMenuItem(
                    //     child: Text(
                    //       x[i].toString(),
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //     value: x[i].toString(),
                    //   );
                    //   if (dropdown.contains(temp)) {}
                    //   dropdown.add(temp);
                    // }

                    course.remove('');
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
                                    SizedBox(height: height * 0.02,),
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
                                    SizedBox(height: height * 0.02,),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
                                      decoration: loginFormField.copyWith(
                                          hintText: 'Email ID',
                                          prefixIcon: Icon(EvaIcons.emailOutline,
                                              color: basicColor)),
                                      onChanged: (text) {
                                        setState(() {
                                          error = '';
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
                                    SizedBox(height: height * 0.02,),
                                    TextFormField(
                                      obscureText: obscure,
                                      keyboardType: TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) =>
                                          FocusScope.of(context).nextFocus(),
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
                                  ],
                                ),
                              ),
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
                                          initialValue: collegeText,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]),
                                          decoration: loginFormField.copyWith(
                                              hintText: collegeText ?? "College",
                                              hintStyle: TextStyle(
                                                  color: Colors.black),
                                              prefixIcon: Icon(Icons.school,
                                                  color: basicColor),
                                              suffixIcon: Icon(Icons.delete)),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        String x = await showDialog(
                                            context: context,
                                            builder: (_) {
                                              return MyDialogContent(
                                                listToSearch: collegeList,
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
                                        print(x);
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
                                            hintText: collegeText ?? "College",
                                            hintStyle:
                                                TextStyle(color: Colors.grey[600]),
                                            prefixIcon: Icon(Icons.school,
                                                color: basicColor),
                                            suffixIcon: Icon(Icons.keyboard_arrow_up)
                                          ),
                                        ),
                                      ),
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
                                                  hintText: courseText ?? "Course",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black),
                                                  prefixIcon: Icon(
                                                      Icons
                                                          .collections_bookmark,
                                                      color: basicColor),
                                                  suffixIcon:
                                                      Icon(Icons.delete)),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            String x = await showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return MyDialogContent(
                                                    listToSearch:
                                                        course[collegeText],
                                                  );
                                                });
                                            setState(() {
                                              courseText = x;
                                              if (courseText != null) {
                                                courseSet = true;
                                              }
                                            });
                                            print(x);
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
                                              decoration:
                                                  loginFormField.copyWith(
                                                hintText: "Course",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[600]),
                                                prefixIcon: Icon(
                                                    Icons.collections_bookmark,
                                                    color: basicColor),
                                                suffixIcon: Icon(Icons.keyboard_arrow_up)
                                              ),
                                            ),
                                          ),
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
                                              decoration:
                                                  loginFormField.copyWith(
                                                      hintText: branchText ?? "Branch",
                                                      hintStyle: TextStyle(
                                                          color: Colors.black),
                                                      prefixIcon: Icon(
                                                          Icons.library_books,
                                                          color: basicColor),
                                                      suffixIcon:
                                                          Icon(Icons.delete)),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            String x = await showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return MyDialogContent(
                                                    listToSearch:
                                                        branch[courseText],
                                                  );
                                                });
                                            setState(() {
                                              branchText = x;
                                              if (branchText != null) {
                                                branchSet = true;
                                              }
                                            });
                                            print(x);
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
                                              decoration:
                                                  loginFormField.copyWith(
                                                hintText: "Branch",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[600]),
                                                prefixIcon: Icon(
                                                    Icons.library_books,
                                                    color: basicColor),
                                                suffixIcon: Icon(Icons.keyboard_arrow_up)
                                              ),
                                            ),
                                          ),
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
                                              decoration:
                                                  loginFormField.copyWith(
                                                      hintText: batchText ?? "Batch",
                                                      hintStyle: TextStyle(
                                                          color: Colors.black),
                                                      prefixIcon: Icon(
                                                          Icons.book,
                                                          color: basicColor),
                                                      suffixIcon:
                                                          Icon(Icons.delete)),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            String x = await showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return MyDialogContent(
                                                    listToSearch:
                                                        batch[branchText],
                                                  );
                                                });
                                            setState(() {
                                              batchText = x;
                                              if (batchText != null) {
                                                batchSet = true;
                                                allSet = true;
                                              }
                                            });
                                            print(x);
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
                                              decoration:
                                                  loginFormField.copyWith(
                                                hintText: "Batch",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[600]),
                                                prefixIcon: Icon(Icons.book,
                                                    color: basicColor),
                                                      suffixIcon: Icon(Icons.keyboard_arrow_up)
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: height * 0.05,
                                      left: width * 0.1,
                                      right: width * 0.1),
                                  child: Container(
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
                                                  var net = await Connectivity()
                                                      .checkConnectivity();
                                                  if (net ==
                                                      ConnectivityResult.none) {
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
                                                            courseText,
                                                            branchText,
                                                            batchText,
                                                            batchID[batchText]);
                                                    setState(() {
                                                      loading = false;
                                                    });
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
                                                      Navigator.pop(context);
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
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                }
                                              }),
                                  )),
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
  var items = List<String>();

  @override
  void initState() {
    items.addAll(widget.listToSearch);
    print(items);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(widget.listToSearch);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
        val = query;
        //print(items);
      });

      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.listToSearch);
      });
    }
  }

  _getContent() {
    if (items.isEmpty) {
      return AlertDialog(
        content: Container(
          height: 300,
          width: 300,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: basicColor),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
              ListTile(
                title: Text(val ?? "Not Found?"),
                onTap: () {
                  if (widget.isClg != null && widget.isClg == true) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        (context),
                        MaterialPageRoute(
                            builder: (context) =>
                                CollegeNotFound(phoneNo: widget.phoneNo)));
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
    return AlertDialog(
      content: Container(
        height: 300,
        width: 300,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: basicColor),
                        borderRadius: BorderRadius.all(Radius.circular(6.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${items[index]}'),
                    onTap: () {
                      Navigator.pop(context, '${items[index]}');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }
}
