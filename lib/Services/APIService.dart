import 'dart:convert';

import 'package:apli/Shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final int type;

  APIService({this.type});

  Future sendProfileData(Map<String, dynamic> map) async {
    dynamic result;
    String url;
    await SharedPreferences.getInstance().then((value) async {
      try {
        switch(type) {
          case 8: {
            http.Response response = await http.post(
                url,
                body: json.decode('{'
                    '"email" : "${value.getString('email')}", '
                    '"secret" : "$checkLoginSecret", '
                    '"Address" : {'
                    '"address" : "${map['Address']['address']}",'
                    '"city" : "${map['Address']['city']}",'
                    '"country" : "${map['Address']['country']}",'
                    '"postal_code" : "${map['Address']['postal_code']}",'
                    '"state" : "${map['Address']['state']}",'
                    '},'
                    '"First_name" : "${map['First_name']}",'
                    '"Last_name" : "${map['Last_name']}",'
                    '"Middle_name" : "${map['Middle_name']}",'
                    '"dob" : "${map['dob']}",'
                    '"gender" : "${map['gender']}",'
                    '"highest_qualification" : "${map['highest_qualification']}",'
                    '"languages" : {'
                    '"address" : "${map['Address']['address']}",'
                    '},'
                    '"ph_no" : "${map['ph_no']}",'
                    '"profile_picture" : "${map['profile_picture']}",'
                    '"roll_no" : "${map['roll_no']}",'
                    '}')
            );
            if(response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if(decodedData["secret"] == checkLoginSecret) {
                bool temp = decodedData["success"];
                if(temp == true) {
                  result = 1;
                } else result = -1;
              } else result = -2;
            } else result = -2;
          }
          break;

          case 7: {
            http.Response response = await http.post(
                url,
                body: json.decode('{'
                    '"secret" : "$checkLoginSecret", '
                    '"useremail" : "${value.getString('email')}", '
                    '"data" : "${map['experience']}"'
                    '}')
            );
            if(response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if(decodedData["secret"] == checkLoginSecret) {
                bool temp = decodedData["success"];
                if(temp == true) {
                  result = 1;
                } else result = -1;
              } else result = -2;
            } else result = -2;
          }
          break;

          case 6: {
            http.Response response = await http.post(
                url,
                body: json.decode('{'
                    '"secret" : "$checkLoginSecret", '
                    '"useremail" : "${value.getString('email')}", '
                    '"data" : "${map['experience']}"'
                    '}')
            );
            if(response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if(decodedData["secret"] == checkLoginSecret) {
                bool temp = decodedData["success"];
                if(temp == true) {
                  result = 1;
                } else result = -1;
              } else result = -2;
            } else result = -2;
          }
          break;

          case 5: {
            http.Response response = await http.post(
                url,
                body: json.decode('{'
                    '"secret" : "$checkLoginSecret", '
                    '"useremail" : "${value.getString('email')}", '
                    '"data" : "${map['experience']}"'
                    '}')
            );
            if(response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if(decodedData["secret"] == checkLoginSecret) {
                bool temp = decodedData["success"];
                if(temp == true) {
                  result = 1;
                } else result = -1;
              } else result = -2;
            } else result = -2;
          }
          break;

          case 4: {
            http.Response response = await http.post(
                url,
                body: json.decode('{'
                    '"secret" : "$checkLoginSecret", '
                    '"useremail" : "${value.getString('email')}", '
                    '"data" : "${map['experience']}"'
                    '}')
            );
            if(response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if(decodedData["secret"] == checkLoginSecret) {
                bool temp = decodedData["success"];
                if(temp == true) {
                  result = 1;
                } else result = -1;
              } else result = -2;
            } else result = -2;
          }
          break;

          case 3: {
            http.Response response = await http.post(
                url,
                body: json.decode('{'
                    '"secret" : "$checkLoginSecret", '
                    '"useremail" : "${value.getString('email')}", '
                    '"data" : "${map['experience']}"'
                    '}')
            );
            if(response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if(decodedData["secret"] == checkLoginSecret) {
                bool temp = decodedData["success"];
                if(temp == true) {
                  result = 1;
                } else result = -1;
              } else result = -2;
            } else result = -2;
          }
          break;

          case 2: {
            http.Response response = await http.post(
                url,
                body: json.decode('{'
                    '"secret" : "$checkLoginSecret", '
                    '"useremail" : "${value.getString('email')}", '
                    '"data" : "${map['experience']}"'
                    '}')
            );
            if(response.statusCode == 200) {
              var decodedData = jsonDecode(response.body);
              if(decodedData["secret"] == checkLoginSecret) {
                bool temp = decodedData["success"];
                if(temp == true) {
                  result = 1;
                } else result = -1;
              } else result = -2;
            } else result = -2;
          }
          break;

          default: {

          }
          break;
        }
        return result;
      } catch(e) {
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
