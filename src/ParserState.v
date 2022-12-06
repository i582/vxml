module vxml

struct ParserState {
mut:
	in_head_tag      bool
	in_attribute_key bool
	in_attribute_val bool
	attribute_key    string
	attribute_val    string
	in_string        bool
	head_tag_string  string
	tag_text         string
	in_comment       bool
	word             string
	tag_attributes   []Attribute
}

fn (mut state ParserState) clear_text() {
	state.tag_text = ''
}

fn (mut state ParserState) clear_word() {
	state.word = ''
}

fn (mut state ParserState) push_attribute() {
	state.tag_attributes << Attribute{state.attribute_key, unescape_string(state.attribute_val)}
}
