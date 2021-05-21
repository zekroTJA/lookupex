package tui

import (
	"fmt"
	"strings"
	"time"

	"github.com/charmbracelet/lipgloss"
	"github.com/zekroTJA/lookupex/cli/internal/lookup"
)

var errPrefix = lipgloss.NewStyle().
	Background(lipgloss.Color("#ff0000")).
	Foreground(lipgloss.Color("#ffffff")).
	Render(" ERROR ")

func PrintError(err error) {
	fmt.Printf("%s %s", errPrefix, err.Error())
}

func PrintUser(user *lookup.UserModel) {
	line := func(color, prefix, data string) {
		fmt.Println(
			lipgloss.NewStyle().Foreground(lipgloss.Color(color)).Width(15).Render(prefix),
			data,
		)
	}

	line("#f44336", "Username", user.Username+"#"+user.Discriminator)
	line("#E91E63", "ID", user.Id)
	line("#9C27B0", "Bot", fmt.Sprintf("%t", user.Bot))
	line("#673AB7", "Created", user.Creation.Format(time.RFC1123))
	line("#3F51B5", "Flags", fmt.Sprintf("%d [%s]", user.PublicFlags, strings.Join(user.FlagsAbstracted, ", ")))
	line("#2196F3", "Avatar ID", user.Avatar)
	line("#00BCD4", "Avatar URL", user.AvatarURL)
	line("#4CAF50", "Request Count", fmt.Sprintf("%d", user.RequestCount))
	line("#CDDC39", "Last Fetched", user.Date.Format(time.RFC1123))
}
