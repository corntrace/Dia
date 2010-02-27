require 'rubygems'
require 'lib/dia'

Dia::Sandbox.new(Dia::Profiles::NO_FILESYSTEM_WRITE, "echo 'foo' > foo.txt").run
Dia::Sandbox.new(Dia::Profiles::NO_FILESYSTEM_WRITE, "echo 'foo' > foo.txt").run
