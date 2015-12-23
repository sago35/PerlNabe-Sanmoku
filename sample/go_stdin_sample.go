package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)

	data := []int{}
	for scanner.Scan() {
		for _, x := range strings.Split(scanner.Text(), " ") {
			y, err := strconv.Atoi(x)
			if err != nil {
				panic(err)
			}
			data = append(data, y)
		}
	}

	for i, x := range data {
		if x == 0 {
			fmt.Println(i)
			os.Exit(0)
		}
	}
	os.Exit(1)
}
