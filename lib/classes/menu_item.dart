import 'item_addition.dart';

class MenuItem {
  /*
  Represents one item on the menu.
  */

  int id = 0;
  String name = "";
  String description = "";
  Set<String> _catTags = {};
  double _price = 0.0;
  List<ItemAddition> additions = [];

  MenuItem(
    this.name,
    // Optional parameters.
    // Curly braces mean their name must be used in initialization.
    // Like: MenuItem('Hot Dog', price : 1.25)
    {
    this.id = 0,
    double price = 0,
    this.description = "",
  }) {
    _price = price;
  }

  // _catTags is a private variable, externally it will appear as 'categories'
  Set<String> get categories {
    return _catTags;
  }

  // Sum of prices of all item additions.
  double get additionPrice {
    double additionSum = 0;
    for (int i = 0; i < additions.length; i++) {
      additionSum += additions[i].getprice();
    }
    return additionSum;
  }

  double get price {
    return _price + additionPrice;
  }

  double get defaultPrice {
    return _price;
  }

  // String of price with USD sign and to two decimals.
  String strPrice() {
    return "\$${defaultPrice.toStringAsFixed(2)}";
  }

  // String of price + additions price with USD sign and to two decimals.
  String strPriceWithAdditions() {
    return "\$${price.toStringAsFixed(2)}";
  }

  void clearCatTags() {
    _catTags = {};
  }

  void addCatTag(String tag) {
    _catTags.add(tag);
  }

  void addCatTags(List<String> tags) {
    for (var tag in tags) {
      addCatTag(tag);
    }
  }

  void setCatTags(List<String> tags) {
    clearCatTags();
    addCatTags(tags);
  }

  void removeCatTag(String tag) {
    _catTags.remove(tag);
  }

  void addAddition(ItemAddition addition) {
    additions.add(addition);
  }

  void removeAddition(ItemAddition addition) {
    additions.remove(addition);
  }

  @override
  String toString() {
    return name;
  }

  convertHashtoList(Set m) {
    var len = m.length;
    List<String> tags = List<String>.filled(len, "");
    for (var i = 0; i < m.length; i++) {
      tags[i] = m.elementAt(i);
    }
    return tags;
  }

  MenuItem.fromJson(Map<String, dynamic> json)
    : id = json['Id'],
      name = json['Name'],
      _catTags = json['CatTags'],
      _price = json['Price'].toDouble();

  Map<String, dynamic> toJson() => {
    'Id': id,
    'Name': name,
    'CatTags': convertHashtoList(_catTags),
    'Price': _price,
  };
}
