module vxml

fn can_be_included(symbol rune) bool {
	return symbol != `\n` && symbol != `\t` && symbol != `\r`
}

fn unescape_string(value string) string {
	return value.replace('&lt;', '<')
		.replace('&gt;', '>')
		.replace('&amp;', '&')
		.replace('&apos;', "'")
		.replace('&quot;', '"')
}
