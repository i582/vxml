module vxml

fn test_static_xml() {
	root := parse('<thing abc="test"><test>Hello</test></thing>')

	thing := root.childrens.first()

	assert thing.name == 'thing'
	assert thing.attributes.len == 1
	assert thing.childrens.len == 1

	test := thing.childrens.first()

	assert test.name == 'test'
	assert test.text == 'Hello'
}

fn test_escape() {
	root := parse('<thing abc="Morning &amp; Co.">&lt;Hello&gt;</thing>')

	thing := root.childrens.first()

	assert thing.text == '<Hello>'
	assert thing.attributes['abc'] == 'Morning & Co.'
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
	assert data.childrens[0].name == 'empty-line'
	assert data.childrens[1].name == 'cell'
	assert data.childrens[2].name == 'cell'
	assert data.childrens[3].name == 'empty-line'

	metadata := project.childrens[1]
	assert metadata.name == 'metadata'
	assert metadata.childrens.len == 2
	assert metadata.childrens[0].name == 'text'
	assert metadata.childrens[1].name == 'br'
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
	assert head.childrens[0].name == 'title'
	assert head.childrens[0].text == 'Test'
	assert head.childrens[1].name == 'meta'
	assert head.childrens[1].attributes['charset'] == 'utf-8'

	body := html.childrens[1]
	assert body.name == 'body'
	assert body.childrens.len == 4
	assert body.childrens[0].name == 'h1'
	assert body.childrens[0].text == 'Test'
	assert body.childrens[1].name == 'br'
	assert body.childrens[2].name == 'p'
	assert body.childrens[2].attributes['style'] == 'color: red'
	assert body.childrens[3].name == 'img'
	assert body.childrens[3].attributes['src'] == 'test.png'
}
