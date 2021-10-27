const String XT_L = "mmol/L";

class XT {
  int id;
  String userKey;
  String type;
  double number;
  String foods;
  String images;
  String remark;
  String remarkId;
  String categoryImage;

  /// 是否已删除 0没有 1删除
  int isDelete;
  int createTimestamp;
  String createTime;
  int updateTimestamp;
  String updateTime;

  XT();

  factory XT.fromJson(Map<String, dynamic> json) {
    return XT()
      ..id = json['id'] as int
      ..number = ((json['number'] as num)?.toDouble())
      ..remarkId = json['remarkId'] as String
      ..userKey = json['userKey'] as String
      ..categoryImage = json['categoryImage'] as String
      ..foods = json['foods'] as String
      ..images = json['images'] as String
      ..remark = json['remark'] as String
      ..type = json['type'] as String
      ..createTimestamp = json['createTimestamp'] as int
      ..updateTimestamp = json['updateTimestamp'] as int
      ..createTime = json['createTime'] as String
      ..updateTime = json['updateTime'] as String
      ..isDelete = json['isDelete'] as int;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'number': number,
        'remarkId': remarkId,
        'remark': remark,
        'foods': foods,
        'images': images,
        'userKey': userKey,
        'categoryImage': categoryImage,
        'type': type,
        'isDelete': isDelete,
        'createTime': createTime,
        'updateTime': updateTime,
        'createTimestamp': createTimestamp,
        'updateTimestamp': updateTimestamp,
      };
}

class FK {
  int id;
  String word;

  FK();

  factory FK.fromJson(Map<String, dynamic> json) {
    return FK()
      ..id = json['id'] as int
      ..word = json['word'] as String;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'word': word,
      };
}

class Food {
  int id;
  String name;
  double gi;
  String other;

  Food();

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food()
      ..id = json['id'] as int
      ..name = json['name'] as String
      ..gi = json['gi'] as double
      ..other = json['other'] == null ? "" : json['other'] as String;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'gi': gi,
        'other': other,
      };
}

class XTRemark {
  int id;

  String userKey;

  String remarkId;

  String remark;

  String images;

  int xtId;

  /// 是否已删除 0没有 1删除
  int isDelete;

  int createTimestamp;

  String createTime;

  int updateTimestamp;

  String updateTime;

  XTRemark();

  factory XTRemark.fromJson(Map<String, dynamic> json) {
    return XTRemark()
      ..id = json['id'] as int
      ..remarkId = json['remarkId'] as String
      ..userKey = json['userKey'] as String
      ..remark = json['remark'] as String
      ..images = json['images'] as String
      ..xtId = json['xtId'] as int
      ..isDelete = json['isDelete'] as int
      ..createTimestamp = json['createTimestamp'] as int
      ..updateTimestamp = json['updateTimestamp'] as int
      ..createTime = json['createTime'] as String
      ..updateTime = json['updateTime'] as String;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'remarkId': remarkId,
        'userKey': userKey,
        'remark': remark,
        'xtId': xtId,
        'images': images,
        'isDelete': isDelete,
        'createTime': createTime,
        'updateTime': updateTime,
        'createTimestamp': createTimestamp,
        'updateTimestamp': updateTimestamp,
      };
}
