import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';
import '../classes/category.dart';
import '../classes/employee.dart';
import '../classes/item_addition.dart';
import '../widgets/CH_MenuSection.dart';
import '../widgets/CH_CategorySection.dart';
import '../widgets/CH_OrderSection.dart';
import '../widgets/CH_EditItemSidebar.dart';

class CommandHub extends StatefulWidget {
  NAPOS_Employee employee;

  CommandHub({
    super.key,
    required this.employee,
  });

  @override
  State<CommandHub> createState() => _CommandHub();
}

class _CommandHub extends State<CommandHub> {
  late var currentOrder = new Order(widget.employee, id : 1);
  POS_Category currentCategory = new POS_Category("All");
  menu_item.MenuItem itemToEdit = new menu_item.MenuItem("default");
  final double orderSectionWidth = 200;
  final double categoriesSectionWidth = 150;

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId("sandbox-sq0idb-5l8c2u8OdZQNh_t3Tk43QQ");
  }

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);
      await chargeCard(result, currentOrder.getSubTotal());

      // payment finished successfully
      // you must call this method to close card entry
      // this ONLY apply to startCardEntryFlow, please don't call this method when use startCardEntryFlowWithBuyerVerification
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.toString());
    }
  }

  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
  }

  void payButtonClick(Order order) {
    setState(() {
      _onStartCardEntryFlow();
    });
  }
  
  void addToOrder(menu_item.MenuItem item) {
    setState(() {
      currentOrder.addItemToOrder(item);
    });
  }

  void changeCurrentCategory(POS_Category newCat) {
    setState(() { 
      currentCategory = newCat;
    });
  }

  void setItemToEdit(menu_item.MenuItem item) {
    setState(() {
      itemToEdit = item;
    });
  }

  void removeItemFromOrder(menu_item.MenuItem item) {
    setState(() {
      currentOrder.removeItemFromOrder(item);
    });
  }


  @override
  void initState() {
    super.initState();
    _initSquarePayment();
  }

  @override
  Widget build(BuildContext context) {
    // Dimensions of app
    double contextWidth = MediaQuery.of(context).size.width;
    double contextHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      endDrawer: EditItemSidebar(editItem: itemToEdit, removeItemFromOrder: removeItemFromOrder),
      appBar: AppBar(
        title: const Text('Command Hub'),
        actions: <Widget>[
          new Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            // 1st section, section that holds buttons for each of the categories on the menu.
            // Uses categories list.
            CategorySection(
              changeCategory: changeCurrentCategory,
              width: categoriesSectionWidth,
            ),

            // 2nd section, section that holds item buttons according to whichever button was pressed in 1st section.
            // Uses menu list.
            //width: contextWidth * 0.6, // <-- Old
            MenuItemSection(addItemToOrder: addToOrder, categoryToBeDisplayed: currentCategory),

            // 3rd section, section that contains order information and buttons that apply to order.
            OrderSection(
              currentOrder: currentOrder,
              setEditItem: setItemToEdit,
              payButtonClick: payButtonClick,
              width: orderSectionWidth,
              employee: widget.employee,
            )
          ]
        ),
      )
    );
  }
}