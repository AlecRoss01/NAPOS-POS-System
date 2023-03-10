import 'dart:convert';
class ItemAddition {
  String _name;
  int _id;
  double _price;

  ItemAddition(this._name, this._id, this._price);

  String get name { return _name; }
  int get id { return _id; }

  double getprice(AdditionType addType) {
    if (addType == AdditionType.remove || addType == AdditionType.light){
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

}

enum AdditionType{
  remove,
  add,
  light,
  extra
}