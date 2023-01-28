import "menu_item.dart";

class POS_Category {
    String name;
    int id;
    final listOfItems = <MenuItem>[];

    POS_Category(this.name, this.id);

    void populateItemList() {
        
    }

    @override
    String toString() {
        return name;
    }
}