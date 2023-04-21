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

func getMenuItem(id string, db *sql.DB) ([]MenuItem, error) {
	var items []MenuItem
	rows, err := db.Query("SELECT * FROM menu WHERE id = ?", id)
	if err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var item MenuItem
		var add int
		if err := rows.Scan(&item.Id, &item.Name, &item.Price, &add); err != nil {
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
		var add int
		if err := rows.Scan(&menu.Id, &menu.Name, &menu.Price, &add); err != nil {
			return nil, fmt.Errorf("getMenu %v", err)
		}
		if add == 1 {
			menuitems = append(menuitems, menu)
		}
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
		fmt.Println("Error Occuered in sendMenu")
	}
	c.Close()
}

func convergeItems(s []string) MenuItem {
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

func recvMenuItem(c net.Conn) {
	d := json.NewDecoder(c)

	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Close()
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

func getNextIdMenu(db *sql.DB) int {
	menu, err := getTotalMenu(db)
	if err != nil {
		fmt.Println("error in getNextIdmNeu")
	}
	var highest = 0
	for _, item := range menu {
		if item.Id > highest {
			highest = item.Id
		}
	}
	return highest + 1
}

func getTotalMenu(db *sql.DB) ([]MenuItem, error) {
	//returns a list containing all of the menu items
	var menuitems []MenuItem
	rows, err := db.Query("SELECT * FROM menu")
	if err != nil {
		return nil, fmt.Errorf("getMenu %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var menu MenuItem
		var add int
		if err := rows.Scan(&menu.Id, &menu.Name, &menu.Price, &add); err != nil {
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

// current, need to deprecate recvMenu at some point
func addItemToMenu(c net.Conn) {
	d := json.NewDecoder(c)

	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))

	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	msg.Id = getNextIdMenu(db)
	result, err := db.Exec("INSERT INTO menu (id, name, Price) VALUES (?, ?, ?)", msg.Id, msg.Name, msg.Price)
	addCatTagsToMenu(msg, db)
	//INSERT INTO orders (orderID, orderIDNullChar, orderIDLength) VALUES (?, ?, ?)"
	// need to eventually add catTags as well
	if err != nil {
		fmt.Println(fmt.Errorf("additemToMenu %v", err))
	}
	fmt.Println(result)
}

func removeItemFromMenu(c net.Conn) {
	d := json.NewDecoder(c)
	var msg MenuItem
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	db, err = initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	result, err := db.Exec("UPDATE menu SET onMenu = 0 WHERE id = ?", msg.Id)
	removeCatTagsFromMenu(msg, db)
	//INSERT INTO orders (orderID, orderIDNullChar, orderIDLength) VALUES (?, ?, ?)"
	if err != nil {
		fmt.Println(fmt.Errorf("markComplete %v", err))
	}
	fmt.Println(result)
}
