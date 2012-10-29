source 'https://rubygems.org'

gemspec

platforms :jruby do
  # Necessary for `rake release` on JRuby
  gem "jruby-openssl", "~> 0.7.7"
end

group :test do
  # Formats and colorizes test output
  gem "turn", "~> 0.9.6", :require => false
end
