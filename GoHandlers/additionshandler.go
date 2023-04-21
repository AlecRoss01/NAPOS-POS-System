package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net"
)

type Addition struct {
	Name         string
	Id           int
	Price        float64
	AdditionType string
}

type Additions struct {
	All []Addition
}

func removeAddition(c net.Conn) {
	d := json.NewDecoder(c)

	var msg Addition
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
	result, err := db.Exec("DELETE FROM additions WHERE id = ?", msg.Id)
	//INSERT INTO orders (orderID, orderIDNullChar, orderIDLength) VALUES (?, ?, ?)"
	if err != nil {
		fmt.Println(fmt.Errorf("markComplete %v", err))
	}
	fmt.Println(result)
}

func getNextIdAddition() int {
	menu, err := getAdditions()
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

func addAddition(c net.Conn) {
	d := json.NewDecoder(c)

	var msg Addition
	err := d.Decode(&msg)
	fmt.Println(msg, err)
	c.Write([]byte("finish"))
	msg.Id = getNextIdAddition()
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
	msg := Additions{additions}
	e := json.NewEncoder(c)
	err = e.Encode(msg)
	if err != nil {
		fmt.Println("Error Occuered in sendEmployees")
	}
	c.Close()
}
