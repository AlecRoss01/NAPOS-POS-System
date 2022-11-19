class CommandHub extends StatelessWidget {
  const CommandHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Command Hub'),
      ),
      body: Row(
        children: <Widget>[
          //1st section, section that holds buttons for each of the categories on the menu
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 10
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: Text("Food")
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Drinks")
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Merch")
                  )
                ]
              )
            )
          ),
          //2nd section, section that holds item buttons according to whichever button was pressed in 1st section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 10
                  )
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 1")
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 2")
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 3")
                        )
                      ]
                    )
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 4")
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 5")
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text("Item 6")
                        )
                      ]
                    )
                  ) 
                ]
              )
            )
          ),
          //3rd section, section that contains order information and buttons that apply to order
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 10
                      )
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text("Order info goes here.")
                            ]
                          )
                        )
                      ]
                    )
                  )
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 10
                      )
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: () {},
                                child: Text("Send")
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text("Pay")
                              )
                            ]
                          )
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: () {},
                                child: Text("Print Receipt")
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text("Edit")
                              )
                            ]
                          )
                        )
                      ]
                    )
                  )
                )
              ]
            )
          )
        ]
      ),
    );
  }
}