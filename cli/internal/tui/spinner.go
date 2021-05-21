package tui

import (
	"fmt"
	"time"

	"github.com/charmbracelet/lipgloss"
)

var spinnerChars = []string{"\\", "|", "/", "—"}

func SpinnerBlocking(cStop <-chan struct{}) {
	style := lipgloss.NewStyle().
		Foreground(lipgloss.Color("#7d35f2")).
		Width(2)

loop:
	for i := 0; i > -1; i++ {
		select {
		case <-cStop:
			break loop

		default:
			txt := fmt.Sprintf("\r%s Loading...", style.Render(spinnerChars[i%len(spinnerChars)]))
			fmt.Print(txt)
			time.Sleep(100 * time.Millisecond)
		}
	}
}
