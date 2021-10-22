class BillRecordResponse extends Object {
  int code;

  List<BillRecordModel> data;

  String msg;

  BillRecordResponse(
    this.code,
    this.data,
    this.msg,
  );

  factory BillRecordResponse.fromJson(Map<String, dynamic> json) {
    return BillRecordResponse(
      json['code'] as int,
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : BillRecordModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['msg'] as String,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'data': data,
        'msg': msg,
      };
}

class RemarkBean extends Object {
  int id;

  String userKey;

  String remarkId;

  String remark;

  int billId;

  int createTimestamp;

  String createTime;

  int updateTimestamp;

  String updateTime;

  RemarkBean();

  factory RemarkBean.fromJson(Map<String, dynamic> json) {
    return RemarkBean()
      ..id = json['id'] as int
      ..remarkId = json['remarkId'] as String
      ..userKey = json['userKey'] as String
      ..remark = json['remark'] as String
      ..billId = json['billId'] as int
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
        'billId': billId,
        'createTime': createTime,
        'updateTime': updateTime,
        'createTimestamp': createTimestamp,
        'updateTimestamp': updateTimestamp,
      };
}

class BillRecordModel extends Object {
  int id;

  String userKey;

  double money;

  String remarkId;

  String remark;

  String categoryImage;

  /// 类型 1支出 2收入
  int type;

  /// 是否已删除 0没有 1删除
  int isDelete;

  int createTimestamp;

  String createTime;

  int updateTimestamp;

  String updateTime;

  BillRecordModel();

  factory BillRecordModel.fromJson(Map<String, dynamic> json) {
    return BillRecordModel()
      ..id = json['id'] as int
      ..money = ((json['money'] as num)?.toDouble())
      ..remarkId = json['remarkId'] as String
      ..userKey = json['userKey'] as String
      ..remark = json['remark'] as String
      ..type = json['type'] as int
      ..createTimestamp = json['createTimestamp'] as int
      ..updateTimestamp = json['updateTimestamp'] as int
      ..categoryImage = json['categoryImage'] as String
      ..createTime = json['createTime'] as String
      ..updateTime = json['updateTime'] as String
      ..isDelete = json['isDelete'] as int;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'money': money,
        'remarkId': remarkId,
        'remark': remark,
        'categoryName': categoryImage,
        'userKey': userKey,
        'type': type,
        'isDelete': isDelete,
        'createTime': createTime,
        'updateTime': updateTime,
        'createTimestamp': createTimestamp,
        'updateTimestamp': updateTimestamp,
      };
}

class CategoryItem extends Object {
  String name;

  String image;

  int sort;

  CategoryItem(this.name, this.image, this.sort);

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      json['name'] as String,
      json['image'] as String,
      json['sort'] as int,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'image': image,
        'sort': sort,
      };
}
