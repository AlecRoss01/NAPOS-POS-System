package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"strings"
)

type Categories struct {
	MenuID int
	CatTag string
}

type UniqueCats struct {
	Categories []string
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

func getCatTags(s string) []string {
	noQuotes := strings.Replace(s, "\"", "", -1)
	noBrackets1 := strings.Replace(noQuotes, "[", "", -1)
	noBrackets2 := strings.Replace(noBrackets1, "]", "", -1)
	splitString := strings.Split(noBrackets2, ",")
	return splitString
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

func getCategories() ([]Categories, error) {
	var items []Categories
	rows, err := db.Query("SELECT * FROM categories")
	if err != nil {
		return nil, fmt.Errorf("getCategories %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var item Categories
		if err := rows.Scan(&item.MenuID, &item.CatTag); err != nil {
			return nil, fmt.Errorf("getCategories %v", err)
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getCategories %v", err)
	}
	return items, nil
}
