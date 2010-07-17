# -*- encoding: utf-8 -*-
require('./lib/dia')

Gem::Specification.new do |s|

  s.name    = %q{dia}
  s.version = Dia::VERSION
  s.authors = ["Robert Gleeson"]
  s.email   = %q{rob@flowof.info}
  s.date    = Time.now.strftime("%Y-%m-%d")
  
  s.description = %q{Through the use of technology found on Apple's Leopard and Snow Leopard 
                     operating systems, Dia can create dynamic and robust sandbox environments 
                     for applications and for blocks of ruby code. 
                     The Ruby API was designed to be simple, and a joy to use. 
                     I hope you feel the same way :-)}

  s.summary     = %q{Through the use of technology found on Apple's Leopard and Snow Leopard 
                     operating systems, Dia can create dynamic and robust sandbox environments 
                     for applications and for blocks of ruby code. 
                     The Ruby API was designed to be simple, and a joy to use. 
                     I hope you feel the same way :-)}

 
  s.require_paths = ["lib"]
  s.files         = Dir["lib/**/*.rb"] + Dir["test/**/*.rb"] + %w(COPYING README.mkd dia.gemspec)
  s.test_files    = Dir["test/**/*.rb"]
  

  s.add_runtime_dependency(%q<ffi>, ["= 0.6.2"])
  s.add_development_dependency(%q<yard>, [">= 0"])
  s.has_rdoc = %q{yard}

  s.post_install_message = <<-MESSAGE  
  -------------------------------------------------------------------- 
  Dia (#{Dia::VERSION})
  
  Thanks for installing Dia, #{Dia::VERSION}! 

  >=2.0.0 releases include public API changes that are not backward
  compatiable with older releases. Be sure to check the docs!
 
  [Github]        http://github.com/robgleeson/dia
  [Documentation] http://yardoc.org/robgleeson-dia/
  --------------------------------------------------------------------  
  MESSAGE

end
