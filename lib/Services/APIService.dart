import 'dart:convert';

import 'package:apli/Shared/constants.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final int profileType, jobType;

  APIService({this.profileType, this.jobType});

  Future sendProfileData(Map<dynamic, dynamic> map) async {
    try {
      int result;
      Response response;
      await SharedPreferences.getInstance().then((value) async {
        switch (profileType) {
          case 8:
            response = await Dio().post(basic_infoURL, data: {
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
              "ph_no": "${map['ph_no']}",
              "profile_picture": "${map['profile_picture']}",
              "roll_no": "${map['roll_no']}",
            });
            break;

          case 7:
            {
              String eduToPass = json.encode(map);
              response = await Dio().post(educationURL, data: {
                "email": "${value.getString('email')}",
                "secret": "$passHashSecret",
                'education': eduToPass
              });
              break;
            }

          case 6:
            if (map['index'] != -1) {
              map['experience'].removeAt(map['index']);
            }
            for (int i = 0; i < map['experience'].length; i++) {
              map['experience'][i]['bullet_point1'] =
                  map['experience'][i]['information'][0];
              map['experience'][i]['bullet_point2'] =
                  map['experience'][i]['information'][1];
              map['experience'][i]['bullet_point3'] =
                  map['experience'][i]['information'][2];
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
            String expToPass = jsonEncode(map['experience']);
            response = await Dio().post(expURL, data: {
              "secret": "$passHashSecret",
              "email": "${value.getString('email')}",
              "data": expToPass
            });
            break;

          case 5:
            if (map['index'] != -1) {
              map['project'].removeAt(map['index']);
            }
            for (int i = 0; i < map['project'].length; i++) {
              map['project'][i]['bullet_point1'] =
                  map['project'][i]['information'][0];
              map['project'][i]['bullet_point2'] =
                  map['project'][i]['information'][1];
              if (map['project'][i]['from'] != null) {
                map['project'][i]['from'] =
                    apiDateFormat.format(map['project'][i]['from'].toDate()) +
                        " 00:00:00+0000";
              }
              if (map['project'][i]['to'] != null) {
                map['project'][i]['to'] =
                    apiDateFormat.format(map['project'][i]['to'].toDate()) +
                        " 00:00:00+0000";
              }
            }
            String expToPass = jsonEncode(map['project']);
            response = await Dio().post(projectsURL, data: {
              "secret": "$passHashSecret",
              "email": "${value.getString('email')}",
              "data": expToPass
            });
            break;

          case 4:
            if (map['index'] != -1) {
              map['extra_curricular'].removeAt(map['index']);
            }
            for (int i = 0; i < map['extra_curricular'].length; i++) {
              map['extra_curricular'][i]['bullet_point1'] =
                  map['extra_curricular'][i]['info'][0];
              map['extra_curricular'][i]['bullet_point2'] =
                  map['extra_curricular'][i]['info'][1];
              if (map['extra_curricular'][i]['start'] != null) {
                map['extra_curricular'][i]['start'] = apiDateFormat
                        .format(map['extra_curricular'][i]['start'].toDate()) +
                    " 00:00:00+0000";
              }
              if (map['extra_curricular'][i]['end'] != null) {
                map['extra_curricular'][i]['end'] = apiDateFormat
                        .format(map['extra_curricular'][i]['end'].toDate()) +
                    " 00:00:00+0000";
              }
            }
            String expToPass = jsonEncode(map['extra_curricular']);
            response = await Dio().post(extraCURL, data: {
              "secret": "$passHashSecret",
              "email": "${value.getString('email')}",
              "data": expToPass
            });
            break;

          case 3:
            for (int i = 0; i < map['award'].length; i++) {
              map['award'][i]['date'] =
                  apiDateFormat.format(map['award'][i]['date'].toDate()) +
                      " 00:00:00+0000";
            }
            String expToPass = jsonEncode(map['award']);
            response = await Dio().post(awardsURL, data: {
              "secret": "$passHashSecret",
              "email": "${value.getString('email')}",
              "data": expToPass
            });
            break;

          case 2:
            String expToPass = jsonEncode(map['skill']);
            response = await Dio().post(skillsURL, data: {
              "secret": "$passHashSecret",
              "email": "${value.getString('email')}",
              "data": expToPass
            });
            break;

          default:
            result = -2;
            break;
        }
      });
      if (response.statusCode == 200) {
        var temp = response.data['success'];
        if (temp == true) {
          result = 1;
        } else
          result = -1;
      } else
        result = -2;
      return result;
    } catch (e) {
      return 0;
    }
  }

  Future getJobs() async {
//    try {
//      dynamic result;
//      await SharedPreferences.getInstance().then((value) async {
//        http.Response response = await http.post(
//          jobApplyURL,
//          body: json.decode('{'
//              '"secret" : "$passHashSecret", '
//              '"email": "${value.getString('email')}"'
//              '}'),
//        );
//        if (response.statusCode == 200) {
//          var decodedData = jsonDecode(response.body);
//          var frozen = decodedData['frozen'];
//          if(frozen == true)
//            return 'frozen';
//          else
//            return decodedData;
//        } else {
//          result = {
//            'error': jsonDecode(response.body)["error"] ??
//                'Unexpected error occurred'
//          };
//        }
//      });
//
//      return result;
//    } catch (e) {
//      return 0;
//    }
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        Response response = await Dio().post(allJobsURL, data: {
          "secret": "$passHashSecret",
          "email": "${value.getString('email')}"
        });
        if (response.statusCode == 200) {
          var frozen = response.data['frozen'];
          if (frozen == true) {
            result = 'frozen';
          } else
            result = response.data;
        } else
          result = -2;
      });
      return result;
    } catch (e) {
      print(e);
      return;
    }
  }

  Future getCompanyIntro(String id) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        Response response = await Dio().post(companyIntroURL,
            data: {"secret": "$passHashSecret", "job_id": "$id"});
        if (response.statusCode == 200) {
          result = response.data;
        } else
          result = -2;
      });
      print(result);
      return result;
    } catch (e) {
      return;
    }
  }

  Future applyJob(String id) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        http.Response response = await http.post(
          jobApplyURL,
          body: json.decode('{'
              '"secret" : "$passHashSecret", '
              '"job_id" : "$id", '
              '"email": "${value.getString('email')}"'
              '}'),
        );
        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          var temp = decodedData["success"];
          if (temp == true) {
            result = 1;
          } else
            result = -1;
        } else {
          result = {
            'error': jsonDecode(response.body)["error"] ??
                'Unexpected error occurred'
          };
        }
      });

      return result;
    } catch (e) {
      return 0;
    }
  }

  Future fetchInterviewQ(String id) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        http.Response response = await http.post(
          interViewQuestionsURL,
          body: json.decode('{'
              '"secret" : "$passHashSecret", '
              '"job_id" : "$id", '
              '"email": "${value.getString('email')}"'
              '}'),
        );
        var decodedData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          result = decodedData;
        } else
          result = {
            'error': decodedData["error"] ?? 'Unexpected error occurred'
          };
      });

      return result;
    } catch (e) {
      return;
    }
  }

  Future submitInterViewQ(
      String id, String type, String questionID, String videoURL) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        Response response = await Dio().post(submitVideoInterviewURL, data: {
          "secret": "$passHashSecret",
          "job_id": "$id",
          "email": "${value.getString('email')}",
          'question_id': "$questionID",
          'video_url': "$videoURL",
          'type': "$type"
        });
        if (response.statusCode == 200) {
          result = response.data;
        } else
          result = -2;
      });

      return result;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future acceptInterView(String id) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        http.Response response = await http.post(
          acceptInterviewURL,
          body: json.decode('{'
              '"secret" : "$passHashSecret", '
              '"job_id" : "$id", '
              '"email": "${value.getString('email')}"'
              '}'),
        );
        var decodedData = jsonDecode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          result = decodedData;
        } else
          result = {
            'error': decodedData["error"] ?? 'Unexpected error occurred'
          };
      });

      return result;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future acceptJobOffer(String id) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        http.Response response = await http.post(
          acceptJobOfferURL,
          body: json.decode('{'
              '"secret" : "$passHashSecret", '
              '"job_id" : "$id", '
              '"email": "${value.getString('email')}"'
              '}'),
        );
        var decodedData = jsonDecode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          result = decodedData;
        } else
          result = {
            'error': decodedData["error"] ?? 'Unexpected error occurred'
          };
      });

      return result;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future updateJobOfferLetter(String id, String link) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        http.Response response = await http.post(
          uploadLetterURL,
          body: json.decode('{'
              '"secret" : "$passHashSecret", '
              '"job_id" : "$id", '
              '"email": "${value.getString('email')}", '
              '"signed_letter": "$link"'
              '}'),
        );
        var decodedData = jsonDecode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          result = decodedData;
        } else
          result = {
            'error': decodedData["error"] ?? 'Unexpected error occurred'
          };
      });

      return result;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future getMockJobs() async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        final queryParameters = {
          "secret": "$passHashSecret",
          "email": "${value.getString('email')}",
        };

        final uri = Uri.http('dev.apli.ai',
            '/candidate/api/get_mock_interview_packages', queryParameters);
        http.Response response = await http.get(uri);
        var decodedData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          result = decodedData;
        } else
          result = {
            'error': decodedData["error"] ?? 'Unexpected error occurred'
          };
      });
      return result;
    } catch (e) {
      print(e);
      return;
    }
  }

  Future fetchMockInterviewQ(String packageName) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        http.Response response = await http.post(
          mockinterViewQuestionsURL,
          body: json.decode('{'
              '"secret" : "$passHashSecret", '
              '"packName": "$packageName", '
              '"email": "${value.getString('email')}"'
              '}'),
        );
        var decodedData = jsonDecode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          result = decodedData;
        } else
          result = {
            'error': decodedData["error"] ?? 'Unexpected error occurred'
          };
      });
      return result;
    } catch (e) {
      print(e);
      return;
    }
  }

  Future submitMockInterview(String docID) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        http.Response response = await http.post(
          submitMockInterviewURL,
          body: json.decode('{'
              '"secret" : "$passHashSecret", '
              '"email": "${value.getString('email')}", '
              '"docId": "$docID"'
              '}'),
        );
        var decodedData = jsonDecode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          result = decodedData;
        } else
          result = {
            'error': decodedData["error"] ?? 'Unexpected error occurred'
          };
      });
      return result;
    } catch (e) {
      print(e);
      return;
    }
  }

  Future addMockVideo(
      String link, String packageName, String docID, int questionID) async {
    try {
      dynamic result;
      await SharedPreferences.getInstance().then((value) async {
        http.Response response = await http.post(
          addMockVideoURL,
          body: json.decode('{'
              '"secret" : "$passHashSecret", '
              '"email": "${value.getString('email')}", '
              '"video_link": "$link", '
              '"pack": "$packageName", '
              '"docId": "$docID", '
              '"que": "$questionID"'
              '}'),
        );
        var decodedData = jsonDecode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          result = decodedData;
        } else
          result = {
            'error': decodedData["error"] ?? 'Unexpected error occurred'
          };
      });
      return result;
    } catch (e) {
      print(e);
      return;
    }
  }
}

// NOTE: result =     1 = success
//       result =    -1 = false
//       result =    -2 = could not connect to server
//       result =     0 = failed
// NOTE: result =     List<dynamic> = true
//       result =          'frozen' = frozen
//       result =                -2 = could not connect to server
//       result =                 0 = failed
