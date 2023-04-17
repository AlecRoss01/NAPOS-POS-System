import 'package:flutter/material.dart';
import 'package:napos/classes/employee.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';
import 'CH_EditItemSidebar.dart';

class ItemInCurrentOrderDisplay extends StatefulWidget {
  final menu_item.MenuItem menuItem;
  final double width;

  const ItemInCurrentOrderDisplay({
    super.key,
    required this.menuItem,
    required this.width,
  });

  @override
  State<ItemInCurrentOrderDisplay> createState() => _ItemInCurrentOrderDisplayState();
}

class _ItemInCurrentOrderDisplayState extends State<ItemInCurrentOrderDisplay> {

  Widget buildTotalRow(BuildContext context) {
    if (widget.menuItem.additions.isNotEmpty) {
      return Row(
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: widget.width * 6/10,
            ),
            child: const Text("Total"),
          ),
          Spacer(),
          Text(widget.menuItem.strPriceWithAdditions()),
        ],
      );
    }
    else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.menuItem.additions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: widget.width * 6/10,
              ),
              child: Text(widget.menuItem.name),
            ),
            Spacer(),
            Text(widget.menuItem.strPrice()),
          ],
        ),

        Column(
          children: List.generate(widget.menuItem.additions.length, (index) {
            return Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: widget.width * 6/10,
                  ),
                  child: Text(widget.menuItem.additions[index].name),
                ),
                Spacer(),
                Text(widget.menuItem.additions[index].strPrice()),
              ],
            );
          }),
        ),

        buildTotalRow(context),

      ],
    );
  }

}