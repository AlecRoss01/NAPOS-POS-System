package main

import (
	"bufio"
	"database/sql"
	"fmt"
	"log"
	"net"
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
	menuID   int64
	itemName string
}

type Order struct {
	ID   int64
	item string
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
	/*
		menuitems, err := queryMenu("pasta")
		if err != nil {
			log.Fatal(err)
		}
		fmt.Printf("found items: %v\n", menuitems)
	*/
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

func dbHandlerEntries(entry string) {
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

//need to update to past 1.18 version of go in order to use generics
//func getTotalData[ A MenuItem | Order] A {

// }

/*type Dataholders interface {
	Order | MenuItem
}

func getDatabase[D Dataholders](pass D) []D {

}*/

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
		if err := rows.Scan(&menu.menuID, &menu.itemName); err != nil {
			return nil, fmt.Errorf("getMenu %v", err)
		}
		menuitems = append(menuitems, menu)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}

	return menuitems, nil
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
		if err := rows.Scan(&order.ID, &order.item); err != nil {
			return nil, fmt.Errorf("getOrders %v", err)
		}
		orders = append(orders, order)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getOrders %v", err)
	}

	return orders, nil
}

func insertOrder(name string) (int64, error) {
	//adds and order to the database
	result, err := db.Exec("INSERT INTO orders (ID, item) VALUES (?, ?)", 0, name)
	if err != nil {
		return 0, fmt.Errorf("insertOrder %v", err)
	}
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
		if err := rows.Scan(&menu.menuID, &menu.itemName); err != nil {
			return nil, fmt.Errorf("queryMenu %q: %v", name, err)
		}
		menuitems = append(menuitems, menu)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("queryMenu %q: %v", name, err)
	}
	return menuitems, nil
}

func tcpHandler(portNum string) {
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
				itemArray = append(itemArray, menu[i].itemName)
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
}

func main() {
	//dbHandlerEntries("spaghetti")
	// using port 30000 to stay away from commonly used/registered ports
	tcpHandler("30000")

}
