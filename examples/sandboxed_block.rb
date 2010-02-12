require 'rubygems'
require 'open-uri'
require 'net/http'
require File.join(File.dirname(__FILE__), '..', 'lib', 'dia')

sandbox = Dia::SandBox.new(Dia::Profiles::NO_OS_SERVICES)
sandbox.run_with_block do
  open("http://www.google.com").read
end
