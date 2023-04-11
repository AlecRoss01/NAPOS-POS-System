package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
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

type UniqueCats struct {
	Categories []string
}

type Employee struct {
	Name   string
	ID     int
	PIN    int
	Access int
}

type Employees struct {
	Employees []Employee
}

type Addition struct {
	Name         string
	Id           int
	Price        float64
	AdditionType string
}

type Additions struct {
	All []Addition
}

// https://go.dev/doc/tutorial/database-access

//[]MenuItem

// should let me connect to Digitalocean server, seems to be using the mysql driver package I am
// https://whatibroke.com/2021/11/30/golang-and-mysql-digitalocean-managed-cluster/

// initDb creates initialises the connection to mysql

func dbHandlerMenu() []MenuItem {
	// Capture connection properties.
	// https://stackoverflow.com/questions/70757210/how-do-i-connect-to-a-mysql-instance-without-using-the-password
	// need to reconsider this at some point
	// Get a database handle.
	var err error
	db, err = initDb(connString, "ca-certificate.crt")
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

func dbHandlerCategories() []Categories {
	// Capture connection properties.
	// https://stackoverflow.com/questions/70757210/how-do-i-connect-to-a-mysql-instance-without-using-the-password
	// need to reconsider this at some point
	// Get a database handle.
	var err error
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}
	fmt.Println("Connected!")
	cats, err := getCategories()
	return cats
}

func dbHandlerOrders(orderType bool) []Order {
	// Capture connection properties.
	// https://stackoverflow.com/questions/70757210/how-do-i-connect-to-a-mysql-instance-without-using-the-password
	// need to reconsider this at some point
	// Get a database handle.
	var err error
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	orders, err := BoolGetOrders(orderType)
	return orders
}

func dbHandlerEntries(entry Order) {
	// Capture connection properties.
	// https://stackoverflow.com/questions/70757210/how-do-i-connect-to-a-mysql-instance-without-using-the-password
	// need to reconsider this at some point
	// Get a database handle.
	var err error
	db, err = initDb(connString, "ca-certificate.crt")
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

// deprecated, will be removed at some point
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

// "SELECT * FROM menu WHERE id = ?"
func BoolGetOrders(orderType bool) ([]Order, error) {
	//returns a list containing all of the orders
	var orderState = 0
	if orderType {
		orderState = 1
	}
	var orders []Order
	rows, err := db.Query("SELECT * FROM orders WHERE complete = ?", orderState)
	if err != nil {
		return nil, fmt.Errorf("getOrders %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var order Order
		var holder int
		if err := rows.Scan(&order.OrderID, &order.OrderIDNullChar, &order.OrderIDLength, &holder); err != nil {
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
	fmt.Println(orders)
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

func sendOrders(orderType bool, c net.Conn) {
	msg := dbHandlerOrders(orderType)
	orders := HistOrder{msg}
	//part above is where I would get the data from the database
	e := json.NewEncoder(c)
	err := e.Encode(orders)
	if err != nil {
		fmt.Println("Error Occuered in sendOrders2")
	}
	c.Close()
}

func contains(arr []string, obj string) bool {
	if len(arr) == 0 {
		return false
	}
	for i := 0; i < len(arr); i++ {
		if arr[i] == obj {
			return true
		}
	}
	return false
}

func sendCategories(c net.Conn) {
	msg := dbHandlerCategories()
	var cats []string
	for i := 0; i < len(msg); i++ {
		if !contains(cats, msg[i].CatTag) {
			cats = append(cats, msg[i].CatTag)
		}
	}
	categories := UniqueCats{cats}
	e := json.NewEncoder(c)
	err := e.Encode(categories)
	if err != nil {
		fmt.Println("Error Occuered in sendCategories")
	}
	c.Close()
}

func getCatTags(s string) []string {
	noQuotes := strings.Replace(s, "\"", "", -1)
	noBrackets1 := strings.Replace(noQuotes, "[", "", -1)
	noBrackets2 := strings.Replace(noBrackets1, "]", "", -1)
	splitString := strings.Split(noBrackets2, ",")
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

// {0 5 1 [{"Id":1,"Name":"pasta","CatTags":["food","drink"],"Price":14.95},{"Id":1,"Name":"pasta","CatTags":["food","drink"],"Price":14.95}]} <nil>
// [{"Id":1,"Name":"pizza","CatTags":["Food","All"],"Price":13.95}]
// "Id":1,"Name":"pizza","CatTags":["Food","All"],"Price":13.95
// below doesn't have proper syntax cuz missing "" but is general idea
// [Id, 1, Name, Pizza, CatTags, [Food, All], Price, 13.95]
func convergeItems(s []string) MenuItem {
	fmt.Println(s[0])
	intId, err := strconv.Atoi(s[0])
	if err != nil {
		fmt.Println("int error in convergeItems")
	}
	fmt.Println(s[3])
	floatPrice, err := strconv.ParseFloat(s[3], 64)
	if err != nil {
		fmt.Println("float error in convergeItems")
	}
	return MenuItem{intId, s[1], getCatTags(s[2]), floatPrice}
}

func makeMenuItem1(s string) MenuItem {
	var data []string
	index := strings.Index(s, "Id")
	subtr := s[index-1 : len(s)-2]
	itemList := strings.Split(subtr, ":")
	fmt.Println("itemList")
	fmt.Println(itemList)
	for i := 0; i < len(itemList); i++ {
		if i%2 == 1 {
			data = append(data, itemList[i+1])
		}
	}
	return convergeItems(itemList)
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
	fmt.Println(msg.OrderItems)
	//currently does not like orders without menuitems in it, need to fix that at some point
	conv := Order{msg.OrderIDNullChar, msg.OrderIDLength, msg.OrderID, convertStringtoList(msg.OrderItems)}
	fmt.Println(conv)
	//dbHandlerEntries(conv)
	c.Close()
}

func recvMenuItem(c net.Conn) {
	d := json.NewDecoder(c)

	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Close()
}

type Pin struct {
	PIN int
}

// no garuntees this works, mostly just thrown together
func checkPIN(c net.Conn) (int64, error) {
	d := json.NewDecoder(c)
	var msg Pin
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	e := json.NewEncoder(c)
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}
	fmt.Println("Connected!")
	rows, err := db.Query("SELECT * FROM employees WHERE PIN = ?", msg.PIN)
	if err != nil {
		return 0, fmt.Errorf("checkPIN %q: %v", msg.PIN, err)
	}
	defer rows.Close()
	for rows.Next() {
		var check Employee
		if err := rows.Scan(&check.Name, &check.ID, &check.PIN, &check.Access); err != nil {
			return 0, fmt.Errorf("checkPIN %q: %v", msg.PIN, err)
		}
		if check.PIN == msg.PIN {
			fmt.Println(check)
			e.Encode(Pin{check.PIN})
			return 1, nil
		}
	}
	if err := rows.Err(); err != nil {
		e := json.NewEncoder(c)
		e.Encode(Pin{-1})
		return 0, fmt.Errorf("queryMenu %q: %v", msg.PIN, err)
	}
	c.Close()
	return 0, nil
}

func markComplete(c net.Conn) {
	//adds and order to the database
	d := json.NewDecoder(c)

	var msg RecvOrder
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	fmt.Println(msg.OrderItems)
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}
	fmt.Println("Connected!")
	result, err := db.Exec("UPDATE orders SET complete = '1' WHERE orderID = ?", msg.OrderID)
	if err != nil {
		fmt.Println(fmt.Errorf("markComplete %v", err))
	}
	fmt.Println(result)
}

func addItemToMenu(c net.Conn) {
	d := json.NewDecoder(c)

	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	fmt.Println(msg)
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	result, err := db.Exec("INSERT INTO menu (id, name, Price) VALUES (?, ?, ?)", msg.Id, msg.Name, msg.Price)
	addCatTagsToMenu(msg, db)
	//INSERT INTO orders (orderID, orderIDNullChar, orderIDLength) VALUES (?, ?, ?)"
	// need to eventually add catTags as well
	if err != nil {
		fmt.Println(fmt.Errorf("additemToMenu %v", err))
	}
	fmt.Println(result)
}

func addCatTagsToMenu(item MenuItem, db *sql.DB) {
	for _, tag := range item.CatTags {
		result, err := db.Exec("INSERT INTO categories (MenuID, CatTag) VALUES (?, ?)", item.Id, tag)
		if err != nil {
			fmt.Println(fmt.Errorf("addCatTagsToMenu %v", err))
		}
		fmt.Println(result)
	}
}

func removeCatTagsFromMenu(item MenuItem, db *sql.DB) {
	result, err := db.Exec("DELETE FROM categories WHERE MenuID = ?", item.Id)
	if err != nil {
		fmt.Println(fmt.Errorf("addCatTagsToMenu %v", err))
	}
	fmt.Println(result)
}

func removeItemFromMenu(c net.Conn) {
	d := json.NewDecoder(c)
	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	fmt.Println(msg)
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	result, err := db.Exec("DELETE FROM menu WHERE id = ?", msg.Id)
	removeCatTagsFromMenu(msg, db)
	//INSERT INTO orders (orderID, orderIDNullChar, orderIDLength) VALUES (?, ?, ?)"
	if err != nil {
		fmt.Println(fmt.Errorf("markComplete %v", err))
	}
	fmt.Println(result)
}

func removeAddition(c net.Conn) {
	d := json.NewDecoder(c)

	var msg Addition
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	fmt.Println(msg)
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	result, err := db.Exec("DELETE FROM additions WHERE id = ?", msg.Id)
	//INSERT INTO orders (orderID, orderIDNullChar, orderIDLength) VALUES (?, ?, ?)"
	if err != nil {
		fmt.Println(fmt.Errorf("markComplete %v", err))
	}
	fmt.Println(result)
}

func addAddition(c net.Conn) {
	d := json.NewDecoder(c)

	var msg Addition
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	fmt.Println(msg)
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	result, err := db.Exec("INSERT INTO additions (id, name, price, type) VALUES (?, ?, ?, ?)", msg.Id, msg.Name, msg.Price, msg.AdditionType)
	//INSERT INTO orders (orderID, orderIDNullChar, orderIDLength) VALUES (?, ?, ?)"
	if err != nil {
		fmt.Println(fmt.Errorf("markComplete %v", err))
	}
	fmt.Println(result)
}

func getEmployees() ([]Employee, error) {
	db, err := initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	var employees []Employee
	rows, err := db.Query("SELECT * FROM employees")
	if err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var employee Employee
		if err := rows.Scan(&employee.Name, &employee.ID, &employee.PIN, &employee.Access); err != nil {
			return nil, fmt.Errorf("getMenu %v", err)
		}
		employees = append(employees, employee)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}
	return employees, nil

}

func sendEmployees(c net.Conn) {
	employees, err := getEmployees()
	msg := Employees{employees}
	e := json.NewEncoder(c)
	err = e.Encode(msg)
	if err != nil {
		fmt.Println("Error Occuered in sendEmployees")
	}
	c.Close()
}

func getAdditions() ([]Addition, error) {
	db, err := initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	var additions []Addition
	rows, err := db.Query("SELECT * FROM additions")
	if err != nil {
		return nil, fmt.Errorf("getAdditions %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var addition Addition
		if err := rows.Scan(&addition.Id, &addition.Name, &addition.Price, &addition.AdditionType); err != nil {
			return nil, fmt.Errorf("getAdditions %v", err)
		}
		additions = append(additions, addition)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getAdditions %v", err)
	}
	return additions, nil
}

func sendAdditions(c net.Conn) {
	additions, err := getAdditions()
	fmt.Println(additions)
	msg := Additions{additions}
	e := json.NewEncoder(c)
	err = e.Encode(msg)
	if err != nil {
		fmt.Println("Error Occuered in sendEmployees")
	}
	c.Close()
}

func containsCatTag(cat Categories, cats []Categories) int {
	for index, tag := range cats {
		if tag == cat {
			return index
		}
	}
	return -1
}

func getCatTagsById(m MenuItem) []Categories {
	cats, _ := getCategories()
	var idCats []Categories
	for _, tag := range cats {
		if tag.MenuID == m.Id {
			idCats = append(idCats, tag)
		}
	}
	return idCats
}

func updateCatTags(c net.Conn) {
	d := json.NewDecoder(c)

	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	fmt.Println(msg)

	db, err := initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	result, err := db.Exec("DELETE FROM categories WHERE MenuID=?", msg.Id)
	if err != nil {
		fmt.Printf("UpdateCatTags %v, %v\n", err, result)
	}
	addCatTagsToMenu(msg, db)
}

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
		go sendMenu(c)
	case "SENDMENU":
		go recvMenuItem(c)
	case "ORDERS":
		go sendOrders(true, c)
	case "SENDORDER":
		go recvOrder(c)
	case "CATEGORIES":
		go sendCategories(c)
	case "PINCHECK":
		go checkPIN(c)
	case "GETCOMPLETEORDERS":
		go sendOrders(false, c)
	case "GETINCOMPLETEORDERS":
		go sendOrders(true, c)
	case "MARKCOMPLETE":
		go markComplete(c)
	case "ADDMENITEM":
		go addItemToMenu(c)
	case "REMOVEMENITEM":
		go removeItemFromMenu(c)
	case "ADDADDITION":
		go addAddition(c)
	case "REMOVEADDITION":
		go removeAddition(c)
	case "GETEMPLOYEES":
		go sendEmployees(c)
	case "GETADDITIONS":
		go sendAdditions(c)
	case "UPDATECATTAGS":
		go updateCatTags(c)
	default:
		fmt.Printf("reached default in request type, request was: %s", requestType)
	}
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
