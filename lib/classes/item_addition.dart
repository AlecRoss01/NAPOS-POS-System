class ItemAddition {
  String _name;
  int _id;
  double _price;
  AdditionType _type = AdditionType.none;

  ItemAddition(this._name, this._id, this._price);

  String get name {
    return _name;
  }

  int get id {
    return _id;
  }

  double getprice() {
    if (_type == AdditionType.remove || _type == AdditionType.light) {
      return 0;
    } else {
      return _price;
    }
  }

  @override
  String toString() {
    return _name;
  }

  String typeAndNameString() {
    return "${getTypeAsString(_type)} $_name";
  }

  String strPrice() {
    return "\$${_price.toStringAsFixed(2)}";
  }

  void setAdditionType(AdditionType type) {
    _type = type;
  }

  ItemAddition.fromJson(Map<String, dynamic> json)
      : _name = json['Name'],
        _id = json['Id'],
        _price = json['Price'].toDouble(),
        _type = getStringAsType(json['AdditionType']);

  Map<String, dynamic> toJson() => {
        'Id': _id,
        'Name': _name,
        'AdditionType': getTypeAsString(_type),
        'Price': _price
      };
}

String getTypeAsString(AdditionType type) {
  if (type == AdditionType.add) {
    return "add";
  } else if (type == AdditionType.remove) {
    return "remove";
  } else if (type == AdditionType.light) {
    return "light";
  } else if (type == AdditionType.extra) {
    return "extra";
  } else {
    return "none";
  }
}

AdditionType getStringAsType(String str) {
  if (str == "add") {
    return AdditionType.add;
  } else if (str == "remove") {
    return AdditionType.remove;
  } else if (str == "light") {
    return AdditionType.light;
  } else if (str == "extra") {
    return AdditionType.extra;
  } else {
    return AdditionType.none;
  }
}

enum AdditionType { remove, add, light, extra, none }
