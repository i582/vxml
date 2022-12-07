module vxml

struct Node {
pub mut:
	attributes map[string]string
	name       string
	text       string
	cdata      string
	childrens  []&Node
	parent     &Node
}

pub fn (node Node) get_elements_by_tag_name(name string) []&Node {
	mut nodes := []&Node{}
	is_root := node.parent == unsafe { nil }

	if !is_root && (name == '*' || node.name == name) {
		nodes << &node
	}

	for child in node.childrens {
		nodes << child.get_elements_by_tag_name(name)
	}

	return nodes
}

pub fn (node Node) get_element_by_tag_name(name string) !&Node {
	if node.name == name {
		return &node
	}

	for child in node.childrens {
		found_node := child.get_element_by_tag_name(name) or { continue }

		return found_node
	}

	return error('Node not found')
}

pub fn (node Node) get_elements_by_predicate(predicate fn (&Node) bool) []&Node {
	mut nodes := node.get_elements_by_tag_name('*')
	mut found_nodes := []&Node{}

	for item in nodes {
		if predicate(item) {
			found_nodes << item
		}
	}

	return found_nodes
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
