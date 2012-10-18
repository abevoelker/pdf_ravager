require 'rspec'
require 'rake/testtask'
require 'bundler'

Rake::TestTask.new do |t|
  t.libs << ["lib", "spec"]
  t.pattern = "spec/*_spec.rb" 
end 

Bundler::GemHelper.install_tasks