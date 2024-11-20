package chonk 

// Chonk is a simple string buffer for fine bois.
type Chonk struct {
	first  *chunk
	last   *chunk
}

// chunk is a linked list node for Chonk
type chunk struct {
	text  string
	next  *chunk
}

// New creates a new Chonk
func New() *Chonk {
	return &Chonk{}
}

// Add appends a string to the Chonk
func (c *Chonk) Add(text string) {
	next := &chunk{text: text}
	if c.first == nil {
		c.first = next
		c.last = next
		return
	}
	c.last.next = next
	c.last = next
}

// Flush clears the Chonk
func (c *Chonk) Flush() {
	c.first = nil
	c.last = nil
}

// Scanner returns a new Scanner for the Chonk
func (c *Chonk) Scanner() *Scanner {
	return &Scanner{
		next: c.first,
	}
}

// Scanner is a simple string scanner for Chonk
type Scanner struct {
	current *chunk
	next *chunk
}

// Scan advances the scanner to the next chunk
func (s *Scanner) Scan() bool {
	if s.next != nil {
		s.current = s.next
		s.next = s.next.next
		return true
	}
	return false
}

// Text returns the current chunk
func (s *Scanner) Text() string {
	return s.current.text
}