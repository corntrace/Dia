Gem::Specification.new do |g|
  g.name = 'dia'
  g.version = '1.1'
  g.authors = ['Robert Gleeson']
  g.email = 'rob@flowof.info'
  g.summary = "Dia allows you to sandbox applications on the OSX platform"
  g.description = "Dia allows you to sandbox applications on the OSX platform"
  
  g.require_paths = [ 'lib' ]
  g.files = Dir["*.md"] + Dir["lib/**/*.rb"]
  g.add_dependency "ffi", "= 0.5.4"
  g.add_development_dependency "baretest", ">= 0.2.4"
  g.post_install_message = <<-MSG

----------------------------------------------------------
Thanks for taking the time to try out Dia 1.1 (Final)

API docs:
http://yardoc.org/docs/robgleeson-Dia

NEWS & README:
http://github.com/robgleeson/Dia/blob/master/NEWS.md
http://github.com/robgleeson/Dia/blob/master/README.md

IRC:
irc.freenode.net / #flowof.info

Bug tracker: 
http://github.com/robgleeson/dia/issues
----------------------------------------------------------

MSG
end
