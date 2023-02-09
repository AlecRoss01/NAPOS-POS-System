import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';

class EditItemSidebar extends StatefulWidget {
    final menu_item.MenuItem editItem;
    const EditItemSidebar({super.key, required this.editItem});

    @override
    State<EditItemSidebar> createState() => _EditItemSidebarState();
}

class _EditItemSidebarState extends State<EditItemSidebar> {
    @override
    Widget build(BuildContext context) {
        return Drawer(
            child: Text(widget.editItem.toString())
        );
    } 
}