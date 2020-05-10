import 'dart:convert';

import 'package:apli/Shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final int type;

  APIService({this.type});

  Future sendProfileData(Map<dynamic, dynamic> map) async {
    dynamic result;
    String url;
    await SharedPreferences.getInstance().then((value) async {
      try {
        switch (type) {
          case 8:
            {
              Response response = await Dio()
                  .post('https://dev.apli.ai/candidate/api/basic_info', data: {
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
              print(response.data);
              print(response.statusCode);
              if (response.statusCode == 200) {
                var decodedData = jsonDecode(response.data);
                bool temp = decodedData["success"];
                if (temp == true) {
                  result = 1;
                  print(result);
                } else
                  result = -1;
              } else
                result = -2;
              break;
            }
            break;

          case 7:
            {
              http.Response response = await http.post(url,
                  body: json.decode('{'
                      '"useremail" : "${value.getString('email')}", '
                      '"secret" : "$checkLoginSecret", '
                      '"X" : {'
                      '"board" : "${map['X']['board']}",'
                      '"certificate" : "${map['X']['certificate']}",'
                      '"institute" : "${map['X']['institute']}",'
                      '"score" : "${map['X']['score_unit']}",'
                      '"score_unit" : "${map['X']['score_unit']}",'
                      '"specialization" : "${map['X']['specialization']}",'
                      '"start" : "${map['X']['start']}",'
                      '"end" : "${map['X']['end']}",'
                      '},'
                      '"XII" : {'
                      '"board" : "${map['XII']['board']}",'
                      '"certificate" : "${map['XII']['certificate']}",'
                      '"institute" : "${map['XII']['institute']}",'
                      '"score" : "${map['XII']['score_unit']}",'
                      '"score_unit" : "${map['XII']['score_unit']}",'
                      '"specialization" : "${map['XII']['specialization']}",'
                      '"start" : "${map['XII']['start']}",'
                      '"end" : "${map['XII']['end']}",'
                      '},'
                      '"${map['course']}" : {'
                      '"score" : "${map['course']['score']}",'
                      '"total_closed_backlogs" : "${map['course']['total_closed_backlogs']}",'
                      '"total_live_backlogs" : "${map['course']['total_live_backlogs']}",'
                      '"sem_records" : "${map['course']['sem_records']}",'
                      '},'
                      '}'));
              if (response.statusCode == 200) {
                var decodedData = jsonDecode(response.body);
                if (decodedData["secret"] == checkLoginSecret) {
                  bool temp = decodedData["success"];
                  if (temp == true) {
                    result = 1;
                  } else
                    result = -1;
                } else
                  result = -2;
              } else
                result = -2;
              break;
            }

          case 6:
            {
              Response response = await Dio()
                  .post('https://dev.apli.ai/candidate/api/experience', data: {
                "secret": "$passHashSecret",
                "useremail": "${value.getString('email')}",
                "data": [
                  {
                    'Type': "Job",
                    'company': "x",
                    'from': "y",
                    'to': "z",
                    'designation': "d",
                    'industry': "d",
                    'domain': "d",
                    'certificate': "d",
                    'bullet_point1': "d",
                    'bullet_point2': "d",
                    'bullet_point3': "",
                  },
                  {
                    'Type': "Job",
                    'company': "x",
                    'from': "y",
                    'to': "z",
                    'designation': "d",
                    'industry': "d",
                    'domain': "d",
                    'certificate': "d",
                    'bullet_point1': "d",
                    'bullet_point2': "d",
                    'bullet_point3': "",
                  },
                ],
                //   http.Response response = await http.post(url,
                //       body: json.decode('{'
                //           '"secret" : "$passHashSecret", '
                //           '"useremail" : "${value.getString('email')}", '
                //           '"data" : "${map['experience']}"'
                //           '}'));
                //   if (response.statusCode == 200) {
                //     var decodedData = jsonDecode(response.body);
                //     if (decodedData["secret"] == passHashSecret) {
                //       bool temp = decodedData["success"];
                //       if (temp == true) {
                //         result = 1;
                //       } else
                //         result = -1;
                //     } else
                //       result = -2;
                //   } else
                //     result = -2;
                // }
              });
            }
            break;

          case 5:
            {
              http.Response response = await http.post(projectsURL,
                  body: json.decode('{'
                      '"secret" : "$passHashSecret", '
                      '"useremail" : "${value.getString('email')}", '
                      '"data" : "${map['projects']}"'
                      '}'));
              print(response.statusCode);
              if (response.statusCode == 200) {
                var decodedData = jsonDecode(response.body);
                if (decodedData["secret"] == passHashSecret) {
                  bool temp = decodedData["success"];
                  if (temp == true) {
                    result = 1;
                  } else
                    result = -1;
                } else
                  result = -2;
              } else
                result = -2;
            }
            break;

          case 4:
            {
              http.Response response = await http.post(url,
                  body: json.decode('{'
                      '"secret" : "$passHashSecret", '
                      '"useremail" : "${value.getString('email')}", '
                      '"data" : "${map['extra_curricular']}"'
                      '}'));
              if (response.statusCode == 200) {
                var decodedData = jsonDecode(response.body);
                if (decodedData["secret"] == passHashSecret) {
                  bool temp = decodedData["success"];
                  if (temp == true) {
                    result = 1;
                  } else
                    result = -1;
                } else
                  result = -2;
              } else
                result = -2;
            }
            break;

          case 3:
            {
              Response response = await Dio()
                  .post('https://dev.apli.ai/candidate/api/skills', data: {
                "secret": "$passHashSecret",
                "useremail": "${value.getString('email')}",
                "data": [{}, {}],
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
              Response response = await Dio()
                  .post("https://dev.apli.ai/candidate/api/awards", data: {
                "secret": "$passHashSecret",
                "useremail": "${value.getString('email')}",
                "data": [
                  {'description': "K", 'date': "hello"}
                ]
              });
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
            {}
            break;
        }
        return result;
      } catch (e) {
        print(e.toString());
        return 0;
      }
    });
  }
}

// NOTE: result =     1 = true
//       result =    -1 = false
//       result =    -2 = could not connect to server
//       result =     0 = failed
