module vxml

pub struct Node {
pub mut:
	attributes map[string]string
	name       string
	text       string
	cdata      string
	children   []&Node
	parent     &Node
}

pub fn (node Node) get_elements_by_tag_name(name string) []&Node {
	mut nodes := []&Node{}
	is_root := node.parent == unsafe { nil }

	if !is_root && node.name == name {
		nodes << &node
	}

	for child in node.children {
		nodes << child.get_elements_by_tag_name(name)
	}

	return nodes
}

pub fn (node Node) get_element_by_tag_name(name string) !&Node {
	if node.name == name {
		return &node
	}

	for child in node.children {
		return child.get_element_by_tag_name(name) or { continue }
	}

	return error('Node not found')
}

pub fn (node Node) get_elements_by_predicate(predicate fn (&Node) bool) []&Node {
	mut nodes := []&Node{}
	is_root := node.parent == unsafe { nil }

	if !is_root && predicate(&node) {
		nodes << &node
	}

	for child in node.children {
		nodes << child.get_elements_by_predicate(predicate)
	}

	return nodes
}

pub fn (node Node) get_attribute(name string) !string {
	if name in node.attributes {
		return node.attributes[name]
	} else {
		return error('Attribute not found')
	}
}

pub fn (node Node) get_text() string {
	return node.text
}

pub fn (node Node) get_cdata() string {
	return node.cdata
}
