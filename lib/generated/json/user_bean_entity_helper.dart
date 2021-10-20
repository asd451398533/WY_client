import 'package:timefly/bean/user_bean_entity.dart';

userBeanEntityFromJson(UserBeanEntity data, Map<String, dynamic> json) {
	if (json['password'] != null) {
		data.password = json['password'].toString();
	}
	if (json['img'] != null) {
		data.img = json['img'].toString();
	}
	if (json['phone'] != null) {
		data.phone = json['phone'].toString();
	}
	if (json['name'] != null) {
		data.name = json['name'].toString();
	}
	if (json['birth'] != null) {
		data.birth = json['birth'].toString();
	}
	if (json['id'] != null) {
		data.id = json['id'] is String
				? double.tryParse(json['id'])
				: json['id'].toDouble();
	}
	if (json['key'] != null) {
		data.key = json['key'].toString();
	}
	if (json['users'] != null) {
		data.users = json['users'].toString();
	}
	return data;
}

Map<String, dynamic> userBeanEntityToJson(UserBeanEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['password'] = entity.password;
	data['img'] = entity.img;
	data['phone'] = entity.phone;
	data['name'] = entity.name;
	data['birth'] = entity.birth;
	data['id'] = entity.id;
	data['key'] = entity.key;
	data['users'] = entity.users;
	return data;
}