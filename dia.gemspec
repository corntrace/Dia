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
  g.add_dependency "ffi", "= 0.6.2"
  g.add_development_dependency "baretest", ">= 0.2.4"
  g.post_install_message = <<-DOC
  ********************************************************************
  Dia (#{Dia::VERSION})
  
  There is a known bug on Mac OSX 10.5 which renders Dia unusable for
  Mac OSX 10.5 users .. We're working on a fix, and hope to have one
  for the 1.4 final release
  ********************************************************************
  DOC
end
