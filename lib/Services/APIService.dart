import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:apli/Shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final int type;

  APIService({this.type});

  Future sendProfileData(Map<dynamic, dynamic> map) async {
    String url;
    final format = DateFormat("yyyy-MM-dd");
    try {
      int result;
      await SharedPreferences.getInstance().then((value) async {
        switch (type) {
          case 8:
            Response response = await Dio().post(basic_infoURL, data: {
              "email": "${value.getString('email')}",
              "secret": "$passHashSecret",
              "Address": {
                "address": "${map['Address']['address']}",
                "city": "${map['Address']['city']}",
                "country": "${map['Address']['country']}",
                "postal_code": "${map['Address']['postal_code']}",
                "state": "${map['Address']['state']}"
              },
              "First_name": "${map['First_name']}",
              "Last_name": "${map['Last_name']}",
              "Middle_name": "${map['Middle_name']}",
              "dob": "${map['dob']}",
              "gender": "${map['gender']}",
              "highest_qualification": "${map['highest_qualification']}",
              "languages": map['languages'],
              "ph_no": "999999",
              "profile_picture": "${map['profile_picture']}",
              "roll_no": "${map['roll_no']}",
            });
            if (response.statusCode == 200) {
              var temp = response.data['success'];
              if (temp == true) {
                result = 1;
                print(result);
              } else
                result = -1;
            } else
              result = -2;
            break;

          case 7:
            {
              String eduToPass = json.encode(map);
              print(eduToPass);
              Response response = await Dio().post(educationURL, data: {
                "email": "${value.getString('email')}",
                "secret": "$checkLoginSecret",
                'education': eduToPass
              });
              if (response.statusCode == 200) {
                var decodedData = jsonDecode(response.data);

                bool temp = decodedData["success"];
                if (temp == true) {
                  result = 1;
                } else
                  result = -1;
              } else
                result = -2;
              break;
            }

          case 6:
            {
              // List x = [
              //   {
              //     'Name': "ojas",
              //     'University_Company': "ff",
              //     'from': "2020-05-01 00:00:00+0000",
              //     'to': "2020-05-01 00:00:00+0000",
              //     'certificate': "fff",
              //     'bullet_point1': "fff",
              //     'bullet_point2': "fff"
              //   }
              // ];
              // String y = jsonEncode(x);
              // print(y);

              String expToPass = jsonEncode(map['experience']);

              Response response = await Dio().post(projectsURL, data: {
                "secret": "$passHashSecret",
                "email": "${value.getString('email')}",
                "data": expToPass
              });
              print(response.data);
              // if (response.statusCode == 200) {
              //   var decodedData = jsonDecode(response.data);

              //   bool temp = decodedData["success"];
              //   if (temp == true) {
              //     result = 1;
              //   } else
              //     result = -1;
              // } else
              //   result = -2;
            }
            break;

          case 5:
            {
              String projectsToPass = jsonEncode(map['projects']);
              Response response = await Dio().post(projectsURL, data: {
                "secret": "$passHashSecret",
                "email": "${value.getString('email')}",
                "data": projectsToPass
              });
              print(response.statusCode);
              // if (response.statusCode == 200) {
              //   var decodedData = jsonDecode(response.data);

              //   bool temp = decodedData["success"];
              //   if (temp == true) {
              //     result = 1;
              //   } else
              //     result = -1;
              // } else
              //   result = -2;
            }
            break;

          case 4:
            {
              String extraCToPass = jsonEncode(map['extraC']);
              print(extraCToPass);
              Response response = await Dio().post(projectsURL, data: {
                "secret": "$passHashSecret",
                "email": "${value.getString('email')}",
                "data": extraCToPass
              });
              print(response.statusCode);
              // if (response.statusCode == 200) {
              //   var decodedData = jsonDecode(response.body);
              //   if (decodedData["secret"] == passHashSecret) {
              //     bool temp = decodedData["success"];
              //     if (temp == true) {
              //       result = 1;
              //     } else
              //       result = -1;
              //   } else
              //     result = -2;
              // } else
              //   result = -2;
            }
            break;

          case 3:
            {
                                                                    // SKILL DOCUMENTATION IS WRONG REFER BELOW//
              // List x = [
              //   {
              //     "skillG1": [
              //       {"skillName1": "basic"}
              //     ],
              //      "skillG2": [
              //       {"skillName2": "basic"}
              //     ]
              //   }
              // ];
              String skillsToPass = jsonEncode(map['skills']);
              print(skillsToPass);
              Response response = await Dio().post(skillsURL, data: {
                "secret": "$passHashSecret",
                "email": "${value.getString('email')}",
                "data": skillsToPass,
              });
              print(response.statusCode);
              print(response.data);
              // http.Response response = await http.post(url,
              //     body: json.decode('{'
              //         '"secret" : "$passHashSecret", '
              //         '"useremail" : "${value.getString('email')}", '
              //         '"data" : "${map['skills']}"'
              //         '}'));
              // if (response.statusCode == 200) {
              //   var decodedData = jsonDecode(response.body);
              //   if (decodedData["secret"] == passHashSecret) {
              //     bool temp = decodedData["success"];
              //     if (temp == true) {
              //       result = 1;
              //     } else
              //       result = -1;
              //   } else
              //     result = -2;
              // } else
              //   result = -2;
            }
            break;

          case 2:
            {
              String awardsToPass = jsonEncode(map['awards']);
              print(awardsToPass);
              Response response = await Dio().post(awardsURL, data: {
                "secret": "$passHashSecret",
                "useremail": "${value.getString('email')}",
                "data": awardsToPass,
              });
              print(response.statusCode);
              print(response.data);
              // if (response.statusCode == 200) {
              //   var decodedData = jsonDecode(response.body);
              //   if (decodedData["secret"] == passHashSecret) {
              //     bool temp = decodedData["success"];
              //     if (temp == true) {
              //       result = 1;
              //     } else
              //       result = -1;
              //   } else
              //     result = -2;
              // } else
              //   result = -2;
            }
            break;

          default:
            result = -2;
            break;
        }
      });

      return result;
    } catch (e) {
      print(e.toString());
      return 0;
    }

//    await SharedPreferences.getInstance().then((value) async {
//      try {
////        switch (type) {
////          case 8:
////            {
////              Response response = await Dio().post(basic_infoURL, data: {
////                "email": "${value.getString('email')}",
////                "secret": "$passHashSecret",
////                "Address": {
////                  "address": "${map['Address']['address']}",
////                  "city": "${map['Address']['city']}",
////                  "country": "${map['Address']['country']}",
////                  "postal_code": "${map['Address']['postal_code']}",
////                  "state": "${map['Address']['state']}"
////                },
////                "First_name": "${map['First_name']}",
////                "Last_name": "${map['Last_name']}",
////                "Middle_name": "${map['Middle_name']}",
////                "dob": "${map['dob']}",
////                "gender": "${map['gender']}",
////                "highest_qualification": "${map['highest_qualification']}",
////                "languages": map['languages'],
////                "ph_no": "999999",
////                "profile_picture": "${map['profile_picture']}",
////                "roll_no": "${map['roll_no']}",
////              });
////              if (response.statusCode == 200) {
////                var temp = response.data['success'];
////                if (temp == true) {
////                  result = 1;
////                  print(result);
////                } else
////                  result = -1;
////              } else
////                result = -2;
////            }
////            break;
////
//          case 7:
//            {
//              //  String formattedDate = format
//              //                             .format(start.toDate())
//              //                             .toString();
//              //                         formattedDate =
//              //                             formattedDate + " 00:00:00+0000";
//              Response response = await Dio().post(educationURL, data: {
//                "useremail": "${value.getString('email')}",
//                "secret": "$checkLoginSecret",
//                "X": {
//                  "board": "${map['X']['board']}",
//                  "certificate": "${map['X']['certificate']}",
//                  "institute": "${map['X']['institute']}",
//                  "score": "${map['X']['score_unit']}",
//                  "score_unit": "${map['X']['score_unit']}",
//                  "specialization": "${map['X']['specialization']}",
//                  "start": "${map['X']['start']}",
//                  "end": "${map['X']['end']}",
//                },
//                "XII": {
//                  "board": "${map['XII']['board']}",
//                  "certificate": "${map['XII']['certificate']}",
//                  "institute": "${map['XII']['institute']}",
//                  "score": "${map['XII']['score_unit']}",
//                  "score_unit": "${map['XII']['score_unit']}",
//                  "specialization": "${map['XII']['specialization']}",
//                  "start": "${map['XII']['start']}",
//                  "end": "${map['XII']['end']}",
//                },
//                "${map['course']}": {
//                  "score": "${map['course']['score']}",
//                  "total_closed_backlogs":
//                      "${map['course']['total_closed_backlogs']}",
//                  "total_live_backlogs":
//                      "${map['course']['total_live_backlogs']}",
//                  "sem_records": "${map['course']['sem_records']}",
//                },
//                "other-education":{
//
//                }
//              });
//              // http.Response response = await http.post(url,
//              //     body: json.decode('{'
//              //         '"useremail" : "${value.getString('email')}", '
//              //         '"secret" : "$checkLoginSecret", '
//              //         '"X" : {'
//              //         '"board" : "${map['X']['board']}",'
//              //         '"certificate" : "${map['X']['certificate']}",'
//              //         '"institute" : "${map['X']['institute']}",'
//              //         '"score" : "${map['X']['score_unit']}",'
//              //         '"score_unit" : "${map['X']['score_unit']}",'
//              //         '"specialization" : "${map['X']['specialization']}",'
//              //         '"start" : "${map['X']['start']}",'
//              //         '"end" : "${map['X']['end']}",'
//              //         '},'
//              //         '"XII" : {'
//              //         '"board" : "${map['XII']['board']}",'
//              //         '"certificate" : "${map['XII']['certificate']}",'
//              //         '"institute" : "${map['XII']['institute']}",'
//              //         '"score" : "${map['XII']['score_unit']}",'
//              //         '"score_unit" : "${map['XII']['score_unit']}",'
//              //         '"specialization" : "${map['XII']['specialization']}",'
//              //         '"start" : "${map['XII']['start']}",'
//              //         '"end" : "${map['XII']['end']}",'
//              //         '},'
//              //         '"${map['course']}" : {'
//              //         '"score" : "${map['course']['score']}",'
//              //         '"total_closed_backlogs" : "${map['course']['total_closed_backlogs']}",'
//              //         '"total_live_backlogs" : "${map['course']['total_live_backlogs']}",'
//              //         '"sem_records" : "${map['course']['sem_records']}",'
//              //         '},'
//              //         '}'));
//              // if (response.statusCode == 200) {
//              //   var decodedData = jsonDecode(response.body);
//              //   if (decodedData["secret"] == checkLoginSecret) {
//              //     bool temp = decodedData["success"];
//              //     if (temp == true) {
//              //       result = 1;
//              //     } else
//              //       result = -1;
//              //   } else
//              //     result = -2;
//              // } else
//              //   result = -2;
//              // break;
//              break;
//            }
//
//          case 6:
//            {
//              Response response = await Dio()
//                  .post('https://dev.apli.ai/candidate/api/experience', data: {
//                "secret": "$passHashSecret",
//                "useremail": "${value.getString('email')}",
//                "data": [
//                  {
//                    'Type': "Job",
//                    'company': "x",
//                    'from': "y",
//                    'to': "z",
//                    'designation': "d",
//                    'industry': "d",
//                    'domain': "d",
//                    'certificate': "d",
//                    'bullet_point1': "d",
//                    'bullet_point2': "d",
//                    'bullet_point3': "",
//                  },
//                  {
//                    'Type': "Job",
//                    'company': "x",
//                    'from': "y",
//                    'to': "z",
//                    'designation': "d",
//                    'industry': "d",
//                    'domain': "d",
//                    'certificate': "d",
//                    'bullet_point1': "d",
//                    'bullet_point2': "d",
//                    'bullet_point3': "",
//                  },
//                ],
//                //   http.Response response = await http.post(url,
//                //       body: json.decode('{'
//                //           '"secret" : "$passHashSecret", '
//                //           '"useremail" : "${value.getString('email')}", '
//                //           '"data" : "${map['experience']}"'
//                //           '}'));
//                //   if (response.statusCode == 200) {
//                //     var decodedData = jsonDecode(response.body);
//                //     if (decodedData["secret"] == passHashSecret) {
//                //       bool temp = decodedData["success"];
//                //       if (temp == true) {
//                //         result = 1;
//                //       } else
//                //         result = -1;
//                //     } else
//                //       result = -2;
//                //   } else
//                //     result = -2;
//                // }
//              });
//            }
//            break;
//
//          case 5:
//            {
//              http.Response response = await http.post(projectsURL,
//                  body: json.decode('{'
//                      '"secret" : "$passHashSecret", '
//                      '"useremail" : "${value.getString('email')}", '
//                      '"data" : "${map['projects']}"'
//                      '}'));
//              print(response.statusCode);
//              if (response.statusCode == 200) {
//                var decodedData = jsonDecode(response.body);
//                if (decodedData["secret"] == passHashSecret) {
//                  bool temp = decodedData["success"];
//                  if (temp == true) {
//                    result = 1;
//                  } else
//                    result = -1;
//                } else
//                  result = -2;
//              } else
//                result = -2;
//            }
//            break;
//
//          case 4:
//            {
//              http.Response response = await http.post(url,
//                  body: json.decode('{'
//                      '"secret" : "$passHashSecret", '
//                      '"useremail" : "${value.getString('email')}", '
//                      '"data" : "${map['extra_curricular']}"'
//                      '}'));
//              if (response.statusCode == 200) {
//                var decodedData = jsonDecode(response.body);
//                if (decodedData["secret"] == passHashSecret) {
//                  bool temp = decodedData["success"];
//                  if (temp == true) {
//                    result = 1;
//                  } else
//                    result = -1;
//                } else
//                  result = -2;
//              } else
//                result = -2;
//            }
//            break;
//
//          case 3:
//            {
//              Response response = await Dio()
//                  .post('https://dev.apli.ai/candidate/api/skills', data: {
//                "secret": "$passHashSecret",
//                "useremail": "${value.getString('email')}",
//                "data": [{}, {}],
//              });
//              print(response.statusCode);
//              print(response.data);
//              // http.Response response = await http.post(url,
//              //     body: json.decode('{'
//              //         '"secret" : "$passHashSecret", '
//              //         '"useremail" : "${value.getString('email')}", '
//              //         '"data" : "${map['skills']}"'
//              //         '}'));
//              // if (response.statusCode == 200) {
//              //   var decodedData = jsonDecode(response.body);
//              //   if (decodedData["secret"] == passHashSecret) {
//              //     bool temp = decodedData["success"];
//              //     if (temp == true) {
//              //       result = 1;
//              //     } else
//              //       result = -1;
//              //   } else
//              //     result = -2;
//              // } else
//              //   result = -2;
//            }
//            break;
//
//          case 2:
//            {
//              Response response = await Dio()
//                  .post("https://dev.apli.ai/candidate/api/awards", data: {
//                "secret": "$passHashSecret",
//                "useremail": "${value.getString('email')}",
//                "data": [
//                  {'description': "K", 'date': "hello"}
//                ]
//              });
//              // if (response.statusCode == 200) {
//              //   var decodedData = jsonDecode(response.body);
//              //   if (decodedData["secret"] == passHashSecret) {
//              //     bool temp = decodedData["success"];
//              //     if (temp == true) {
//              //       result = 1;
//              //     } else
//              //       result = -1;
//              //   } else
//              //     result = -2;
//              // } else
//              //   result = -2;
//            }
//            break;
////
////          default:
////            {}
////            break;
////        }
//        return result;
//      } catch (e) {
//        print(e.toString());
//        return 0;
//      }
//    });
  }
}

// NOTE: result =     1 = true
//       result =    -1 = false
//       result =    -2 = could not connect to server
//       result =     0 = failed
