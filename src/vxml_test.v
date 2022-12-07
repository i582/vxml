module vxml

fn test_static_xml() {
	root := parse('<thing abc="test"><test>Hello</test></thing>')

	thing := root.childrens.first()

	assert thing.name == 'thing'
	assert thing.attributes.len == 1
	assert thing.childrens.len == 1

	test := thing.childrens.first()

	assert test.name == 'test'
	assert test.get_text() == 'Hello'
}

fn test_escape() {
	root := parse('<thing abc="Morning &amp; Co.">&lt;Hello&gt;</thing>')

	thing := root.childrens.first()

	assert thing.text == '<Hello>'
	assert thing.get_attribute('abc')! == 'Morning & Co.'
}

fn test_xml_file() {
	root := parse_file('./fixtures/test.xml') or { panic(err) }
	assert root.childrens.len == 1

	project := root.childrens.first()
	assert project.name == 'project'
	assert project.childrens.len == 2

	data := project.childrens.first()
	assert data.name == 'data'
	assert data.childrens.len == 4

	empty_line1 := data.childrens[0]
	assert empty_line1.name == 'empty-line'

	cell1 := data.childrens[1]
	assert cell1.name == 'cell'

	cell2 := data.childrens[2]
	assert cell2.name == 'cell'

	empty_line2 := data.childrens[3]
	assert empty_line2.name == 'empty-line'

	metadata := project.childrens[1]
	assert metadata.name == 'metadata'
	assert metadata.childrens.len == 2

	text := metadata.childrens[0]
	assert text.name == 'text'

	br := metadata.childrens[1]
	assert br.name == 'br'
}

fn test_html_file() {
	root := parse_file('./fixtures/test.html') or { panic(err) }
	assert root.childrens.len == 1

	html := root.childrens.first()
	assert html.name == 'html'
	assert html.childrens.len == 2

	head := html.childrens.first()
	assert head.name == 'head'
	assert head.childrens.len == 2

	title := head.childrens[0]
	assert title.name == 'title'
	assert title.get_text() == 'Test'

	meta := head.childrens[1]
	assert meta.name == 'meta'
	assert meta.get_attribute('charset')! == 'utf-8'

	body := html.childrens[1]
	assert body.name == 'body'
	assert body.childrens.len == 5

	h1 := body.childrens[0]
	assert h1.name == 'h1'
	assert h1.get_text() == 'Test'

	br := body.childrens[1]
	assert br.name == 'br'
	assert br.get_text() == ''

	p := body.childrens[2]
	assert p.name == 'p'
	assert p.get_attribute('style')! == 'color: red'

	image := body.childrens[3]
	assert image.name == 'img'
	assert image.get_attribute('src')! == 'test.png'

	script := body.childrens[4]
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
	assert div.childrens.len == 1
}
