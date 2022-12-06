module vxml

// TODO: map
struct Attribute {
pub mut:
	name  string
	value string
}

// TODO: start_position, end_position, get_by_name
// TODO: get_attribute, get_text
struct Node {
pub mut:
	attributes []Attribute
	name       string
	text       string
	childrens  []&Node
	parent     &Node
}

pub fn (attribute Attribute) str() string {
	return 'Attribute{name=${attribute.name}, value=${attribute.value}}'
}

pub fn (node Node) str() string {
	return 'Node{name=${node.name}, text=${node.text}, childrens=${node.childrens}, attributes=${node.attributes}}'
}
