package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net"
	"strconv"
	"time"
)

type RecvOrder struct {
	OrderIDNullChar string
	OrderIDLength   int
	OrderID         int
	OrderItems      string
	OrderTaker      string
	DateTime        int
}

type OrderItem struct {
	OrderID     int
	OrderItemID int
}

type HistOrder struct {
	Orders []Order
}

type Order struct {
	OrderIDNullChar string
	OrderIDLength   int
	OrderID         int
	OrderItems      []MenuItem
	OrderTaker      Employee
	DateTime        int
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
		var complete int
		var takerId int
		if err := rows.Scan(&order.OrderID, &order.OrderIDNullChar, &order.OrderIDLength, &complete, &takerId, &order.DateTime); err != nil {
			return nil, fmt.Errorf("getOrders %v", err)
		}
		orders = append(orders, order)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getOrders %v", err)
	}
	return orders, nil
}

func getEmployeeForOrder(id int, emp []Employee) Employee {
	for _, element := range emp {
		if element.ID == id {
			return element
		}
	}
	return Employee{}
}

func boolGetOrdersGetMenuHelper(id int, menu []MenuItem) MenuItem {
	for _, item := range menu {
		if item.Id == id {
			return item
		}
	}
	return MenuItem{}
}

// "SELECT * FROM menu WHERE id = ?"
func BoolGetOrders(orderType bool) ([]Order, error) {
	//returns a list containing all of the orders
	var orderState = 0
	if orderType {
		orderState = 1
	}
	//var employees, _ = getEmployees()
	//var menu, _ = getMenu()
	var orders []Order
	rows, err := db.Query("SELECT * FROM orders WHERE complete = ?", orderState)
	if err != nil {
		return nil, fmt.Errorf("getOrders %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var order Order
		var empId int
		var holder int
		if err := rows.Scan(&order.OrderID, &order.OrderIDNullChar, &order.OrderIDLength, &holder, &empId, &order.DateTime); err != nil {
			return nil, fmt.Errorf("getOrders %v", err)
		}
		//order.OrderTaker = getEmployeeForOrder(empId, employees)
		order.OrderTaker, err = getEmployeeByID(empId)
		//fmt.Println(order)
		orders = append(orders, order)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getOrders %v", err)
	}

	items, err := getOrderItems()
	time.Sleep(2 * time.Second)
	for i := 0; i < len(orders); i++ {
		for y := 0; y < len(items); y++ {
			if orders[i].OrderID == items[y].OrderID {
				item, err := getMenuItem(strconv.Itoa(items[y].OrderItemID), db)
				if err != nil {
					log.Fatal(err)
				}
				//item := boolGetOrdersGetMenuHelper(items[y].OrderItemID, menu)
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
	result, err := db.Exec("INSERT INTO orders (orderID, orderIDNullChar, orderIDLength, complete, orderTakerId, dateTime) VALUES (?, ?, ?, 0, ?, ?)", order.OrderID, order.OrderIDNullChar, order.OrderIDLength, order.OrderTaker.ID, order.DateTime)
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

func recvOrder(c net.Conn) {
	d := json.NewDecoder(c)

	var msg RecvOrder
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	var emp Employee
	err = json.Unmarshal([]byte(msg.OrderTaker), &emp)
	if err != nil {
		fmt.Printf("%x", err)
	}
	var newId = getNewOrderId()
	//currently does not like orders without menuitems in it, need to fix that at some point
	conv := Order{msg.OrderIDNullChar, msg.OrderIDLength, newId, convertStringtoList(msg.OrderItems), emp, msg.DateTime}
	dbHandlerEntries(conv)
	c.Close()
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

func getNewOrderId() int {
	db, err := initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}
	orders, _ := getOrders()
	fmt.Println("Connected!")
	var highest = 0
	for _, item := range orders {
		if item.OrderID > highest {
			highest = item.OrderID
		}
	}
	return highest + 1

}
