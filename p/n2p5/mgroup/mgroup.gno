package mgroup

import (
	"std"
	"errors"

	"gno.land/p/demo/avl"
	"gno.land/p/demo/ownable"
)

var (
	ErrCannotRemoveOwner = errors.New("mgroup: cannot remove owner")
	ErrNotBackupOwner = errors.New("mgroup: not a backup owner")
	ErrNotMember = errors.New("mgroup: not a member")
	ErrInvalidAddress = errors.New("mgroup: address is invalid")
)

type ManagedGroup struct {
	owner        *ownable.Ownable
	backupOwners *avl.Tree
	members      *avl.Tree
}

func New(ownerAddress std.Address) *ManagedGroup {
	g := &ManagedGroup{
		owner:   ownable.NewWithAddress(addr),
		backupOwners: avl.NewTree(),
		members: avl.NewTree(),
	}
	g.AddBackupOwner(addr)
	g.AddMember(addr)
	return g
}


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

func (g *ManagedGroup) RemoveBackupOwner(addr std.Address) error {
	if err := g.owner.CallerIsOwner(); err != nil {
		return err
	}
	if !addr.IsValid() {
		return ErrInvalidAddress
	}
	if addr == g.Owner() {
		return Err
	}
	g.backupOwners.Remove(addr.String())
	return nil
}

func (g *ManagedGroup) ClaimOwnership() error {
	caller := std.PrevRealm().Addr()
	// already owner, skip
	if caller == g.Owner() {
		return nil
	}
	if !g.IsBackupOwner(caller){
		return ErrNotMember
	}
	g.owner = ownable.NewWithAddress(caller)
	return nil
}

func (g *ManagedGroup) AddMember(addr std.Address) {
	if err := g.owner.CallerIsOwner(); err != nil {
		return err
	}
	if !addr.IsValid() {
		return ErrInvalidAddress
	}
	g.members.Set(addr.String(), struct{}{})
}

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

func (g *ManagedGroup) IsMember(addr std.Address) bool {
	_, ok := g.members.Get(addr.String())
	return ok
}

func (g *ManagedGroup) IsBackupOwner(addr std.Address) bool {
	_, ok := g.backupOwners.Get(addr.String())
	return ok
}

func (g *ManagedGroup) Owner() std.Address {
	return g.owner.Owner()
}

func (g *ManagedGroup) BackupOwners() []string {
	owners := make([]string, g.backupOwners.Size())
	for i := 0; i < g.backupOwners.Size(); i++ {
		k, _ := g.backupOwners.GetByIndex(i)
		owners[i] = k
	}
	return owners
}

func (g *ManagedGroup) Members() []string {
	members := make([]string, g.members.Size())
	for i := 0; i < g.members.Size(); i++ {
		k, _ := g.members.GetByIndex(i)
		members[i] = k
	}
	return members
}