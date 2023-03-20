import 'dart:convert';
class ItemAddition {
  String _name;
  int _id;
  double _price;
  AdditionType _type = AdditionType.none;

  ItemAddition(this._name, this._id, this._price);

  String get name { return _name; }
  int get id { return _id; }

  double getprice() {
    if (_type == AdditionType.remove || _type == AdditionType.light){
      return 0;
    } else {
      return _price;
    }
  }

  @override
  String toString() {
    return _name;
  }

  String strPrice() {
    return "\$${_price.toStringAsFixed(2)}";
  }

  void setAdditionType(AdditionType type){
    _type = type;
  }

}

enum AdditionType{
  remove,
  add,
  light,
  extra,
  none
}