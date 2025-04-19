package changetester

import (
	"std"
	"strings"
)


var renderFunc func(string) string

func init() {
	renderFunc = func(_ string) string {


		return "changetester original"
	}
}

func UpdateRenderFunc(fn func(string) string) {
	currentRealm := std.CurrentRealm()
	prevRealm := std.PreviousRealm()
	if !strings.HasPrefix(prevRealm.PkgPath(), currentRealm.PkgPath()+"/patch") {
		panic("UpdateRenderFunc must be called from child realm")
	} 
	renderFunc = fn
}

func Render(path string) string {
	return renderFunc(path)
}