package main

import (
	"encoding/json"
	"fmt"
	"net"
)

type Request struct {
	RequestType string
}

// https://go.dev/doc/tutorial/database-access

//[]MenuItem

// should let me connect to Digitalocean server, seems to be using the mysql driver package I am
// https://whatibroke.com/2021/11/30/golang-and-mysql-digitalocean-managed-cluster/

// initDb creates initialises the connection to mysql

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
	// using port 30000 to stay away from commonly used/registered ports
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
