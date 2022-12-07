module vxml

struct ParserState {
mut:
	in_head_tag        bool
	in_attribute_key   bool
	in_attribute_value bool
	attribute_key      string
	attribute_value    string
	in_string          bool
	head_tag_string    string
	tag_text           string
	in_comment         bool
	word               string
	tag_attributes     map[string]string
}

fn (mut state ParserState) clear_text() {
	state.tag_text = ''
}

fn (mut state ParserState) clear_word() {
	state.word = ''
}

fn (mut state ParserState) clear_attribute() {
	state.attribute_key = ''
	state.attribute_value = ''
	state.tag_attributes = {}
}

fn (mut state ParserState) save_attribute() {
	state.tag_attributes[state.attribute_key] = unescape_string(state.attribute_value)
}
