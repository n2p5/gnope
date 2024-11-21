package claims

import (
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ownable"
	"gno.land/p/demo/ownable/exts/authorizable"
	"gno.land/p/demo/ufmt"
	"gno.land/p/n2p5/mgroup"
)

const (
	originalOwner = "g1j39fhg29uehm7twwnhvnpz3ggrm6tprhq65t0t" // n2p5
)

var (
	adminGroup = mgroup.New(originalOwner)
	claims       = avl.NewTree()
)

// AddBackupOwner adds a backup owner to the Owner Group.
// A backup owner can claim ownership of the contract.
func AddBackupOwner(addr std.Address) {
	err := adminGroup.AddBackupOwner(addr)
	if err != nil {
		panic(err)
	}
}

// RemoveBackupOwner removes a backup owner from the Owner Group.
// The primary owner cannot be removed.
func RemoveBackupOwner(addr std.Address) {
	err := adminGroup.RemoveBackupOwner(addr)
	if err != nil {
		panic(err)
	}
}

// ClaimOwnership allows an authorized user in the ownerGroup
// to claim ownership of the contract.
func ClaimOwnership() {
	err := adminGroup.ClaimOwnership()
	if err != nil {
		panic(err)
	}
}

// AddAdmin adds an admin to the Admin Group.
func AddAdmin(addr std.Address) {
	err := adminGroup.AddMember(addr)
	if err != nil {
		panic(err)
	}
}

// RemoveAdmin removes an admin from the Admin Group.
// The primary owner cannot be removed.
func RemoveAdmin(addr std.Address) {
	err := adminGroup.RemoveMember(addr)
	if err != nil {
		panic(err)
	}
}

// CurrentOwner returns the current owner of the claims contract.
func CurrentOwner() std.Address {
	return adminGroup.Owner()
}

func IsAdmin(addr std.Address) bool {
	return adminGroup.IsMember(addr)
}

func getBackupOwners() []string {
	return adminGroup.BackupOwners()
}


func Render(path string) string {

	description := getDescription()
	primaryOwner := adminGroup.Owner().String()
	backupOwners := markDownList(adminGroup.BackupOwners())
	adminMembers := markDownList(adminGroup.Members())

	return ufmt.Sprintf(`
# Claims
%s

## Authorized Users
**primary owner**: %s
primary: %s
%s

**admins**:
%s


`, description, primaryOwner, backupOwners, adminMembers)
}