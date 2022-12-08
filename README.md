# vxml

[![Project status](https://img.shields.io/github/release/walkingdevel/vxml.svg)](https://github.com/walkingdevel/vxml/releases/latest)
[![Test](https://github.com/i582/vxml/actions/workflows/ci.yml/badge.svg)](https://github.com/i582/vxml/actions/workflows/ci.yml)
[![V modules reference](https://img.shields.io/badge/modules-reference-027d9c?logo=v&logoColor=white&logoWidth=10)](#TODO)
[![MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/walkingdevel/vxml/master/LICENSE)

Pure V library for parsing XML. The data is accessed with a tree API accessible directly within the `Node` struct.

## Install

```sh
v install walkingdevel.vxml
```

## Example

```v
import walkingdevel.vxml { parse_file }

fn main() {
  news := parse_file('./news.xml') or { panic(err) }

  posts := news.get_elements_by_tag_name('post')

  println(posts.first().get_text())
}
```

## API

```v
fn parse(xml string) Node
fn parse_file(path string) !Node

struct Node {
pub mut:
        attributes map[string]string
        name       string
        text       string
        cdata      string
        children   []&Node
        parent     &Node
}

fn (node Node) is_root() bool
fn (node Node) get_elements_by_tag_name(name string) []&Node
fn (node Node) get_element_by_tag_name(name string) !&Node
fn (node Node) get_elements_by_predicate(predicate fn (&Node) bool) []&Node
fn (node Node) get_attribute(name string) !string
fn (node Node) get_text() string
fn (node Node) get_cdata() string
```

## Roadmap

- Error handling
- Schemas (DTD)

## License

This project is under the **MIT License**. See the 
[LICENSE](https://github.com/walkingdevel/vxml/blob/master/LICENSE) 
file for the full license text.
