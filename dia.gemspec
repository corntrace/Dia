require File.join(File.dirname(__FILE__), 'lib', 'dia')
Gem::Specification.new do |g|
  g.name = 'dia'
  g.version = Dia::VERSION
  g.authors = ['Robert Gleeson']
  g.email = 'rob@flowof.info'
  g.summary = "Dia allows you to sandbox application(s) or block(s) of ruby on the OSX platform by restricting access to operating system resources"
  g.description = "Dia allows you to sandbox application(s) or block(s) of ruby on the OSX platform by restricting access to operating system resources"
  g.has_rdoc = 'yard'
    
  g.require_paths = [ 'lib' ]
  g.files = Dir["*.md"] + Dir["lib/**/*.rb"] + [ '.yardopts']
  g.test_files = Dir["test/**/*.rb"]
  g.add_dependency "ffi", "= 0.6.2"
  g.add_development_dependency "baretest", ">= 0.2.4"
  g.post_install_message = <<-DOC
  ********************************************************************
  Dia (#{Dia::VERSION})
  
  The Mac OSX 10.5 bug has been reported as fixed! 
  Many thanks to "Josh Creek" for reporting, and helping me debug the
  problem until we solved it.
  ********************************************************************
  DOC
end
