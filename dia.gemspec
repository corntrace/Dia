require File.join(File.dirname(__FILE__), 'lib', 'dia')
Gem::Specification.new do |g|
  g.name = 'dia'
  g.version = Dia::VERSION
  g.authors = ['Robert Gleeson']
  g.email = 'rob@flowof.info'
  g.summary = "Through the use of technology found on Apple's Leopard and Snow Leopard " \
              "operating systems, Dia can create dynamic and robust sandbox environments " \
              "for applications and for blocks of ruby code. " \
              "The Ruby API was designed to be simple, and a joy to use. " \
              "I hope you feel the same way :-)"

  g.description = "Through the use of technology found on Apple's Leopard and Snow Leopard " \
                  "operating systems, Dia can create dynamic and robust sandbox environments " \
                  "for applications and for blocks of ruby code. " \
                  "The Ruby API was designed to be simple, and a joy to use. " \
                  "I hope you feel the same way :-)"

  g.has_rdoc = 'yard'
    
  g.require_paths = [ 'lib' ]
  g.files = Dir["*.mkd"] + Dir["lib/**/*.rb"] + [ '.yardopts', 'COPYING' ]
  g.test_files = Dir["test/**/*.rb"]
  g.add_dependency "ffi", "= 0.6.2"
  g.add_development_dependency "baretest", ">= 0.2.4"
  g.add_development_dependency "yard"
  g.post_install_message = <<-DOC
  -------------------------------------------------------------------- 
  Dia (#{Dia::VERSION})
  
  Thanks for installing Dia, #{Dia::VERSION}! 

  >=2.0.0 releases include public API changes that are not backward
  compatiable with older releases. Be sure to check the docs!
 
  [Github]        http://github.com/robgleeson/dia
  [Documentation] http://yardoc.org/robgleeson-dia/
  --------------------------------------------------------------------  
  DOC
end
