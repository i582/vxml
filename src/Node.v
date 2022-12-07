module vxml

// TODO: start_position, end_position, get_by_name
// TODO: get_attribute, get_text
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
