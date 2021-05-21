package main

import (
	"errors"
	"flag"
	"fmt"
	"regexp"

	"github.com/zekroTJA/lookupex/cli/internal/lookup"
	"github.com/zekroTJA/lookupex/cli/internal/tui"
)

const defEndpoint = "https://lookup.api.zekro.de"

var (
	fEndpoint = flag.String("endpoint", defEndpoint, "The lookup API endpoint to be used")

	rxUID = regexp.MustCompile("^\\d{12,20}$")
)

func fetchUser(id string) (user *lookup.UserModel, err error) {
	if !rxUID.MatchString(id) {
		err = errors.New("invalid snowflake id")
		return
	}
	return lookup.NewClient(*fEndpoint).GetID(id)
}

func main() {
	flag.Parse()

	if len(flag.Args()) == 0 {
		tui.PrintError(errors.New("id must be passed as argument"))
		return
	}

	cStop := make(chan struct{}, 1)

	go func() {
		user, err := fetchUser(flag.Args()[0])
		cStop <- struct{}{}
		fmt.Print("\r")
		if err != nil {
			tui.PrintError(err)
		} else {
			tui.PrintUser(user)
		}
	}()

	tui.SpinnerBlocking(cStop)
}
