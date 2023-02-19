package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"strconv"
	"strings"

	"github.com/go-sql-driver/mysql"
)

var db *sql.DB

var cfg = mysql.Config{
	User:                 "root",
	Passwd:               "EvilDuck666!!",
	Net:                  "tcp",
	Addr:                 "127.0.0.1:3306",
	DBName:               "naposdatabase",
	AllowNativePasswords: true,
}

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

type RecvOrder struct {
	OrderIDNullChar string
	OrderIDLength   int
	OrderID         int
	OrderItems      string
}

type OrderItem struct {
	OrderID     int
	OrderItemID int
}

type Categories struct {
	MenuID int
	CatTag string
}

// https://go.dev/doc/tutorial/database-access

//[]MenuItem

func dbHandlerMenu() []MenuItem {
	// Capture connection properties.
	// https://stackoverflow.com/questions/70757210/how-do-i-connect-to-a-mysql-instance-without-using-the-password
	// need to reconsider this at some point
	// Get a database handle.
	var err error
	db, err = sql.Open("mysql", cfg.FormatDSN())
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}
	fmt.Println("Connected!")
	menu, err := getMenu()
	return menu
}

func dbHandlerOrders() []Order {
	// Capture connection properties.
	// https://stackoverflow.com/questions/70757210/how-do-i-connect-to-a-mysql-instance-without-using-the-password
	// need to reconsider this at some point
	// Get a database handle.
	var err error
	db, err = sql.Open("mysql", cfg.FormatDSN())
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	orders, err := getOrders()
	return orders
}

func dbHandlerEntries(entry Order) {
	// Capture connection properties.
	// https://stackoverflow.com/questions/70757210/how-do-i-connect-to-a-mysql-instance-without-using-the-password
	// need to reconsider this at some point
	// Get a database handle.
	var err error
	db, err = sql.Open("mysql", cfg.FormatDSN())
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}
	fmt.Println("Connected!")
	insertOrder(entry)
}

// need to find a way to make a "getTable()" function
// need to find a way to have a generic return type
// if able to do so, can use methods to simplify code https://go.dev/tour/methods/1
func validDatabase(search string) bool {
	databases := [2]string{"menu", "orders"}
	for _, element := range databases {
		if search == element {
			return true
		}
	}
	return false
}
func getCategories() ([]Categories, error) {
	var items []Categories
	rows, err := db.Query("SELECT * FROM categories")
	if err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var item Categories
		if err := rows.Scan(&item.MenuID, &item.CatTag); err != nil {
			return nil, fmt.Errorf("getMenu %v", err)
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}
	return items, nil
}

func getMenuItem(id string) ([]MenuItem, error) {
	var items []MenuItem
	rows, err := db.Query("SELECT * FROM menu WHERE id = ?", id)
	if err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var item MenuItem
		if err := rows.Scan(&item.Id, &item.Name, &item.Price); err != nil {
			return nil, fmt.Errorf("getMenu %v", err)
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}
	cats, err := getCategories()
	for i := 0; i < len(items); i++ {
		for y := 0; y < len(cats); y++ {
			if items[i].Id == cats[y].MenuID {
				items[i].CatTags = append(items[i].CatTags, cats[y].CatTag)
			}
		}
	}
	return items, nil
}

func getMenu() ([]MenuItem, error) {
	//returns a list containing all of the menu items
	var menuitems []MenuItem
	rows, err := db.Query("SELECT * FROM menu")
	if err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var menu MenuItem
		if err := rows.Scan(&menu.Id, &menu.Name, &menu.Price); err != nil {
			return nil, fmt.Errorf("getMenu %v", err)
		}
		menuitems = append(menuitems, menu)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}
	cats, err := getCategories()
	for i := 0; i < len(menuitems); i++ {
		for y := 0; y < len(cats); y++ {
			if menuitems[i].Id == cats[y].MenuID {
				menuitems[i].CatTags = append(menuitems[i].CatTags, cats[y].CatTag)
			}
		}
	}

	return menuitems, nil
}

func getOrderItems() ([]OrderItem, error) {
	var items []OrderItem
	rows, err := db.Query("SELECT * FROM orderitems")
	if err != nil {
		return nil, fmt.Errorf("getOrderItems %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var item OrderItem
		if err := rows.Scan(&item.OrderID, &item.OrderItemID); err != nil {
			return nil, fmt.Errorf("getOrderItems %v", err)
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getOrderItems %v", err)
	}
	return items, nil
}

func getOrders() ([]Order, error) {
	//returns a list containing all of the orders
	var orders []Order
	rows, err := db.Query("SELECT * FROM orders")
	if err != nil {
		return nil, fmt.Errorf("getOrders %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var order Order
		if err := rows.Scan(&order.OrderID, &order.OrderIDNullChar, &order.OrderIDLength); err != nil {
			return nil, fmt.Errorf("getOrders %v", err)
		}
		orders = append(orders, order)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getOrders %v", err)
	}
	items, err := getOrderItems()
	for i := 0; i < len(orders); i++ {
		for y := 0; y < len(items); y++ {
			if orders[i].OrderID == items[y].OrderID {
				item, err := getMenuItem(strconv.Itoa(items[y].OrderItemID))
				if err != nil {
					log.Fatal(err)
				}
				orders[i].OrderItems = append(orders[i].OrderItems, item[0])
			}
		}
	}

	return orders, nil
}

func insertOrderItems(order Order) (int64, error) {
	items := order.OrderItems
	var id int64
	for i := 0; i < len(items); i++ {
		result, err := db.Exec("INSERT INTO orderitems (OrderID, OrderItemID) VALUES (?, ?)", order.OrderID, items[i].Id)
		if err != nil {
			return 0, fmt.Errorf("insertOrder %v", err)
		}
		id, err = result.LastInsertId()
		if err != nil {
			return 0, fmt.Errorf("insertOrder %v", err)
		}
	}
	return id, nil

}

func insertOrder(order Order) (int64, error) {
	//adds and order to the database
	result, err := db.Exec("INSERT INTO orders (orderID, orderIDNullChar, orderIDLength) VALUES (?, ?, ?)", order.OrderID, order.OrderIDNullChar, order.OrderIDLength)
	if err != nil {
		return 0, fmt.Errorf("insertOrder %v", err)
	}
	insertOrderItems(order)
	id, err := result.LastInsertId()
	if err != nil {
		return 0, fmt.Errorf("insertOrder %v", err)
	}
	return id, nil
}

func queryMenu(name string) ([]MenuItem, error) {
	// general function, queries the menu table for a specific name, and will return a list of those items
	var menuitems []MenuItem
	// turn this into function at some point, need query functions
	rows, err := db.Query("SELECT * FROM menu WHERE name = ?", name)
	if err != nil {
		return nil, fmt.Errorf("queryMenu %q: %v", name, err)
	}
	defer rows.Close()
	for rows.Next() {
		var menu MenuItem
		if err := rows.Scan(&menu.Id, &menu.Name); err != nil {
			return nil, fmt.Errorf("queryMenu %q: %v", name, err)
		}
		menuitems = append(menuitems, menu)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("queryMenu %q: %v", name, err)
	}
	return menuitems, nil
}

/*func tcpHandler(portNum string) {
	//handles networking, need to probably break this up a bit
	formatPort := ":" + portNum
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

		netData, err := bufio.NewReader(c).ReadString('\n')
		if err != nil {
			fmt.Print("error: ")
			fmt.Println(err)
			return
		}
		if strings.TrimSpace(string(netData)) == "STOP" {
			fmt.Println("Exiting TCP server!")
			return
		} else if strings.TrimSpace(string(netData)) == "GETMENU" {
			menu := dbHandlerMenu()
			var itemArray []string
			for i := 0; i < len(menu); i++ {
				itemArray = append(itemArray, menu[i].Name)
			}
			totalItemArray := strings.Join(itemArray, " ")
			c.Write([]byte(totalItemArray))
			//for i := 0; i < len(itemArray); i++ {
			//c.Write([]byte(itemArray[i] + " "))
			//}
			c.Close()
		} else if strings.TrimSpace(string(netData)) == "GETORDERS" {
			orders := dbHandlerOrders()
			var itemArray []string
			for i := 0; i < len(orders); i++ {
				itemArray = append(itemArray, orders[i].item)
			}
			totalItemArray := strings.Join(itemArray, " ")
			c.Write([]byte(totalItemArray))
			//for i := 0; i < len(itemArray); i++ {
			//c.Write([]byte(itemArray[i] + " "))
			//}
			c.Close()
		} else if strings.TrimSpace(string(netData)) == "SENDORDER" {
			netData, err := bufio.NewReader(c).ReadString('\n')
			if err != nil {
				fmt.Print("error: ")
				fmt.Println(err)
				return
			}
			order := strings.TrimSpace(string(netData))
			print(order)
			dbHandlerEntries(order)
			c.Write([]byte("finish"))
			c.Close()
		}
		c.Close()
		//fmt.Print("-> ", string(netData))
		//t := time.Now()
		//myTime := t.Format(time.RFC3339) + "\n"
		//c.Write([]byte(myTime))
	}
}*/

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

func sendMenu(c net.Conn) {
	msg := dbHandlerMenu()
	menu := Menu{msg}
	//part above is where I would get the menu from the database
	e := json.NewEncoder(c)
	err := e.Encode(menu)
	if err != nil {
		fmt.Println("Error Occuered in sendMenu2")
	}
	c.Close()
}

func sendOrders(c net.Conn) {
	msg := dbHandlerOrders()
	orders := HistOrder{msg}
	//part above is where I would get the data from the database
	e := json.NewEncoder(c)
	err := e.Encode(orders)
	if err != nil {
		fmt.Println("Error Occuered in sendOrders2")
	}
	c.Close()
}

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

func recvOrder(c net.Conn) {
	d := json.NewDecoder(c)

	var msg RecvOrder
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	//currently does not like orders without menuitems in it, need to fix that at some point
	conv := Order{msg.OrderIDNullChar, msg.OrderIDLength, msg.OrderID, convertStringtoList(msg.OrderItems)}
	dbHandlerEntries(conv)
	c.Close()
}

func recvMenuItem(c net.Conn) {
	d := json.NewDecoder(c)

	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Close()
}

func main() {
	//dbHandlerEntries("spaghetti")
	// using port 30000 to stay away from commonly used/registered ports
	//tcpHandler("30000")
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

}
