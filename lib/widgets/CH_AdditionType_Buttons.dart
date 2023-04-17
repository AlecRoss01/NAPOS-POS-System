import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';
import '../classes/item_addition.dart';

class AdditionTypeToggleButtons extends StatefulWidget {
  final Function(AdditionType) setAdditionType;

  const AdditionTypeToggleButtons({
    super.key,
    required this.setAdditionType
  });

  @override
  State<AdditionTypeToggleButtons> createState() => _AdditionTypeToggleButtonsState();
}

class _AdditionTypeToggleButtonsState extends State<AdditionTypeToggleButtons> {
  List<bool> selected = [true, false, false, false];

  @override
  Widget build(BuildContext context){
    return ToggleButtons(
      isSelected: selected,
      color: Colors.red,
      fillColor: Colors.black26,
      children: const <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text ("Add"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text ("Remove"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text ("Light"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text ("Extra"),
        ),
      ],
      onPressed: (int index) {
        if (index == 0){
          widget.setAdditionType(AdditionType.add);
          selected[0] = true;
          selected[1] = false;
          selected[2] = false;
          selected[3] = false;
        } else if (index == 1){
          widget.setAdditionType(AdditionType.remove);
          selected[0] = false;
          selected[1] = true;
          selected[2] = false;
          selected[3] = false;
        } else if (index == 2){
          widget.setAdditionType(AdditionType.light);
          selected[0] = false;
          selected[1] = false;
          selected[2] = true;
          selected[3] = false;
        } else if (index == 3){
          widget.setAdditionType(AdditionType.extra);
          selected[0] = false;
          selected[1] = false;
          selected[2] = false;
          selected[3] = true;
        }
      },
    );
  }
}

/*
class AdditionTypeButton extends StatefulWidget {
  final AdditionType additionType;
  final Function(AdditionType) setAdditionType;
  bool selected;
  AdditionTypeButton({
    super.key,
    required this.selected,
    required this.additionType,
    required this.setAdditionType
  });

  @override
  State<AdditionTypeButton> createState() => _AdditionTypeButtonState();
}

class _AdditionTypeButtonState extends State<AdditionTypeButton> {

  Color getBackgroundColor() {
    if (widget.selected){
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  void deselect(){
    setState(() {
      widget.selected = false;
    });
  }

  @override
  Widget build(BuildContext context){
    return OutlinedButton(
        child: Text(getTypeAsString(widget.additionType),
        style: TextStyle(color: Colors.black45)),
        onPressed:() {
          setState(() {
            widget.selected = !widget.selected;
            widget.setAdditionType(widget.additionType);
          });
          },
        style: OutlinedButton.styleFrom(backgroundColor: getBackgroundColor())
    );
  }
}

 */