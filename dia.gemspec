require File.join(File.dirname(__FILE__), 'lib', 'dia')
Gem::Specification.new do |g|
  g.name = 'dia'
  g.version = Dia::VERSION
  g.authors = ['Robert Gleeson']
  g.email = 'rob@flowof.info'
  g.summary = "Dia allows you to sandbox applications and/or a block of ruby on the OSX platform"
  g.description = "Dia allows you to sandbox applications and/or a block of ruby on the OSX platform"
  
  g.require_paths = [ 'lib' ]
  g.files = Dir["*.md"] + Dir["lib/**/*.rb"]
  g.add_dependency "ffi", "= 0.5.4"
  g.add_development_dependency "baretest", ">= 0.2.4"
end
