package mgroup

import (
	"errors"
	"std"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ownable"
)

var (
	ErrCannotRemoveOwner = errors.New("mgroup: cannot remove owner")
	ErrNotBackupOwner    = errors.New("mgroup: not a backup owner")
	ErrNotMember         = errors.New("mgroup: not a member")
	ErrInvalidAddress    = errors.New("mgroup: address is invalid")
)

type ManagedGroup struct {
	owner        *ownable.Ownable
	backupOwners *avl.Tree
	members      *avl.Tree
}

// New creates a new ManagedGroup with the owner set to the provided address.
// The owner is automatically added as a backup owner and member of the group.
func New(ownerAddress std.Address) *ManagedGroup {
	g := &ManagedGroup{
		owner:        ownable.NewWithAddress(ownerAddress),
		backupOwners: avl.NewTree(),
		members:      avl.NewTree(),
	}
	g.AddBackupOwner(ownerAddress)
	g.AddMember(ownerAddress)
	return g
}

// AddBackupOwner adds a backup owner to the group by std.Address.
// If the caller is not the owner, an error is returned.
func (g *ManagedGroup) AddBackupOwner(addr std.Address) error {
	if err := g.owner.CallerIsOwner(); err != nil {
		return err
	}
	if !addr.IsValid() {
		return ErrInvalidAddress
	}
	g.backupOwners.Set(addr.String(), struct{}{})
	return nil
}

// RemoveBackupOwner removes a backup owner from the group by std.Address.
// The owner cannot be removed. If the caller is not the owner, an error is returned.
func (g *ManagedGroup) RemoveBackupOwner(addr std.Address) error {
	if err := g.owner.CallerIsOwner(); err != nil {
		return err
	}
	if !addr.IsValid() {
		return ErrInvalidAddress
	}
	if addr == g.Owner() {
		return ErrCannotRemoveOwner
	}
	g.backupOwners.Remove(addr.String())
	return nil
}

// ClaimOwnership allows a backup owner to claim ownership of the group.
// If the caller is not a backup owner, an error is returned.
// The caller is automatically added as a member of the group.
func (g *ManagedGroup) ClaimOwnership() error {
	caller := std.PrevRealm().Addr()
	// already owner, skip
	if caller == g.Owner() {
		return nil
	}
	if !g.IsBackupOwner(caller) {
		return ErrNotMember
	}
	g.owner = ownable.NewWithAddress(caller)
	g.AddMember(caller)
	return nil
}

// AddMember adds a member to the group by std.Address.
// If the caller is not the owner, an error is returned.
func (g *ManagedGroup) AddMember(addr std.Address) error {
	if err := g.owner.CallerIsOwner(); err != nil {
		return err
	}
	if !addr.IsValid() {
		return ErrInvalidAddress
	}
	g.members.Set(addr.String(), struct{}{})
	return nil
}

// RemoveMember removes a member from the group by std.Address.
// The owner cannot be removed. If the caller is not the owner,
// an error is returned.
func (g *ManagedGroup) RemoveMember(addr std.Address) error {
	if err := g.owner.CallerIsOwner(); err != nil {
		return err
	}
	if !addr.IsValid() {
		return ErrInvalidAddress
	}
	if addr == g.Owner() {
		return ErrCannotRemoveOwner
	}
	g.members.Remove(addr.String())
	return nil
}

// MemberCount returns the number of members in the group.
func (g *ManagedGroup) MemberCount() int {
	return g.members.Size()
}

// BackupOwnerCount returns the number of backup owners in the group.
func (g *ManagedGroup) BackupOwnerCount() int {
	return g.backupOwners.Size()
}

// IsMember checks if an address is a member of the group.
func (g *ManagedGroup) IsMember(addr std.Address) bool {
	return g.members.Has(addr.String())
}

// IsBackupOwner checks if an address is a backup owner in the group.
func (g *ManagedGroup) IsBackupOwner(addr std.Address) bool {
	return g.backupOwners.Has(addr.String())
}

// Owner returns the owner of the group.
func (g *ManagedGroup) Owner() std.Address {
	return g.owner.Owner()
}

// BackupOwners returns a slice of all backup owners in the group.
func (g *ManagedGroup) BackupOwners() []string {
	return g.BackupOwnersWithOffset(0, g.BackupOwnerCount())
}

// Members returns a slice of all members in the group.
func (g *ManagedGroup) Members() []string {
	return g.MembersWithOffset(0, g.MemberCount())
}

func (g *ManagedGroup) BackupOwnersWithOffset(offset, count int) []string {
	return sliceWithOffset(g.backupOwners, offset, count)
}

func (g *ManagedGroup) MembersWithOffset(offset, count int) []string {
	return sliceWithOffset(g.members, offset, count)
}

func sliceWithOffset(t *avl.Tree, offset, count int) []string {
	var result []string
	t.IterateByOffset(offset, count, func(k string, _ interface{}) bool {
		if k == "" {
			return true
		}
		result = append(result, k)
		return false
	})
	return result
}
