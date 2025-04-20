package patch

import (
	ct "gno.land/r/n2p5/changetester"
	foo "gno.land/r/n2p5/changetester/lib/foo/v2"
)


func init() {
	ct.UpdateRenderFunc(foo.Render)
}

func Render(_ path) string {
	return "patch 2"
}