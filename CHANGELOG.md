## 0.2.2 (2014-08-21)

Features:

  - Make AcroForms strategy smarter by attempting full SOM path match

## 0.2.1 (2014-04-02)

Bugfixes:

  - Fix rich text field type not setting values properly
  - Fix `:smart` strategy not applying read-only properly

## 0.2.0 (2014-03-31)

Features:

  - Deprecate global `pdf` convenience method
  - Deprecate name option to `PDFRavager::Template.new`
  - Move PDF population methods into strategies
  - Speed up PDF population by default (i.e. `:smart` strategy) by avoiding XFA
    population when possible
