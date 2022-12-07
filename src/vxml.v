module vxml

import os

const (
	comment_start = '<!--'
	comment_end   = '-->'
)

pub fn parse_file(path string) !Node {
	content := os.read_file(path)!

	return parse(content)
}

pub fn parse(xml string) Node {
	mut root := Node{
		name: '_root_'
		parent: &Node(0)
	}

	mut state := ParserState{}
	mut current_node := &root

	for symbol in xml.runes() {
		state.word = state.word + symbol.str()

		if symbol == ` ` || !can_be_included(symbol) {
			state.clear_word()
		}

		if state.in_comment {
			if state.word == comment_end {
				state = ParserState{}
			}

			continue
		}

		if state.word == comment_start {
			state = ParserState{
				in_comment: true
			}

			continue
		}

		if state.in_head_tag {
			if symbol == `>` {
				state.in_head_tag = false
				state.in_attribute_key = false
				state.in_attribute_value = false

				tag_name := state.head_tag_string.trim_space()
				last_tag_name_symbol := state.word.trim_space().trim_right('>')

				if tag_name.starts_with('/') {
					current_node.text = unescape_string(state.tag_text).trim_space()

					current_node.parent.childrens << current_node
					current_node = current_node.parent

					state = ParserState{}
				} else if tag_name.ends_with('/') || last_tag_name_symbol.ends_with('/') {
					if state.attribute_key != '' {
						state.save_attribute()
					}

					state.attribute_key = ''
					state.attribute_value = ''

					current_node = &Node{
						attributes: state.tag_attributes
						name: tag_name.trim_right('/')
						parent: current_node
					}

					current_node.parent.childrens << current_node
					current_node = current_node.parent

					state = ParserState{}
				} else if tag_name.starts_with('?') { // NOTE: incomplete test
					if state.attribute_key != '' {
						state.save_attribute()
					}

					state.clear_attribute()
				} else {
					if state.attribute_key != '' {
						state.save_attribute()
					}

					current_node = &Node{
						attributes: state.tag_attributes
						name: tag_name
						parent: current_node
					}

					state.clear_attribute()
				}
			} else {
				if !state.in_string && symbol == ` ` {
					state.in_attribute_key = true
					state.in_attribute_value = false

					if state.attribute_key != '' {
						state.save_attribute()
					}

					state.attribute_key = ''
					state.attribute_value = ''
				} else if state.in_attribute_key || state.in_attribute_value {
					if state.in_attribute_key {
						if symbol == `=` {
							state.in_attribute_key = false
							state.in_attribute_value = true
						} else {
							state.attribute_key = state.attribute_key + symbol.str()
						}
					} else if state.in_attribute_value {
						// TODO: not allow to open with " and finish with '
						if symbol == `"` || symbol == `'` {
							state.in_string = !state.in_string
						} else if state.in_string {
							state.attribute_value = state.attribute_value + symbol.str()
						}
					}
				} else {
					if can_be_included(symbol) {
						state.head_tag_string = state.head_tag_string + symbol.str()
					}
				}
			}
		} else {
			if symbol == `<` {
				state.in_head_tag = true
				state.head_tag_string = ''
			} else {
				state.tag_text = state.tag_text + symbol.str()
			}
		}
	}

	return root
}
