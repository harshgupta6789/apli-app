
import 'package:apli/Services/auth.dart';
import 'package:apli/Services/database.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_widget/search_widget.dart';
import 'package:string_validator/string_validator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneNo extends StatefulWidget {
  @override
  _VerifyPhoneNoState createState() => _VerifyPhoneNoState();
}

double height, width;
AuthCredential globalCredential;
bool register = false;

class _VerifyPhoneNoState extends State<VerifyPhoneNo> {

  String countryCode = '+91';
  bool loading = false;
  String error = '';
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      setState(() {
        loading = false;
      });
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('1');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
            print(verificationId);
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
            print('verification complete');
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message} verification failed');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                PinCodeTextField(
                  length: 6,
                  activeFillColor: basicColor,
                  activeColor: basicColor,
                  inactiveFillColor: Colors.black,
                  selectedColor: basicColor,
                  inactiveColor: Colors.black,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  shape: PinCodeFieldShape.box,
                  animationDuration: Duration(milliseconds: 300),
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  onChanged: (value) {
                    setState(() {
                      this.smsOTP = value;
                    });
                  },
                ),
                (errorMessage != ''
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Verify'),
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      print('user not null');
                      setState(() {
                        loading = false;
                      });
                      setState(() {
                        loading = false;
                        register = true;
                      });
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));

                      setState(() {
                        register = true;
                      });

                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      globalCredential = credential;
//      final AuthResult result = await _auth.signInWithCredential(credential);
//      final FirebaseUser user = result.user;
//      user.updateEmail('mnm@gmail.com');
//      assert(user.uid == user.uid);
      print('sign in');
      setState(() {
        loading = false;
        register = true;
      });
      Navigator.of(context).pop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register()));
      setState(() {
        register = true;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('invalid case');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return loading ? Loading() : Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          child: Container(
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.only(left: 80, top: 10, bottom: 5),
              child: Row(
                children: <Widget>[
                  Text('Already have an account? ', style: TextStyle(color: Colors.white),),
                  FlatButton(
                    child: Text('Sign In', style: TextStyle(color: Colors.blue),),
                    onPressed: (){Navigator.pop(context);},
                  )
                ],
              ),
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text("Let's get you signed up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 100,),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                          title: _buildCountryPickerDropdown(hasPriorityList: true)),
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Text('By signing up, you are agreeing to our terms & conditions'),
                Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.05, left: width * 0.1, right: width * 0.1),
                    child: Container(
                      height: height * 0.08,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: basicColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                          child: Text(
                            'Sign Up',
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
                              var net = await Connectivity().checkConnectivity();
                              if(net == ConnectivityResult.none) {
                                setState(() {
                                  error = 'No Internet Connection';
                                });
                              }
                              verifyPhone();
                            }

                          }),
                    )),
                SizedBox(height: 100,),
                Center(
                  child: Text('Or Sign Up With'),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Image.asset("Assets/Images/logo.png"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildCountryPickerDropdown(
      {bool filtered = false,
        bool sortedByIsoCode = false,
        bool hasPriorityList = false}) =>
      Row(
        children: <Widget>[
          CountryPickerDropdown(
            initialValue: 'IN',
            itemBuilder: _buildDropdownItem,
            itemFilter: filtered
                ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
                : null,
            priorityList: hasPriorityList
                ? [
              CountryPickerUtils.getCountryByIsoCode('IN'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ]
                : null,
            sortComparator: sortedByIsoCode
                ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
                : null,
            onValuePicked: (Country country) {
              setState(() {
                countryCode = country.isoCode;
              });
              print("${country.name}");
            },
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Mobile No'
              ),
              onChanged: (text) {
                setState(() => phoneNo = countryCode + text);
              },
              validator: (value) {
                if (value.length != 10 && isNumeric(value)) {
                  return 'invalid phone number';
                }
                return null;
              },
            ),
          )
        ],
      );

  Widget _buildDropdownItem(Country country) => Container(
    child: Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Text("+${country.phoneCode}(${country.isoCode})"),
      ],
    ),
  );

}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String fname = '',lname = '', email = '', phone = '', dateOfBirth = '', password = '', error = '';
  String fieldOfStudy = '', state = '', city = '';
  String collegeText = '', courseText = '', branchText = '', batchText;
  Timestamp timestamp;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

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

  Map<String, List<String>> course = {'' : ['']};
  Map<String, List<String>> branch = {'' : ['']};
  Map<String, List<String>> batch = {'' : ['']};

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



    return loading ? Loading() : WillPopScope(
      onWillPop: () {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        return ;
      },
      child: Scaffold(
        body: StreamBuilder(
          stream: Firestore.instance.collection('batches').snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData) {
              snapshot.data.documents.forEach((f) {
                String collegeTemp = f.data['college'];
                String courseTemp = f.data['course'];
                String branchTemp = f.data['branch'];
                String batchTemp = f.data['batch_name'];

                if(collegeTemp != null) {
                  if(!course.containsKey(collegeTemp)) {
                    course[collegeTemp] = [];
                  }
                  if(courseTemp != null) {
                    var temp1 = course[collegeTemp];
                    if(!temp1.contains(courseTemp)) {
                      temp1.add(courseTemp);
                      course[collegeTemp] = temp1;
                      branch[courseTemp] = [];
                    }
                    if(branchTemp != null) {
                      var temp2 = branch[courseTemp];
                      if(!temp2.contains(branchTemp)) {
                        temp2.add(branchTemp);
                        branch[courseTemp] = temp2;
                        batch[branchTemp] = [];
                      }
                      if(batchTemp != null) {
                        var temp3 = batch[branchTemp];
                        if(!temp3.contains(batchTemp)) {
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
                        padding: EdgeInsets.only(top: height * 0.2, right: width * 0.5),
                        child: Image.asset("Assets/Images/logo.png"),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.02, left: width * 0.1, right: width * 0.1),
                          child: TextFormField(
                            obscureText: false,
                            decoration: loginFormField.copyWith(labelText: 'First Name', icon: Icon(Icons.person, color: basicColor,)),
                            onChanged: (text) {
                              setState(() => fname = text);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'first name cannot be empty';
                              }
                              return null;
                            },
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.02, left: width * 0.1, right: width * 0.1),
                          child: TextFormField(
                            obscureText: false,
                            decoration: loginFormField.copyWith(labelText: 'Last Name', icon: Icon(Icons.person_add, color: basicColor,)),
                            onChanged: (text) {
                              setState(() => lname = text);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'last name cannot be empty';
                              }
                              return null;
                            },
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.02, left: width * 0.1, right: width * 0.1),
                          child: TextFormField(
                            obscureText: false,
                            decoration: loginFormField.copyWith(labelText: 'Email ID', icon: Icon(Icons.email, color: basicColor)),
                            onChanged: (text) {
                              setState(() => email = text);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter valid email';
                              }
                              return null;
                            },
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.02, left: width * 0.1, right: width * 0.1),
                          child: TextFormField(
                            obscureText: true,
                            decoration: loginFormField.copyWith(labelText: 'Password', icon: Icon(Icons.vpn_key, color: basicColor)),
                            onChanged: (text) {
                              setState(() => password = text);
                            },
                            validator: (value) {
                              if (!validatePassword(value)) {
                                return 'password must contain 8 characters with atleast one lowercase, one uppercase, one digit, and one special character';
                              }
                              return null;
                            },
                          )
                      ),
                      collegeSet ? InkWell(
                        onTap: (){
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
                              top: height * 0.02, left: width * 0.1, right: width * 0.1),
                          child: TextFormField(
                            enabled: false,
                            onChanged: (text){
                              setState(() {
                                collegeText = text;
                              });
                            },
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            decoration: loginFormField.copyWith(labelText: collegeText, icon: Icon(Icons.school, color: basicColor), suffixIcon: Icon(Icons.delete)),
                          ),
                        ),
                      ) :
                      SearchWidget<String>(
                        dataList: course.keys.toList(),
                        hideSearchBoxWhenItemSelected: false,
                        listContainerHeight: MediaQuery.of(context).size.height / 4,
                        queryBuilder: (String query, List<String> list) {
                          return list.where((String item) {
                            return item.toLowerCase().contains(query.toLowerCase());
                          }).toList();
                        },
                        popupListItemBuilder: (String item) {
                          return PopupListItemWidget(item);
                        },
                        selectedItemBuilder: (String selectedItem, VoidCallback deleteSelectedItem) {
                          return Container();
                        },
                        onItemSelected: (item){
                          setState(() {
                            collegeText = item;
                            collegeSet = true;
                            collegeNotFound = false;
                            allSet = false;
                          });
                        },
                        // widget customization
                        noItemsFoundWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.folder_open,
                              size: 24,
                              color: Colors.grey[900].withOpacity(0.7),
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
                        textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.02, left: width * 0.1, right: width * 0.1),
                            child: TextFormField(
                              controller: controller,
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              decoration: loginFormField.copyWith(labelText: 'College Name', icon: Icon(Icons.school, color: basicColor,)),
                            ),
                          );
                        },
                      ),
                      Visibility(
                        visible: collegeSet,
                        child: IgnorePointer(
                          ignoring: !collegeSet,
                          child: AnimatedOpacity(
                            opacity: collegeSet ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              child: courseSet ? InkWell(
                                onTap: (){
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
                                      top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                  child: TextFormField(
                                    enabled: false,
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                    decoration: loginFormField.copyWith(labelText: courseText, icon: Icon(Icons.school, color: basicColor), suffixIcon: Icon(Icons.delete)),
                                  ),
                                ),
                              ) :
                              SearchWidget<String>(
                                dataList: course[collegeText],
                                hideSearchBoxWhenItemSelected: false,
                                listContainerHeight: MediaQuery.of(context).size.height / 4,
                                queryBuilder: (String query, List<String> list) {
                                  return list.where((String item) {
                                    return item.toLowerCase().contains(query.toLowerCase());
                                  }).toList();
                                },
                                popupListItemBuilder: (String item) {
                                  return PopupListItemWidget(item);
                                },
                                selectedItemBuilder: (String selectedItem, VoidCallback deleteSelectedItem) {
                                  return Container();
                                },
                                onItemSelected: (item){
                                  setState(() {
                                    courseText = item;
                                    courseSet = true;
                                  });
                                },
                                // widget customization
                                noItemsFoundWidget: NoItemsFound(),
                                textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                    child: TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                      decoration: loginFormField.copyWith(labelText: 'Course', icon: Icon(Icons.school, color: basicColor,)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: courseSet,
                        child: IgnorePointer(
                          ignoring: !courseSet,
                          child: AnimatedOpacity(
                            opacity: courseSet ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              child: branchSet ? InkWell(
                                onTap: (){
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
                                      top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                  child: TextFormField(
                                    enabled: false,
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                    decoration: loginFormField.copyWith(labelText: branchText, icon: Icon(Icons.school, color: basicColor), suffixIcon: Icon(Icons.delete)),
                                  ),
                                ),
                              ) :
                              SearchWidget<String>(
                                dataList: branch[courseText],
                                hideSearchBoxWhenItemSelected: false,
                                listContainerHeight: MediaQuery.of(context).size.height / 4,
                                queryBuilder: (String query, List<String> list) {
                                  return list.where((String item) {
                                    return item.toLowerCase().contains(query.toLowerCase());
                                  }).toList();
                                },
                                popupListItemBuilder: (String item) {
                                  return PopupListItemWidget(item);
                                },
                                selectedItemBuilder: (String selectedItem, VoidCallback deleteSelectedItem) {
                                  return Container();
                                },
                                onItemSelected: (item){
                                  setState(() {
                                    branchText = item;
                                    branchSet = true;
                                  });
                                },
                                // widget customization
                                noItemsFoundWidget: NoItemsFound(),
                                textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                    child: TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                      decoration: loginFormField.copyWith(labelText: 'Branch', icon: Icon(Icons.school, color: basicColor,)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: branchSet,
                        child: IgnorePointer(
                          ignoring: !branchSet,
                          child: AnimatedOpacity(
                            opacity: branchSet ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              child: batchSet ? InkWell(
                                onTap: (){
                                  setState(() {
                                    batchText = null;
                                    batchSet = false;
                                    allSet = false;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                  child: TextFormField(
                                    enabled: false,
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                    decoration: loginFormField.copyWith(labelText: batchText, icon: Icon(Icons.school, color: basicColor), suffixIcon: Icon(Icons.delete)),
                                  ),
                                ),
                              ) :
                              SearchWidget<String>(
                                dataList: batch[branchText],
                                hideSearchBoxWhenItemSelected: false,
                                listContainerHeight: MediaQuery.of(context).size.height / 4,
                                queryBuilder: (String query, List<String> list) {
                                  return list.where((String item) {
                                    return item.toLowerCase().contains(query.toLowerCase());
                                  }).toList();
                                },
                                popupListItemBuilder: (String item) {
                                  return PopupListItemWidget(item);
                                },
                                selectedItemBuilder: (String selectedItem, VoidCallback deleteSelectedItem) {
                                  return Container();
                                },
                                onItemSelected: (item){
                                  setState(() {
                                    batchText = item;
                                    batchSet = true;
                                    allSet = true;
                                  });
                                },
                                // widget customization
                                noItemsFoundWidget: NoItemsFound(),
                                textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                    child: TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                      decoration: loginFormField.copyWith(labelText: 'Batch', icon: Icon(Icons.school, color: basicColor,)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: collegeNotFound,
                        child: IgnorePointer(
                          ignoring: !collegeNotFound,
                          child: AnimatedOpacity(
                            opacity: collegeNotFound ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                    child: TextFormField(
                                      obscureText: false,
                                      decoration: loginFormField.copyWith(labelText: 'Field of Study', icon: Icon(Icons.book, color: basicColor,)),
                                      onChanged: (text) {
                                        setState(() => fieldOfStudy = text);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'field of study cannot be empty';
                                        }
                                        return null;
                                      },
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                    child: TextFormField(
                                      obscureText: false,
                                      decoration: loginFormField.copyWith(labelText: 'State', icon: Icon(Icons.location_on, color: basicColor,)),
                                      onChanged: (text) {
                                        setState(() => state = text);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'state cannot be empty';
                                        }
                                        return null;
                                      },
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: height * 0.02, left: width * 0.1, right: width * 0.1),
                                    child: TextFormField(
                                      obscureText: false,
                                      decoration: loginFormField.copyWith(labelText: 'City', icon: Icon(Icons.location_city, color: basicColor)),
                                      onChanged: (text) {
                                        setState(() => city = text);
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'city cannot be empty';
                                        }
                                        return null;
                                      },
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: allSet,
                        child: IgnorePointer(
                          ignoring: !allSet,
                          child: AnimatedOpacity(
                            opacity: allSet ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.05, left: width * 0.1, right: width * 0.1),
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
                                        if (_formKey.currentState.validate()) {

                                          final AuthResult result = await FirebaseAuth.instance.signInWithCredential(globalCredential);
                                          final FirebaseUser user = result.user;
                                          user.updateEmail(email);
                                          user.updatePassword(password);
                                          Future.wait([
                                            DatabaseService(uid: user.uid, email: email).updateUserInfo(
                                                fname + '' + lname, password, Timestamp.now(), 'Candidate'
                                            ),
                                          ]);
                                          Navigator.pop(context);
                                          register = false;
                                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeLoginWrapper()));
                                          var net = await Connectivity().checkConnectivity();
                                          if(net == ConnectivityResult.none) {
                                            setState(() {
                                              error = 'No Internet Connection';
                                            });
                                          }
                                        }

                                      }),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: height * 0.05, left: width * 0.1, right: width * 0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Welcome Aboard!!'),
                            ],
                          )),
                      SizedBox(height: 10,),
                      Text(error, style: TextStyle(color: Colors.red),)
                    ],
                  ),
                ),
              );
            } else return Loading();
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
