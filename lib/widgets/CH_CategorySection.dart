import 'package:flutter/material.dart';
import '../styles/styles.dart';
import '../back_end/client.dart';
import '../classes/category.dart';

class CategorySection extends StatefulWidget{
  final Function(POS_Category) changeCategory;
  final double width;

  const CategorySection({
    super.key,
    required this.changeCategory,
    required this.width,
  });

  @override
  State<CategorySection> createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: widget.width, // Fixed width of 150 px
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
                        onTap: () {
                          var cat = new POS_Category(snapshot.data![index]);
                          widget.changeCategory(cat);
                        },
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