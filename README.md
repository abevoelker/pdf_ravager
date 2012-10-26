# PDF Ravager [![Build Status](https://secure.travis-ci.org/abevoelker/pdf_ravager.png)](http://travis-ci.org/abevoelker/pdf_ravager)

Provides a simple DSL for easily filling out AcroForms PDF or XFA documents.

## Description

This library uses a combination of a simple DSL and a minimal façade over the
last free version of the iText library to aid in filling out AcroForms PDF or
XFA documents.

## Synopsis

```ruby
require 'pdf_ravager'

data = {:name => 'Bob', :gender => 'm', :relation => 'Uncle' }

info = pdf do
  text 'name', data[:name]
  rich_text 'name_stylized', "<b>#{data[:name]}</b>" # warning: text is not HTML-escaped!
  radio_group 'sex' do
    fill 'male'   if data[:gender] == 'm'
    fill 'female' if data[:gender] == 'f'
  end
  check 'related' if data[:relation]
  checkbox_group 'relation' do
    check 'parent'  if ['Mom', 'Dad'].include?(data[:relation])
    check 'sibling' if ['Brother', 'Sister'].include?(data[:relation])
    check 'other'   unless ['Brother', 'Sister', 'Mom', 'Dad'].include?(data[:relation])
    # OR
    case data[:relation]
    when 'Mom', 'Dad'
      check 'parent'
    when 'Brother', 'Sister'
      check 'sibling'
    else
      check 'other'
    end
  end
end

info.ravage '/tmp/info.pdf', :out_file => '/tmp/info_filled.pdf'
```

## Usage

### Field Names
To query and modify a form's field names, use a tool such as Adobe
LiveCycle.

### Rich Text
The `rich_text` type is specific to XFA forms. To understand how it
should be used, see the "Rich Text Reference" section of
[Adobe's XFA standard][1]. Rich Text is defined there as a subset of
XHTML and CSS which uses some custom restrictions and extensions by
Adobe. The minimum XHTML and CSS elements that a standards-compliant
XFA processor (e.g. Adobe Reader) must support are also listed there
and can be used as a guide.

### Checkbox Groups
Because there is no such thing as a "checkbox group," the
`checkbox_group` syntax is simply syntactic sugar for calling
`check` with the group name and a `.` prepended to the name. For
example,

```ruby
checkbox_group 'relation' do
  check 'parent'
end
```

is equivalent to

```ruby
check 'relation.parent'
```

## Copyright

Copyright (c) 2012 Abe Voelker. Released under the terms of the
MIT license. See LICENSE for details.

[1]: http://partners.adobe.com/public/developer/xml/index_arch.html