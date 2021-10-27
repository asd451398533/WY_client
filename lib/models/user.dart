import 'package:shared_preferences/shared_preferences.dart';
import 'package:timefly/blocs/bill/bill_bloc.dart';
import 'package:timefly/blocs/bill/bill_event_1.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/xt/bill_bloc.dart';
import 'package:timefly/blocs/xt/bill_event_1.dart';
import 'package:timefly/db/database_provider.dart';

class User {
  String id;
  String key;
  String name;
  String phone;
  String birth;
  String password;
  String users;
  String img;

  static User fromJson(Map<String, dynamic> json) {
    return User()
      ..id = json['id']?.toString()
      ..key = json['key']?.toString()
      ..name = json['name']?.toString()
      ..phone = json['phone']?.toString()
      ..birth = json['birth']?.toString()
      ..password = json['password']?.toString()
      ..users = json['users']?.toString()
      ..img = json['img']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['key'] = key;
    data['name'] = name;
    data['phone'] = phone;
    data['birth'] = birth;
    data['password'] = password;
    data["users"] = users;
    data["img"] = img;
    return data;
  }

  User copyWith(
      {String id,
      String key,
      String name,
      String phone,
      String birth,
      String password,
      String users,
      String img}) {
    return User()
      ..id = id
      ..key = key
      ..name = name
      ..phone = phone
      ..birth = birth
      ..password = password
      ..users = users
      ..img = img;
  }
}

class SessionUtils {
  SessionUtils._();

  factory SessionUtils() => sharedInstance();

  static SessionUtils sharedInstance() {
    return _instance;
  }

  static SessionUtils _instance = SessionUtils._();

  User currentUser;
  BillBloc billBloc;
  XTBloc xtBloc;

  init() async {
    currentUser = await DatabaseProvider.db.getCurrentUser();
    print('init user -- ${currentUser?.toJson()}');
  }

  void setBloc(BillBloc billBloc) {
    this.billBloc = billBloc;
  }

  void setXtBloc(XTBloc xtBloc) {
    this.xtBloc = xtBloc;
  }

  void login(User user) async {
    if (currentUser != null) {
      await DatabaseProvider.db.deleteUser();
    }
    currentUser = user;
    await DatabaseProvider.db.saveUser(user);
    billBloc.add(BillLoad());
    xtBloc.add(XTLoad());
  }

  void logout() async {
    currentUser = null;
    await DatabaseProvider.db.deleteUser();
    billBloc.add(BillLoad());
    xtBloc.add(XTLoad());
  }

  void updateName(String name) async {
    currentUser = currentUser.copyWith(name: name);
    await DatabaseProvider.db.updateUser(currentUser);
  }

  bool isLogin() {
    return currentUser != null;
  }

  String getUserId() {
    return currentUser?.id;
  }
}
