# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pdf_ravager/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "pdf_ravager"
  s.version     = PDFRavager::VERSION
  s.authors     = ['Abe Voelker']
  s.email       = 'abe@abevoelker.com'
  s.homepage    = 'https://github.com/abevoelker/pdf_ravager'
  s.summary     = %q{JRuby-only DSL for filling out AcroForms PDF and XFA documents}
  s.description = %q{JRuby-only DSL for filling out AcroForms PDF and XFA documents}
  s.license     = 'MIT'

  s.add_dependency "nokogiri"
  s.add_development_dependency "bundler",    "~> 1.0"
  s.add_development_dependency "rspec",      "~> 2.11"
  s.add_development_dependency "rake",       "~> 0.9"
  s.add_development_dependency "chunky_png", "~> 1.2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = ['test','spec','features'].map{|d| `git ls-files -- #{d}/*`.split("\n")}.flatten
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
