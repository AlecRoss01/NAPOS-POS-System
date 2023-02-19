package main

import (
	"encoding/json"
	"fmt"
	"net"
	"strconv"
	"strings"
)

type MenuItem struct {
	Id      int
	Name    string
	CatTags []string
	Price   float64
}

type Menu struct {
	MenuItems []MenuItem
}

type Order struct {
	OrderIDNullChar string
	OrderIDLength   int
	OrderID         int
	OrderItems      []MenuItem
}

type HistOrder struct {
	Orders []Order
}

type Request struct {
	RequestType string
}

// https://stackoverflow.com/questions/30190159/golang-server-how-to-receive-tcp-json-packet

func handleServerConnection(c net.Conn) {

	// we create a decoder that reads directly from the socket
	d := json.NewDecoder(c)

	var msg Request

	err := d.Decode(&msg)
	fmt.Println(msg, err)
	if err != nil {
		fmt.Println("error in handleServerConnection")
	}
	switch requestType := msg.RequestType; requestType {
	case "MENU":
		sendMenu(c)
	case "SENDMENU":
		recvMenuItem(c)
	case "ORDERS":
		sendOrders(c)
	case "SENDORDER":
		recvOrder(c)
	default:
		fmt.Printf("reached default in request type, request was: %s", requestType)
	}
}

func writeToConnection(c net.Conn) {
	// encoder stuff https://pkg.go.dev/encoding/json#NewEncoder
	msg := MenuItem{1, "pasta", []string{}, 13.45}
	e := json.NewEncoder(c)
	err := e.Encode(msg)
	if err != nil {
		fmt.Println("Error Occuered in Write to Server")
	}

	c.Close()
}

func sendMenu(c net.Conn) {
	msg := MenuItem{1, "pasta", []string{"All", "Food"}, 13.45}
	msg2 := MenuItem{2, "pizza", []string{"All", "Drink"}, 17.95}
	msg3 := MenuItem{3, "fish and chips", []string{"All", "Food"}, 20.99}
	menu := Menu{[]MenuItem{msg, msg2, msg3}}
	//part above is where I would get the menu from the database
	e := json.NewEncoder(c)
	err := e.Encode(menu)
	if err != nil {
		fmt.Println("Error Occuered in sendMenu")
	}
	c.Close()
}

func recvMenuItem(c net.Conn) {
	d := json.NewDecoder(c)

	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Close()
}

func sendOrders(c net.Conn) {
	msg := Order{"0", 2, 2, []MenuItem{{1, "pasta", []string{}, 13.45}}}
	msg2 := Order{"0", 2, 3, []MenuItem{{1, "pizza", []string{}, 14.95}}}
	histOrds := HistOrder{[]Order{msg, msg2}}
	//part above is where I would get the data from the database
	e := json.NewEncoder(c)
	err := e.Encode(histOrds)
	if err != nil {
		fmt.Println("Error Occuered in sendOrders")
	}
	c.Close()
}

//{0 5 1 [{"Id":1,"Name":"pasta","CatTags":["food","drink"],"Price":14.95},{"Id":1,"Name":"pasta","CatTags":["food","drink"],"Price":14.95}]} <nil>

func getCatTags(s string) []string {
	noQuotes := strings.Replace(s, "\"", "", -1)
	splitString := strings.Split(noQuotes, ",")
	return splitString
}

func makeMenuItem(s string) MenuItem {
	// possible adjustments are splitting by " or [ and  ]
	Id := ""
	Name := ""
	index := strings.Index(s, "Id")
	CatTags := []string{}
	Price := ""
	for i := index + 4; i < len(s); i++ {
		if s[i] != ',' {
			Id += string(s[i])
		} else {
			break
		}
	}
	index = strings.Index(s, "Name")
	for i := index + 7; i < len(s); i++ {
		if s[i] != '"' {
			Name += string(s[i])
		} else {
			break
		}
	}
	index = strings.Index(s, "CatTags")
	if s[index+11] != ']' {
		substr := s[strings.Index(s, "[")+1 : strings.Index(s, "]")]
		CatTags = getCatTags(substr)
	}

	index = strings.Index(s, "Price")
	for i := index + 7; i < len(s); i++ {
		if s[i] != '}' {
			Price += string(s[i])
		} else {
			break
		}
	}
	intId, err := strconv.Atoi(Id)
	if err != nil {
		fmt.Println("intn error in MakeMenuItems")
	}
	floatPrice, err := strconv.ParseFloat(Price, 64)
	if err != nil {
		fmt.Println("float error in MakeMenuItems")
	}
	//fmt.Printf("Id: %s, Name: %s, Price, %s, CatTags: %s\n", Id, Name, Price, CatTags)
	return MenuItem{intId, Name, CatTags, floatPrice}
}

func convertStringtoList(s string) []MenuItem {
	var greatestPoint int
	var leastPoint int = strings.Index(s, "Id") - 2
	var substr string = s[leastPoint:]
	var total = []MenuItem{}
	for i := 0; i < len(s); i++ {
		if greatestPoint+1 > len(substr) {
			break
		} else {
			greatestPoint = strings.Index(substr, "}")
			leastPoint = strings.Index(substr, "{")
			total = append(total, makeMenuItem(substr[leastPoint:greatestPoint]))
			substr = substr[greatestPoint+1:]
		}
	}
	return total
}

type RecvOrder struct {
	OrderIDNullChar string
	OrderIDLength   int
	OrderID         int
	OrderItems      string
}

func recvOrder(c net.Conn) {
	d := json.NewDecoder(c)

	var msg RecvOrder
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	//currently does not like orders without menuitems in it, need to fix that at some point
	conv := Order{msg.OrderIDNullChar, msg.OrderIDLength, msg.OrderID, convertStringtoList(msg.OrderItems)}
	fmt.Println(conv)
	c.Close()
}

//func sendMessage(c net.Conn) {
//}

func main() {
	// returned an unsigned int 8 in this case []uint8
	//fmt.Printf("type of encoded json is %T", b)

	formatPort := ":30000"
	l, err := net.Listen("tcp", formatPort)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer l.Close()

	for {
		c, err := l.Accept()
		if err != nil {
			fmt.Println(err)
			return
		}
		handleServerConnection(c)
	}
	//makeMenuItem("{\"Id\":1,\"Name\":\"pasta\",\"CatTags\":[\"food\",\"drink\"],\"Price\":14.95}")
	//v := convertStringtoList("[{\"Id\":1,\"Name\":\"pasta\",\"CatTags\":[\"food\",\"drink\"],\"Price\":14.95},{\"Id\":1,\"Name\":\"pasta\",\"CatTags\":[\"food\",\"drink\"],\"Price\":14.95}]")
	//writeToConnection(c)
	// https://stackoverflow.com/questions/24339660/read-whole-data-with-golang-net-conn-read
	// https://www.digitalocean.com/community/tutorials/how-to-make-an-http-server-in-go

}

/* temp storage for dart code
// this is purely a testing function, all functions shouldb
void recvJson() async {
  Socket socket = await Socket.connect('127.0.0.1', 30000);
  print('connected');
  var output = "";
  socket.add(utf8.encode('GETMENU\n'));
  await for (var data in socket){
    //print(utf8.decode(data));
    output = utf8.decode(data);
  }
  print(output);
  socket.close();
}
*/
