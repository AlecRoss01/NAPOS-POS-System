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
      [
        this.id = 0,
        this._price = 0,
      ]);

  // METHODS

  // Private variable, externally it will appear as 'categories'
  Set<String> get categories { return _catTags; }

  double get price { return _price; }

  // String of price with USD sign and to two decimals.
  String strSubTotal() {
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
}