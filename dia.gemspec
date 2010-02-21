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
  g.add_dependency "ffi", "= 0.5.4"
  g.add_development_dependency "baretest", ">= 0.2.4"
  g.post_install_message = <<-DOC
  ********************************************************************
  Thanks for installing Dia! (#{Dia::VERSION})
  
  Don't forget to check NEWS.md for what has changed in this release:
  http://www.flowof.info/doc/dia/file.NEWS.html
  
  You can chat with us at irc.freenode.net / #flowof.info if you have
  any problems. Feel free to join us!
  ********************************************************************
  DOC
end
