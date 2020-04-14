import 'package:apli/Services/database.dart';
import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search_widget/search_widget.dart';
import '../../Services/auth.dart';
import '../../Shared/constants.dart';

double height, width;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String name = '', email = '', phone = '', dateOfBirth = '', password = '', error = '';
  String collegeText = '', courseText = '', branchText = '', batchText;
  Timestamp timestamp;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  TextEditingController _controllerCollege = new TextEditingController();

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

  Map<String, List<String>> course = {};
  Map<String, List<String>> branch = {};
  Map<String, List<String>> batch = {};

  bool collegeSet = false;
  bool courseSet = false;
  bool branchSet = false;
  bool batchSet = false;
  bool allSet = false;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    return loading ? Loading() : WillPopScope(
      onWillPop: () => FirebaseAuth.instance.signOut(),
      child: Scaffold(
        body: StreamBuilder(
          stream: Firestore.instance.collection('batches').snapshots(),
          builder: (context, snapshot){
            if(snapshot.hasData) {
              snapshot.data.documents.forEach((f) {
                if(!course.containsKey(f.data['college'])) {
                  if(f.data['college'] != null) course[f.data['college']] = [f.data['course']];
                  if(f.data['course'] != null) branch[f.data['course']] = [f.data['branch']];
                  if(f.data['branch'] != null) batch[f.data['branch']] = [f.data['batch_name']];
                }
                List<String> temp1 = course[f.data['college']];
                if(!temp1.contains(f.data['course'])) {
                  temp1.add(f.data['course']);
                  course[f.data['college']] = temp1;
                }
                List<String> temp2 = branch[f.data['course']];
                if(temp2 != null)
                  if(!temp2.contains(f.data['branch'])) {
                    temp2.add(f.data['branch']);
                    branch[f.data['course']] = temp2;
                  }
                List<String> temp3 = batch[f.data['branch']];
                if(temp3 != null)
                  if(!temp3.contains(f.data['batch_name'])) {
                    temp3.add(f.data['batch_name']);
                    batch[f.data['branch']] = temp3;
                  }
              });

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
                              setState(() => name = text);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'name cannot be empty';
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
                              setState(() => name = text);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'name cannot be empty';
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
                              decoration: loginFormField.copyWith(labelText: 'College Name', icon: Icon(Icons.school, color: basicColor,)),
                            ),
                          );
                        },
                      ),
                      IgnorePointer(
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
                              dataList: branch.keys.toList(),
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
                      IgnorePointer(
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
                              dataList: batch.keys.toList(),
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
                      IgnorePointer(
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
                              dataList: branch.keys.toList(),
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
                      IgnorePointer(
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
                                        setState(() {
                                          loading = true;
                                        });
                                        FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                        user.updateEmail(email);
                                        user.updatePassword(password);
                                        Future.wait([
                                          DatabaseService(uid: user.uid).updateUserInfo(
                                              name, password, Timestamp.now(), 'Candidate'
                                          ),
                                        ]);
                                        setState(() {
                                          loading = false;
                                          Navigator.pop(context);
                                        });
                                        var net = await Connectivity().checkConnectivity();
                                        if(net == ConnectivityResult.none) {
                                          setState(() {
                                            error = 'No Internet Connection';
                                          });
                                        }
//                            if (result == -1) {
//                              setState(() {
//                                loading = false;
//                                Navigator.pushReplacement(
//                                  context,
//                                  MaterialPageRoute(
//                                      settings: RouteSettings(name: "Register"),
//                                      builder: (context) => Resend(name, email, password)
//                                  ),
//                                );
//                              });
//                            }
                                      }

                                    }),
                              )),
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
          "No Items Found",
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
