class MenuItem {

  String name = "";
  double price = 0.0;

  // Sets members with parameter data.
  MenuItem(this.name, this.price);

  // toString will return the string order ID.
  @override
  String toString() {
    return name;
  }
}