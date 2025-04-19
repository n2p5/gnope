package patch

import (
	ct "gno.land/r/n2p5/changetester"
	foo "gno.land/r/n2p5/changetester/lib/foo/v1"
)


func init() {
	ct.UpdateRenderFunc(foo.Render)
}

func Render(_ string) string {
	return "patch 1"
}

// gno.land/r/n2p5/changetester/cm/patch