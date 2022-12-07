module vxml

struct Node {
pub mut:
	attributes map[string]string
	name       string
	text       string
	childrens  []&Node
	parent     &Node
}

pub fn (node Node) str() string {
	return 'Node{name=${node.name}, text=${node.text}, childrens=${node.childrens}, attributes=${node.attributes}}'
}

pub fn (node Node) get_elements_by_tag_name(name string) []&Node {
	mut nodes := []&Node{}

	if node.name == name {
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
