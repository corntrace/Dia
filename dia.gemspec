Gem::Specification.new do |g|
  g.name = 'dia'
  g.version = '1.0'
  g.authors = %w(Robert Gleeson)
  g.email = 'rob@flowof.info'
  g.summary = "Dia allows you to sandbox applications on the OSX platform"
  g.description = "Dia allows you to sandbox applications on the OSX platform"
  
  g.require_paths = [ 'lib' ]
  g.files = Dir["*.md"] + Dir["lib/**/*.rb"]
  g.add_dependency "ffi"

end
