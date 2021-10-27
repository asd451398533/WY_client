import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/user.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  static const String RECORDS = 'records';
  static const String USER_KEY = "USER_KEY";

  SharedPreferences _sharedPreferences;

  Future<SharedPreferences> get _shared async {
    if (_sharedPreferences != null) {
      return _sharedPreferences;
    }
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  Future<User> getCurrentUser() async {
    var sharedPreferences = await _shared;
    var str = sharedPreferences.getString(USER_KEY);
    if (str != null && str.isNotEmpty) {
      var fromJson = User.fromJson(json.decode(str));
      if (fromJson != null && fromJson.key != null && fromJson.key.isNotEmpty) {
        return fromJson;
      }
      return null;
    }
    return null;
  }

  Future<bool> saveUser(User user) async {
    var sharedPreferences = await _shared;
    return sharedPreferences.setString(USER_KEY, json.encode(user.toJson()));
  }

  Future<bool> deleteUser() async {
    var sharedPreferences = await _shared;
    return sharedPreferences.remove(USER_KEY);
  }

  Future<bool> updateUser(User user) async {
    var sharedPreferences = await _shared;
    return sharedPreferences.setString(USER_KEY, json.encode(user.toJson()));
  }

  Future<Habit> insert(Habit habit) async {}
}
