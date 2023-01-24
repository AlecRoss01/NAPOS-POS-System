import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/menu_item.dart' as menu_item;
import '../classes/order.dart';

class CategorySection extends StatefulWidget{
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 150, // Fixed width of 150 px
      child: Column(
        children: [
          //Header for the Categories
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.topLeft,
            child: const Text("Categories", style: CustomTextStyle.homeButtons),
          ),

          // Expanded is needed to define the width of the cards. Column doesn't restrict it so render error occurs.
          Expanded(
            // Future Builder makes it empty initially. Then when recvCats returns, it builds.
            child: FutureBuilder<List<String>>(
              future: recvCats(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    // snapshot.data! assures dart it will be defined.
                    children: List.generate(snapshot.data!.length, (index) {
                      return InkWell(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(snapshot.data![index])
                          ),
                        ),
                        onTap: () {},
                      );
                    })
                  );
                }
                else {
                  return ListView();
                }
              },
            )
          )
        ],
      ),
    );
  }
}

class CommandHub extends StatefulWidget {
  const CommandHub({super.key});

  @override
  State<CommandHub> createState() => _CommandHub();
}

class _CommandHub extends State<CommandHub> {
  final order = <menu_item.MenuItem>[];

  @override
  Widget build(BuildContext context) {
    // Dimensions of app
    double contextWidth = MediaQuery.of(context).size.width;
    double contextHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Command Hub'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            children: <Widget>[
              CategorySection()
              // 1st section, section that holds buttons for each of the categories on the menu.
              // Uses categories list.
              ,

              // 2nd section, section that holds item buttons according to whichever button was pressed in 1st section.
              // Uses menu list.
              //width: contextWidth * 0.6, // <-- Old
              Expanded(
                child: Column(
                  children: [
                    // Header for the MenuItems grid
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.topLeft,
                      child: const Text("Items", style: CustomTextStyle.homeButtons),
                    ),

                    // Being an expanded lets it take up all available space between categories and curr order columns.
                    Expanded(
                      // Gridview method: https://codesinsider.com/flutter-gridview-example/
                      // Gridview.count method: https://www.geeksforgeeks.org/flutter-gridview/
                      child: FutureBuilder<List<menu_item.MenuItem>>(
                        future: recvMenu(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return
                              GridView(
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 150,
                                    mainAxisExtent: 100,
                                  ),
                                  padding: const EdgeInsets.only(left:10.0, right:10),
                                  shrinkWrap: true,
                                  // Generates the cards for GridView from 'menu'
                                  children: List.generate(snapshot.data!.length, (index) {
                                    return InkWell(
                                      child: Card(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(snapshot.data![index].toString()),
                                              const Text('1.0')
                                            ],
                                          )
                                      ),
                                      // On click it adds the corresponding menu item to the order.
                                      onTap: () {
                                        setState(() {
                                          order.add(snapshot.data![index]);
                                        });
                                      },
                                    );
                                  })
                              );
                          }
                          else {
                            return GridView.count(crossAxisCount: 2);
                          }
                        },
                      )
                    )
                  ],
                ),
              ),

              // 3rd section, section that contains order information and buttons that apply to order.
              SizedBox(
                width: 200,
                child: Column(
                    children: [
                      // Header for the MenuItems grid.
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.topLeft,
                        child: const Text("Current Order", style: CustomTextStyle.homeButtons),
                      ),

                      // Current order details.
                      Expanded(
                          //height: 300,
                          child: ListView(
                              children: List.generate(order.length, (index) {
                                return InkWell(
                                  child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(order[index].toString())
                                          ],
                                        )
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      order.removeAt(index);
                                    });
                                  },
                                );
                              })
                          )
                      ),

                      // Spacer between list of order items and command buttons.
                      const SizedBox( height: 10,),

                      // Command buttons (pay, receipt, etc).
                      SizedBox(
                        height: 105,
                        child: GridView(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100,
                            mainAxisExtent: 50,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          shrinkWrap: true,
                          children: [
                            TextButton(
                              style: CustomTextStyle.commandHubCommands,
                              child: const Text("Send"),
                              onPressed: () {
                                setState(() {
                                  // TEMPORARY, ONLY SENDS FIRST ITEM IN ORDER
                                  if (order.isNotEmpty) {
                                    //print(Order(0, order[0].toString()));
                                    //print(Order(0, order[0].toString()).orderItem());
                                    sendOrder(Order(0, order[0].toString()));
                                    order.clear();
                                  }
                                });
                              },
                            ),
                            TextButton(
                              style: CustomTextStyle.commandHubCommands,
                              child: const Text("Pay"),
                              onPressed: () {},
                            ),
                            TextButton(
                              style: CustomTextStyle.commandHubCommands,
                              child: const Text("Receipt"),
                              onPressed: () {},
                            ),
                            TextButton(
                              style: CustomTextStyle.commandHubCommands,
                              child: const Text("Edit"),
                              onPressed: () {},
                            )
                          ],
                        ),
                      )
                    ]
                ),
              )
            ]
        ),
      )
    );
  }
}