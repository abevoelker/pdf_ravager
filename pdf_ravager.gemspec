# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pdf_ravager/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "pdf_ravager"
  s.version     = PDFRavager::VERSION
  s.authors     = ['Abe Voelker']
  s.email       = 'abe@abevoelker.com'
  s.homepage    = 'https://github.com/abevoelker/pdf_ravager'
  s.summary     = %q{DSL to aid filling out AcroForms PDF and XFA documents}
  s.description = %q{DSL to aid filling out AcroForms PDF and XFA documents}

  s.add_dependency "json"
  s.add_dependency "nokogiri"
  s.add_development_dependency "bundler",    "~> 1.0"
  s.add_development_dependency "minitest",   "~> 4.1"
  s.add_development_dependency "rspec",      "~> 2.11"
  s.add_development_dependency "rake",       "~> 0.9"
  s.add_development_dependency "chunky_png", "~> 1.2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
