import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:apli/Shared/constants.dart';
import 'package:dio/dio.dart';
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
                var temp = response.data['success'];
                if (temp == true) {
                  result = 1;
                  print(result);
                } else
                  result = -1;
              } else
        result = -2;
              break;
            }

          case 6:

              String expToPass = jsonEncode(map['experience']);
              print(expToPass);

              Response response = await Dio().post(projectsURL, data: {
                "secret": "$passHashSecret",
                "email": "${value.getString('email')}",
                "data": expToPass
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

          case 5:
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

            break;

          case 4:
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

            break;

          case 3:

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

            break;

          case 2:
              String awardsToPass = jsonEncode(map['awards']);
              print(awardsToPass);
              Response response = await Dio().post(awardsURL, data: {
                "secret": "$passHashSecret",
                "email": "${value.getString('email')}",
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

            break;

          default:
            result = -2;
            break;
        }
      });
      print(result);
      return result;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }
}

// NOTE: result =     1 = true
//       result =    -1 = false
//       result =    -2 = could not connect to server
//       result =     0 = failed
