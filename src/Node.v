module vxml

// Node is a struct that represents a node in the DOM tree.
pub struct Node {
pub mut:
	attributes map[string]string
	name       string
	text       string
	cdata      string
	children   []&Node
	parent     &Node
}

// is_root returns true if the node has no parent node and false otherwise.
[inline]
pub fn (node Node) is_root() bool {
	return node.parent == unsafe { nil }
}

// get_elements_by_tag_name returns all the elements with the given tag name.
//
// Example:
// ```
// xml := vxml.parse('
// <project>
//   <text>Hello World!</text>
//   <empty-line/>
//   <text>Hello V!</text>
// </project>
// ')
// text_nodes := xml.get_elements_by_tag_name('text')
// assert text_nodes.len == 2
// assert text_nodes[0].text == 'Hello World!'
// assert text_nodes[1].text == 'Hello V!'
// ```
pub fn (node Node) get_elements_by_tag_name(name string) []&Node {
	mut nodes := []&Node{}

	if !node.is_root() && node.name == name {
		nodes << &node
	}

	for child in node.children {
		nodes << child.get_elements_by_tag_name(name)
	}

	return nodes
}

// get_element_by_tag_name returns the first element with the given tag name.
//
// Example:
// ```
// xml := vxml.parse('
// <project>
//   <text>Hello World!</text>
//   <empty-line/>
//   <text>Hello V!</text>
// </project>
// ')
// text_node := xml.get_element_by_tag_name('text') or { panic(err) }
// assert text_node.text == 'Hello World!'
// ```
pub fn (node Node) get_element_by_tag_name(name string) !&Node {
	if node.name == name {
		return &node
	}

	for child in node.children {
		return child.get_element_by_tag_name(name) or { continue }
	}

	return error('Node not found')
}

// get_elements_by_predicate returns all the elements that match the given predicate.
//
// Example:
// ```
// xml := vxml.parse('
// <project>
//   <text>Hello World!</text>
//   <empty-line/>
//   <text type="greeting">Hello V!</text>
// </project>
// ')
// elem := xml.get_elements_by_predicate(fn (node &vxml.Node) bool {
// 	return node.attributes['type'] == 'greeting'
// })
// assert elem[0].text == 'Hello V!'
// assert elem[0].attributes['type'] == 'greeting'
// ```
pub fn (node Node) get_elements_by_predicate(predicate fn (&Node) bool) []&Node {
	mut nodes := []&Node{}

	if !node.is_root() && predicate(&node) {
		nodes << &node
	}

	for child in node.children {
		nodes << child.get_elements_by_predicate(predicate)
	}

	return nodes
}

// get_attribute returns the value of the attribute with the given name.
//
// Example:
// ```
// xml := vxml.parse('
// <project>
//   <text type="greeting">Hello V!</text>
// </project>
// ')
// text_node := xml.get_element_by_tag_name('text') or { panic(err) }
// assert text_node.get_attribute('type') == 'greeting'
// ```
pub fn (node Node) get_attribute(name string) !string {
	if name in node.attributes {
		return node.attributes[name]
	} else {
		return error('Attribute not found')
	}
}

// get_text returns the text of the node.
pub fn (node Node) get_text() string {
	return node.text
}

// get_cdata returns the cdata of the node.
pub fn (node Node) get_cdata() string {
	return node.cdata
}
