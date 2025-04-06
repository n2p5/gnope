package events

import (
	"time"
)

type EventReader interface {
	ID() string
	Name() string
	Status() string
	Description() string
	StartDate() time.Time
	EndDate() time.Time
	Locations() []Location
	Tracks() []Tracks
	GetTicket() *Ticket
}

type Ticket struct {
	// TBD
}

type Status uint

const ()

type EventManger interface {
	Update()
	IssueTicket(addr string) (*Ticket, error)
	UpdateStatus() error
	Cancel(reason string) error
}

type option func(e *Event)

func New(options ...option) *Event {

}

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

type OnlineEvent struct {
	id          string
	name        string
	description string
	startDate   time.Time
	endDate     time.Time
	metadata    map[string]string
}

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
