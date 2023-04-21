package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net"
)

type Employee struct {
	Name   string
	ID     int
	PIN    int
	Access int
}

type Pin struct {
	PIN int
}

type Employees struct {
	Employees []Employee
}

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
		return nil, fmt.Errorf("getEmployees %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		var employee Employee
		if err := rows.Scan(&employee.Name, &employee.ID, &employee.PIN, &employee.Access); err != nil {
			return nil, fmt.Errorf("getEmployees %v", err)
		}
		employees = append(employees, employee)
	}
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("getEmployees %v", err)
	}
	return employees, nil
}

func getEmployeeByID(id int) (Employee, error) {
	db, err := initDb(connString, "ca-certificate.crt")
	if err != nil {
		log.Fatal(err)
	}

	pingErr := db.Ping()
	if pingErr != nil {
		log.Fatal(pingErr)
	}

	fmt.Println("Connected!")
	var employee Employee
	rows, err := db.Query("SELECT * FROM employees WHERE id= ?", id)
	if err != nil {
		fmt.Printf("getEmployeeById %v", err)
	}

	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&employee.Name, &employee.ID, &employee.PIN, &employee.Access); err != nil {
			fmt.Printf("getEmployeeById %v", err)
		}
	}
	if err := rows.Err(); err != nil {
		fmt.Printf("getEmployeeById %v", err)
	}
	return employee, nil
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
