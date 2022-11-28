package main

import (
	"bufio"
	"fmt"
	"net"
	"strings"
)

//var db *sql.DB

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

//func queryOrders() ([]Order, error) {
//var orders []Order
//rows, err := db.Query()
//}

func tcpHandler(portNum string) {
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
			//itemArray := [3]string{"pizza", "pasta", "fish"}
			itemArray := "pizza pasta fish"
			//for i := 0; i < len(itemArray); i++ {
			//c.Write([]byte(itemArray[i] + " "))
			c.Write([]byte(itemArray))
			//}
			c.Close()
		} else if strings.TrimSpace(string(netData)) == "GETORDERS" {
			//itemArray := [3]string{"pasta", "fish", "pizza"}
			itemArray := "pasta fish pizza"
			//for i := 0; i < len(itemArray); i++ {
			//c.Write([]byte(itemArray[i] + " "))
			c.Write([]byte(itemArray))
			//}
			c.Close()
		} else if strings.TrimSpace(string(netData)) == "SENDORDER" {
			netData, err := bufio.NewReader(c).ReadString('\n')
			if err != nil {
				fmt.Print("error: ")
				fmt.Println(err)
			}
			order := strings.TrimSpace(string(netData))
			print(order)
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
