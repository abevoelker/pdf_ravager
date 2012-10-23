# -*- encoding: utf-8 -*-
require File.expand_path("../lib/pdf_ravager/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pdf_ravager"
  s.version     = PDFRavager::VERSION
  s.platform    = 'java'
  s.authors     = ['Abe Voelker']
  s.email       = 'abe@abevoelker.com'
  s.date        = '2012-10-17'
  s.homepage    = 'https://github.com/abevoelker/pdf_ravager'
  s.summary     = %q{DSL to aid filling out AcroForms PDF and XFA documents}
  s.description = %q{DSL to aid filling out AcroForms PDF and XFA documents}

  s.add_dependency "json"
  s.add_dependency "nokogiri"
  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
