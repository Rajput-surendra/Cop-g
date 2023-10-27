/// message : "Category retrieved successfully"
/// error : false
/// total : 5
/// data : [{"id":"1","name":"test","parent_id":"0","slug":"test-1","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes2.jpg","banner":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes1.jpg","row_order":"0","status":"1","clicks":"35","children":[{"id":"3","name":"test sub","parent_id":"1","slug":"test-sub","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image222.jpg","banner":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image222.jpg","row_order":"0","status":"1","clicks":"0","children":[{"id":"5","name":"test child","parent_id":"3","slug":"test-child","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes12.jpg","banner":"https://developmentalphawizz.com/COP/","row_order":"0","status":"1","clicks":"0","children":[],"text":"test child","state":{"opened":true},"level":2}],"text":"test sub","state":{"opened":true},"level":1}],"text":"test","state":{"opened":true},"icon":"jstree-folder","level":0,"total":5},{"id":"2","name":"tesr","parent_id":"0","slug":"tesr-1","image":"https://developmentalphawizz.com/COP/uploads/media/2023/sneaker_shoes.jpeg","banner":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image.jpg","row_order":"0","status":"1","clicks":"0","children":[],"text":"tesr","state":{"opened":true},"icon":"jstree-folder","level":0},{"id":"4","name":"Sneaker","parent_id":"0","slug":"sneaker","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes4.jpg","banner":"https://developmentalphawizz.com/COP/","row_order":"0","status":"1","clicks":"0","children":[],"text":"Sneaker","state":{"opened":true},"icon":"jstree-folder","level":0}]
/// popular_categories : [{"id":"1","name":"test","parent_id":"0","slug":"test-1","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes2.jpg","banner":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes1.jpg","row_order":"0","status":"1","clicks":"35","children":[{"id":"3","name":"test sub","parent_id":"1","slug":"test-sub","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image222.jpg","banner":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image222.jpg","row_order":"0","status":"1","clicks":"0","children":[{"id":"5","name":"test child","parent_id":"3","slug":"test-child","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes12.jpg","banner":"https://developmentalphawizz.com/COP/","row_order":"0","status":"1","clicks":"0","children":[],"text":"test child","state":{"opened":true},"level":2}],"text":"test sub","state":{"opened":true},"level":1}],"text":"test","state":{"opened":true},"icon":"jstree-folder","level":0,"total":5}]

class GetNewCateBidingModel {
  GetNewCateBidingModel({
      String? message, 
      bool? error, 
      num? total, 
      List<Data>? data, 
      List<PopularCategories>? popularCategories,}){
    _message = message;
    _error = error;
    _total = total;
    _data = data;
    _popularCategories = popularCategories;
}

  GetNewCateBidingModel.fromJson(dynamic json) {
    _message = json['message'];
    _error = json['error'];
    _total = json['total'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    if (json['popular_categories'] != null) {
      _popularCategories = [];
      json['popular_categories'].forEach((v) {
        _popularCategories?.add(PopularCategories.fromJson(v));
      });
    }
  }
  String? _message;
  bool? _error;
  num? _total;
  List<Data>? _data;
  List<PopularCategories>? _popularCategories;
GetNewCateBidingModel copyWith({  String? message,
  bool? error,
  num? total,
  List<Data>? data,
  List<PopularCategories>? popularCategories,
}) => GetNewCateBidingModel(  message: message ?? _message,
  error: error ?? _error,
  total: total ?? _total,
  data: data ?? _data,
  popularCategories: popularCategories ?? _popularCategories,
);
  String? get message => _message;
  bool? get error => _error;
  num? get total => _total;
  List<Data>? get data => _data;
  List<PopularCategories>? get popularCategories => _popularCategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['error'] = _error;
    map['total'] = _total;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_popularCategories != null) {
      map['popular_categories'] = _popularCategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1"
/// name : "test"
/// parent_id : "0"
/// slug : "test-1"
/// image : "https://developmentalphawizz.com/COP/uploads/media/2023/shoes2.jpg"
/// banner : "https://developmentalphawizz.com/COP/uploads/media/2023/shoes1.jpg"
/// row_order : "0"
/// status : "1"
/// clicks : "35"
/// children : [{"id":"3","name":"test sub","parent_id":"1","slug":"test-sub","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image222.jpg","banner":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image222.jpg","row_order":"0","status":"1","clicks":"0","children":[{"id":"5","name":"test child","parent_id":"3","slug":"test-child","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes12.jpg","banner":"https://developmentalphawizz.com/COP/","row_order":"0","status":"1","clicks":"0","children":[],"text":"test child","state":{"opened":true},"level":2}],"text":"test sub","state":{"opened":true},"level":1}]
/// text : "test"
/// state : {"opened":true}
/// icon : "jstree-folder"
/// level : 0
/// total : 5

class PopularCategories {
  PopularCategories({
      String? id, 
      String? name, 
      String? parentId, 
      String? slug, 
      String? image, 
      String? banner, 
      String? rowOrder, 
      String? status, 
      String? clicks, 

      String? text, 

      String? icon, 
      num? level, 
      num? total,}){
    _id = id;
    _name = name;
    _parentId = parentId;
    _slug = slug;
    _image = image;
    _banner = banner;
    _rowOrder = rowOrder;
    _status = status;
    _clicks = clicks;

    _text = text;
  
    _icon = icon;
    _level = level;
    _total = total;
}

  PopularCategories.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _slug = json['slug'];
    _image = json['image'];
    _banner = json['banner'];
    _rowOrder = json['row_order'];
    _status = json['status'];
    _clicks = json['clicks'];

    _text = json['text'];
    _icon = json['icon'];
    _level = json['level'];
    _total = json['total'];
  }
  String? _id;
  String? _name;
  String? _parentId;
  String? _slug;
  String? _image;
  String? _banner;
  String? _rowOrder;
  String? _status;
  String? _clicks;
  String? _text;

  String? _icon;
  num? _level;
  num? _total;
PopularCategories copyWith({  String? id,
  String? name,
  String? parentId,
  String? slug,
  String? image,
  String? banner,
  String? rowOrder,
  String? status,
  String? clicks,

  String? text,

  String? icon,
  num? level,
  num? total,
}) => PopularCategories(  id: id ?? _id,
  name: name ?? _name,
  parentId: parentId ?? _parentId,
  slug: slug ?? _slug,
  image: image ?? _image,
  banner: banner ?? _banner,
  rowOrder: rowOrder ?? _rowOrder,
  status: status ?? _status,
  clicks: clicks ?? _clicks,
  text: text ?? _text,
  icon: icon ?? _icon,
  level: level ?? _level,
  total: total ?? _total,
);
  String? get id => _id;
  String? get name => _name;
  String? get parentId => _parentId;
  String? get slug => _slug;
  String? get image => _image;
  String? get banner => _banner;
  String? get rowOrder => _rowOrder;
  String? get status => _status;
  String? get clicks => _clicks;
  String? get text => _text;
  String? get icon => _icon;
  num? get level => _level;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['parent_id'] = _parentId;
    map['slug'] = _slug;
    map['image'] = _image;
    map['banner'] = _banner;
    map['row_order'] = _rowOrder;
    map['status'] = _status;
    map['clicks'] = _clicks;
    map['text'] = _text;
    map['icon'] = _icon;
    map['level'] = _level;
    map['total'] = _total;
    return map;
  }

}

/// opened : true


/// id : "3"
/// name : "test sub"
/// parent_id : "1"
/// slug : "test-sub"
/// image : "https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image222.jpg"
/// banner : "https://developmentalphawizz.com/COP/uploads/media/2023/shoes_image222.jpg"
/// row_order : "0"
/// status : "1"
/// clicks : "0"
/// children : [{"id":"5","name":"test child","parent_id":"3","slug":"test-child","image":"https://developmentalphawizz.com/COP/uploads/media/2023/shoes12.jpg","banner":"https://developmentalphawizz.com/COP/","row_order":"0","status":"1","clicks":"0","children":[],"text":"test child","state":{"opened":true},"level":2}]
/// text : "test sub"
/// state : {"opened":true}
/// level : 1

class Data {
  Data({
      String? id, 
      String? name, 
      String? parentId, 
      String? slug, 
      String? image, 
      String? banner, 
      String? rowOrder, 
      String? status, 
      String? clicks,
      String? text, 

      String? icon, 
      num? level, 
      num? total,}){
    _id = id;
    _name = name;
    _parentId = parentId;
    _slug = slug;
    _image = image;
    _banner = banner;
    _rowOrder = rowOrder;
    _status = status;
    _clicks = clicks;
    _text = text;
    _icon = icon;
    _level = level;
    _total = total;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _slug = json['slug'];
    _image = json['image'];
    _banner = json['banner'];
    _rowOrder = json['row_order'];
    _status = json['status'];
    _clicks = json['clicks'];

    _text = json['text'];
    _icon = json['icon'];
    _level = json['level'];
    _total = json['total'];
  }
  String? _id;
  String? _name;
  String? _parentId;
  String? _slug;
  String? _image;
  String? _banner;
  String? _rowOrder;
  String? _status;
  String? _clicks;

  String? _text;

  String? _icon;
  num? _level;
  num? _total;
Data copyWith({  String? id,
  String? name,
  String? parentId,
  String? slug,
  String? image,
  String? banner,
  String? rowOrder,
  String? status,
  String? clicks,

  String? text,

  String? icon,
  num? level,
  num? total,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  parentId: parentId ?? _parentId,
  slug: slug ?? _slug,
  image: image ?? _image,
  banner: banner ?? _banner,
  rowOrder: rowOrder ?? _rowOrder,
  status: status ?? _status,
  clicks: clicks ?? _clicks,

  text: text ?? _text,

  icon: icon ?? _icon,
  level: level ?? _level,
  total: total ?? _total,
);
  String? get id => _id;
  String? get name => _name;
  String? get parentId => _parentId;
  String? get slug => _slug;
  String? get image => _image;
  String? get banner => _banner;
  String? get rowOrder => _rowOrder;
  String? get status => _status;
  String? get clicks => _clicks;

  String? get text => _text;

  String? get icon => _icon;
  num? get level => _level;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['parent_id'] = _parentId;
    map['slug'] = _slug;
    map['image'] = _image;
    map['banner'] = _banner;
    map['row_order'] = _rowOrder;
    map['status'] = _status;
    map['clicks'] = _clicks;

    map['text'] = _text;
    map['icon'] = _icon;
    map['level'] = _level;
    map['total'] = _total;
    return map;
  }

}
