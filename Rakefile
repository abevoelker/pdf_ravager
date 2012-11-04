require 'rspec'
require 'rspec/core/rake_task'
require 'rake/testtask'
require 'bundler'

Rake::TestTask.new('spec:unit') do |t|
  t.libs << ["lib", "spec"]
  t.pattern = "spec/**/*_spec.rb"
end

if RUBY_PLATFORM =~ /java/
  # Integration tests can only run on JRuby
  RSpec::Core::RakeTask.new('spec:integration') do |spec|
    spec.pattern = "spec/**/*spec.rb"
    spec.rspec_opts = ['--backtrace']
  end

  task :spec => ['spec:unit', 'spec:integration']
else
  task :spec => ['spec:unit']
end

task :default => :spec

Bundler::GemHelper.install_tasks
