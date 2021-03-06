$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "grom"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "grom"
  s.version     = Grom::VERSION
  s.authors     = ["Rebecca Appleyard", "Giuseppe De Santis"]
  s.email       = ["rklappleyard@gmail.com", "giusdesan@gmail.com"]
  s.homepage    = ""
  s.summary     = ""
  s.description = "Grom is a Graph Object Mapper designed for UK Parliament"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "rdf-turtle"

  # the below are test dependencies
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "webmock"
  s.add_development_dependency "simplecov"

  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

end
