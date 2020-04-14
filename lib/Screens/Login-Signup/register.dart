import 'package:apli/Shared/constants.dart';
import 'package:apli/Shared/decorations.dart';
import 'package:apli/Shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
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
  String college;
  Timestamp timestamp;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  TextEditingController _controllerCollege = new TextEditingController();

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

  List<String> list = [
    '----------',
  ];


//  final CollectionReference batchesReference = Firestore.instance.collection('batches');
//  void getData() {
////    batchesReference
////        .getDocuments()
////        .then((QuerySnapshot snapshot) {
////      snapshot.documents.forEach((f) => list.add(f.data['college']);
////    });
////  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    return loading ? Loading() : Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection('batches').snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData) {
            snapshot.data.documents.forEach((f) => list.add(f.data['college']));
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
                    SearchWidget<String>(
                      dataList: list,
                      hideSearchBoxWhenItemSelected: false,
                      listContainerHeight: MediaQuery.of(context).size.height / 4,
                      queryBuilder: (String query, List<String> list) {
                        return list.where((String item) {
                          print('abcd');
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
                          college = item;
                          _controllerCollege.text = item;
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
                                  dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, phone, Timestamp.now());
                                  setState(() {
                                    loading = false;
                                  });
                                  var net = await Connectivity().checkConnectivity();
                                  if(net == ConnectivityResult.none) {
                                    setState(() {
                                      error = 'No Internet Connection';
                                    });
                                  }
                                  if (result == null) {
                                    setState(() {
                                      error = 'Email alraedy used';
                                      loading = false;
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
