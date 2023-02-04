import "menu_item.dart";

class POS_Category {
    String _name;
    int id;
    final listOfItems = <MenuItem>[];

    POS_Category(this._name, this.id);

    void populateItemList() {
        
    }

    @override
    String toString() {
        return _name;
    }

    String get name { return _name; }
}