package events

import (
	"time"
)

// Speaker represents a session presenter or panelist
type Speaker struct {
	id      string
	address std.Address
	// maybe use profile or maybe just have data here
}

// Session represents a single presentation or panel
type Session struct {
	ID          string
	Title       string
	Description string
	StartTime   time.Time
	EndTime     time.Time
	Speakers    []Speaker
	Room        Room
	Tags        []string
}

// Track represents a themed collection of sessions
type Track struct {
	ID          string
	Name        string
	Description string
	Sessions    []Session
	Tags        []string
}

// Event represents the main event container
type Event struct {
	ID          string
	Name        string
	Description string
	StartDate   time.Time
	EndDate     time.Time
	Locations   []Location
	Tracks      []Track
	Settings    EventSettings
}

// EventSettings holds configurable event parameters
type EventSettings struct {
	DefaultSessionLength time.Duration
	TimeSlotInterval     time.Duration
	Capacity             int
}

// Location represents the event venue
type Location struct {
	Name        string
	Address     string
	TimeZone    string
	Description string
}

// Room represents a specific location where sessions can be held
type Room struct {
	ID          string
	Name        string
	Capacity    int
	Description string
	Location    Location
	isVirtual   bool
}
