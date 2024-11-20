package claims

import (
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ownable"
	"gno.land/p/demo/ownable/exts/authorizable"
	"gno.land/p/demo/ufmt"
)

const (
	originalOwner = "g1j39fhg29uehm7twwnhvnpz3ggrm6tprhq65t0t" // n2p5
)

var (
	ownerGroup   = authorizable.NewAuthorizableWithAddress(originalOwner)
	adminGroup   = authorizable.NewAuthorizableWithAddress(originalOwner)
	ownerTracker = newMemberTrackeWithAddress(originalOwner)
	adminTracker = newMemberTrackeWithAddress(originalOwner)
	claims       = avl.NewTree()
)

type memberTracker struct {
	members *avl.Tree
}

func newMemberTrackeWithAddress(addr std.Address) *memberTracker {
	mt := &memberTracker{
		members: avl.NewTree(),
	}
	mt.addMember(addr)
	return mt
}

func (mt *memberTracker) addMember(addr std.Address) {
	mt.members.Set(addr.String(), struct{}{})
}

func (mt *memberTracker) removeMember(addr std.Address) {
	mt.members.Remove(addr.String())
}

func (mt *memberTracker) toList() []string {
	members := make([]string, mt.members.Size())
	for i := 0; i < mt.members.Size(); i++ {
		k, _ := mt.members.GetByIndex(i)
		members[i] = k
	}
	return members
}

func AddBackupOwner(addr std.Address) {
	ownerGroup.AssertCallerIsOwner()
	ownerGroup.AddToAuthList(addr)
	ownerTracker.addMember(addr)
}

func RemoveBackupOwner(addr std.Address) {
	ownerGroup.AssertCallerIsOwner()
	if addr == ownerGroup.Owner() {
		panic("cannot remove owner")
	}
	ownerGroup.DeleteFromAuthList(addr)
	ownerTracker.removeMember(addr)
}

func ClaimOwnership() {
	ownerGroup.AssertOnAuthList()
	caller := std.PrevRealm().Addr()
	ownerGroup.Ownable = ownable.NewWithAddress(caller)
	adminGroup.Ownable = ownable.NewWithAddress(caller)
}

func AddAdmin(addr std.Address) {
	ownerGroup.AssertCallerIsOwner()
	adminGroup.AddToAuthList(addr)
	adminTracker.addMember(addr)
}

func RemoveAdmin(addr std.Address) {
	ownerGroup.AssertCallerIsOwner()
	if addr == ownerGroup.Owner() {
		panic("cannot remove owner")
	}
	adminGroup.DeleteFromAuthList(addr)
	adminTracker.removeMember(addr)
}

func Render(path string) string {

	description := getDescription()
	ownerMembers := markDownList(ownerTracker.toList())
	adminMembers := markDownList(adminTracker.toList())

	return ufmt.Sprintf(`
# Claims

%s

## Authorized Users
**owners**:
%s

**admins**:
%s


`, description, ownerMembers, adminMembers)
}

func getDescription() string {
	value, exists := claims.Get("description")
	if !exists {
		return "Welcome to my claims page. "
	}
	return value.(string)
}

func markDownList(items []string) string {
	var result string
	for _, item := range items {
		result += "- " + item + "\n"
	}
	return result
}
