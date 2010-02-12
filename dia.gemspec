Gem::Specification.new do |g|
  g.name = 'dia'
  g.version = '1.1.pre'
  g.authors = ['Robert Gleeson']
  g.email = 'rob@flowof.info'
  g.summary = "Dia allows you to sandbox applications on the OSX platform"
  g.description = "Dia allows you to sandbox applications on the OSX platform"
  
  g.require_paths = [ 'lib' ]
  g.files = Dir["*.md"] + Dir["lib/**/*.rb"]
  g.add_dependency "ffi", "= 0.5.4"
  g.add_development_dependency "baretest", ">= 0.2.4"
  g.post_install_message = <<-MSG
 Dia
-----
Thanks for taking the time to try out the prereleae of Dia 1.1

For people who had problems with Dia and FFI 0.6.0, I have added an explicit 
dependency on 0.5.4 ..

Slight API changes alter the way Dia behaves .. 
The change is minor, but worth noting because it breaks code written for 1.0

For more information: 
http://github.com/robgleeson/Dia/blob/experimental/NEWS.md
http://github.com/robgleeson/Dia/blob/experimental/README.md

Please report bugs if you find any! 
http://github.com/robgleeson/dia/issues

Rob
MSG
end
