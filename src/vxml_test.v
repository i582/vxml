module vxml

fn test_static_xml() {
	root := parse('<thing abc="test"><test>Hello</test></thing>')

	thing := root.children.first()

	assert thing.name == 'thing'
	assert thing.attributes.len == 1
	assert thing.children.len == 1

	test := thing.children.first()

	assert test.name == 'test'
	assert test.get_text() == 'Hello'
}

fn test_escape() {
	root := parse('<thing abc="Morning &amp; Co.">&lt;Hello&gt;</thing>')

	thing := root.children.first()

	assert thing.text == '<Hello>'
	assert thing.get_attribute('abc')! == 'Morning & Co.'
}

fn test_xml_file() {
	root := parse_file('./fixtures/test.xml') or { panic(err) }
	assert root.children.len == 1

	project := root.children.first()
	assert project.name == 'project'
	assert project.children.len == 2

	data := project.children.first()
	assert data.name == 'data'
	assert data.children.len == 4

	empty_line1 := data.children[0]
	assert empty_line1.name == 'empty-line'

	cell1 := data.children[1]
	assert cell1.name == 'cell'

	cell2 := data.children[2]
	assert cell2.name == 'cell'

	empty_line2 := data.children[3]
	assert empty_line2.name == 'empty-line'

	metadata := project.children[1]
	assert metadata.name == 'metadata'
	assert metadata.children.len == 2

	text := metadata.children[0]
	assert text.name == 'text'

	br := metadata.children[1]
	assert br.name == 'br'
}

fn test_html_file() {
	root := parse_file('./fixtures/test.html') or { panic(err) }
	assert root.children.len == 1

	html := root.children.first()
	assert html.name == 'html'
	assert html.children.len == 2

	head := html.children.first()
	assert head.name == 'head'
	assert head.children.len == 2

	title := head.children[0]
	assert title.name == 'title'
	assert title.get_text() == 'Test'

	meta := head.children[1]
	assert meta.name == 'meta'
	assert meta.get_attribute('charset')! == 'utf-8'

	body := html.children[1]
	assert body.name == 'body'
	assert body.children.len == 5

	h1 := body.children[0]
	assert h1.name == 'h1'
	assert h1.get_text() == 'Test'
	assert h1.get_cdata().trim_space() == '< > &'

	br := body.children[1]
	assert br.name == 'br'
	assert br.get_text() == ''

	p := body.children[2]
	assert p.name == 'p'
	assert p.get_attribute('style')! == 'color: red'
	assert p.get_cdata().trim_space() == 'test'

	image := body.children[3]
	assert image.name == 'img'
	assert image.get_attribute('src')! == 'test.png'

	script := body.children[4]
	assert script.name == 'script'
	assert script.get_text().trim_space() == 'alert(true);'
}

fn test_get_elements_by_tag_name() {
	root := parse_file('./fixtures/tags.html') or { panic(err) }

	nodes := root.get_elements_by_tag_name('input')

	assert nodes.len == 3

	username := nodes[0]
	assert username.get_attribute('name')! == 'username'
	assert username.get_attribute('type')! == 'text'

	password := nodes[1]
	assert password.get_attribute('name')! == 'password'
	assert password.get_attribute('type')! == 'password'

	post := nodes[2]
	assert post.get_attribute('name')! == 'post'
	assert post.get_attribute('type')! == 'text'

	button := root.get_element_by_tag_name('button')!
	assert button.get_text() == 'Log in'

	div := root.get_element_by_tag_name('div')!
	assert div.name == 'div'
	assert div.children.len == 1
}

fn test_get_elements_by_predicate() {
	root := parse_file('./fixtures/tags.html') or { panic(err) }

	nodes := root.get_elements_by_predicate(fn (node &Node) bool {
		return node.name == 'input' || node.name == 'button'
	})

	assert nodes.len == 4
}

fn test_get_all_elements() {
	root := parse_file('./fixtures/tags.html') or { panic(err) }

	nodes := root.get_elements_by_predicate(fn (node &Node) bool {
		return true
	})

	assert nodes.len == 9
}
