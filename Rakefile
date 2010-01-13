require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "domain_redirect"
    gem.summary = %Q{Redirects to the desired domain.}
    gem.description = %Q{Rack::DomainRedirect is a tiny rack middleware for redirecting to the desired
domain. If user request's the service from domain other than configured it
redirects to the first domain on the configuration list.}
    gem.email = "misza222@gmail.com"
    gem.homepage = "http://github.com/misza222/domain_redirect"
    gem.authors = ["Michal Pawlowski"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_development_dependency "rack-test", ">= 0"
    gem.add_dependency "rack", ">= 1.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "domain_redirect #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
