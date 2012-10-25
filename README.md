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
  html 'name_stylized', "<b>#{data[:name]}</b>" # warning: HTML is not escaped
  radio_group 'sex' do
    fill 'male',   :if => data[:gender] == 'm'
    fill 'female', :if => data[:gender] == 'f'
  end
  check 'related' if data[:relation]
  checkbox_group 'relation' do
    check 'parent',  :if => ['Mom', 'Dad'].include?(data[:relation])
    check 'sibling', :if => ['Brother', 'Sister'].include?(data[:relation])
    check 'other',   :unless => ['Brother', 'Sister', 'Mom', 'Dad'].include?(data[:relation])
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

To find the names of the fields, use a tool such as Adobe LiveCycle. The
`html` type is a subset of XHTML defined by [Adobe's XFA standard][1] - full
HTML support isn't available.

## Copyright

Copyright (c) 2012 Abe Voelker. Released under the terms of the
MIT license. See LICENSE for details.

[1]: http://partners.adobe.com/public/developer/xml/index_arch.html