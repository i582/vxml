# vxml

Pure V library for parsing XML. The data is accessed with a tree API accessible directly within the `Node` struct.

## This library is now alive.

## Install.

```sh
v install walkingdevel.vxml
```

## Usage.

```v
fn parse(xml string) Node
fn parse_file(path string) !Node
fn (node Node) str() string
fn (node Node) get_elements_by_tag_name(name string) []&Node
fn (node Node) get_element_by_tag_name(name string) !&Node
fn (node Node) get_attribute(name string) !string
fn (node Node) get_text() string
```

## Example.

```v
import vxml { parse_file }

fn main() {
  news := parse_file('./news.xml') or { panic(err) }

  posts := news.get_elements_by_tag_name('post')

  println(posts.first().get_text())
}
```

It doesn't support (yet):
- CDATA sections
- Error handling
- Schemas (DTD)

The features listed above will all be supported soon.
