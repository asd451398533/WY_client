import 'package:timefly/generated/json/base/json_convert_content.dart';

class UserBeanEntity with JsonConvert<UserBeanEntity> {
	String password;
	String img;
	String phone;
	String name;
	String birth;
	double id;
	String key;
	String users;
}
