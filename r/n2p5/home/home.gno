package home

import (
	"strings"
	"gno.land/p/n2p5/chonk"
)

var (
	active = chonk.New()
	preview = chonk.New()
)

func Add(chunk string) {
	preview.Add(chunk)
}

func Flush() {
	preview.Flush()
}

func Promote() {
	active = preview
	preview = chonk.New()
}

// TODO: Add Auth to Promote, Flush, and Add

func Render(path string) string {
	var result string
	scanner := getScanner(path)
	for scanner.Scan() {
		result += scanner.Text()
	}
	return result
}

func getScanner(path string) *chonk.Scanner {
	if isPreview(path) {
		return preview.Scanner()
	}
	return active.Scanner()
}

func isPreview(path string) bool {
	return strings.HasPrefix(path, "preview")
}