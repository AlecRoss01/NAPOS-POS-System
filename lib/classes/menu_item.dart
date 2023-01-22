class MenuItem {
  /*
  Represents one item on the menu.
  */

  // MEMBERS

  int id = 0;
  String name = "";
  List catTags = <String>[];
  double price = 0.0;


  // Initializer; Sets members with parameter data.
  MenuItem(this.id, this.name,
      // Optional parameters.
      [
        this.price = 0,
        this.catTags = const <String>[]
      ]);

  // METHODS

  double getPrice() {
    return price;
  }

  // toString will return the string order ID.
  @override
  String toString() {
    return name;
  }
}