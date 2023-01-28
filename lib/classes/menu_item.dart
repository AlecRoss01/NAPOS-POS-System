class MenuItem {

  String name = "";
  int id = 0;
  //double price = 0.0;

  // Sets members with parameter data.
  MenuItem(this.id, this.name){
  }

  // toString will return the string order ID.
  @override
  String toString() {
    return name;
  }
}