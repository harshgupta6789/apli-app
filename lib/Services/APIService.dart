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

            if(map['index'] != -1) {
              map['experience'].removeAt(map['index']);
            }
            for (int i = 0; i < map['experience'].length; i++) {
              map['experience'][i]['bullet_point1'] = map['experience'][i]['information'][0];
              map['experience'][i]['bullet_point2'] = map['experience'][i]['information'][1];
              map['experience'][i]['bullet_point3'] = map['experience'][i]['information'][2];
              if (map['experience'][i]['from'] != null) {
                map['experience'][i]['from'] = apiDateFormat
                        .format(map['experience'][i]['from'].toDate()) +
                    " 00:00:00+0000";
              }
              if (map['experience'][i]['to'] != null) {
                map['experience'][i]['to'] =
                    apiDateFormat.format(map['experience'][i]['to'].toDate()) +
                        " 00:00:00+0000";
              }
            }
            print(map['experience']);
            String expToPass = jsonEncode(map['experience']);
            print(expToPass);
            Response response = await Dio().post(expURL, data: {
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
            print(map);
            if(map['index'] != -1) {
              map['project'].removeAt(map['index']);
            }
            for (int i = 0; i < map['project'].length; i++) {
              map['project'][i]['bullet_point1'] = map['project'][i]['information'][0];
              map['project'][i]['bullet_point2'] = map['project'][i]['information'][1];
              print(map);
              if (map['project'][i]['from'] != null) {
                map['project'][i]['from'] = apiDateFormat
                    .format(map['project'][i]['from'].toDate()) +
                    " 00:00:00+0000";
              }
              if (map['project'][i]['to'] != null) {
                map['project'][i]['to'] =
                    apiDateFormat.format(map['project'][i]['to'].toDate()) +
                        " 00:00:00+0000";
              }
            }
            print(map['project']);
            String expToPass = jsonEncode(map['project']);
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

          case 4:
            if(map['index'] != -1) {
              map['extra_curricular'].removeAt(map['index']);
            }
            for (int i = 0; i < map['extra_curricular'].length; i++) {
              map['extra_curricular'][i]['bullet_point1'] = map['extra_curricular'][i]['info'][0];
              map['extra_curricular'][i]['bullet_point2'] = map['extra_curricular'][i]['info'][1];
              if (map['extra_curricular'][i]['start'] != null) {
                map['extra_curricular'][i]['start'] = apiDateFormat
                    .format(map['extra_curricular'][i]['start'].toDate()) +
                    " 00:00:00+0000";
              }
              if (map['extra_curricular'][i]['end'] != null) {
                map['extra_curricular'][i]['end'] =
                    apiDateFormat.format(map['extra_curricular'][i]['end'].toDate()) +
                        " 00:00:00+0000";
              }
            }
            print(map['extra_curricular']);
            String expToPass = jsonEncode(map['extra_curricular']);
            print(expToPass);
            Response response = await Dio().post(extraCURL, data: {
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

          case 3:

            print(map['award']);
            for(int i = 0; i < map['award'].length; i++) {
              map['award'][i]['date'] = apiDateFormat
                  .format(map['award'][i]['date'].toDate()) +
                  " 00:00:00+0000";
            }
            String expToPass = jsonEncode(map['award']);
            print(expToPass);
            Response response = await Dio().post(awardsURL, data: {
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

          case 2:

            print(map['skill']);
            String expToPass = jsonEncode(map['skill']);
            print(expToPass);
            Response response = await Dio().post(skillsURL, data: {
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
