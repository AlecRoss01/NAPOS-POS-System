import 'dart:convert';
class MenuItem {
  /*
  Represents one item on the menu.
  */

  // MEMBERS

  int id = 0;
  String name = "";
  Set<String> _catTags = {};
  double _price = 0.0;
  // Initializer; Sets members with parameter data.
  MenuItem(this.name,
      // Optional parameters.
      // Curly braces mean their name must be used in initialization.
      // Like: MenuItem('Hot Dog', price : 1.25)
      {
        int id = 0,
        double price = 0,
      }) {
    this.id = id;
    this._price = price;
  }

  // METHODS

  // Private variable, externally it will appear as 'categories'
  Set<String> get categories { return _catTags; }

  double get price { return _price; }

  // String of price with USD sign and to two decimals.
  String strPrice() {
    return "\$${price.toStringAsFixed(2)}";
  }

  // Clears all category tags.
  void clearCatTags() { _catTags = {}; }

  // Adds a single category tag.
  void addCatTag (String tag) { _catTags.add(tag); }

  // Adds multiple category tags.
  void addCatTags(List<String> tags) {
    for (var tag in tags) { addCatTag(tag); }
  }

  // Set category tags to the given ones. Clears it first.
  void setCatTags(List<String> tags) {
    clearCatTags();
    addCatTags(tags);
  }

  // Remove a given tag.
  void removeCatTag(String tag) { _catTags.remove(tag); }

  // toString will return the string order ID.
  @override
  String toString() {
    return name;
  }

  convertHashtoList(Set m) {
    var len = m.length;
    List<String> tags = List<String>.filled(len, "");
    for( var i = 0 ; i < m.length ; i++) {
      tags[i] = m.elementAt(i);
    }
    return tags;
  }

  Map<String, dynamic> toJson() => {
    'Id' : id,
    'Name' : name,
    'CatTags' : convertHashtoList(_catTags),
    'Price' : _price,
  };
}