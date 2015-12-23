package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	data := []int{}
	for _, x := range os.Args[1:] {
		y, err := strconv.Atoi(x)
		if err != nil {
			panic(err)
		}
		data = append(data, y)
	}

	for i, x := range data {
		if x == 0 {
			fmt.Println(i)
			os.Exit(0)
		}
	}
	os.Exit(1)
}
