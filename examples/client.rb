require 'rubygems'
require 'lib/dia'

Dia::SandBox.new(Dia::Profiles::NO_FILESYSTEM_WRITE, "echo 'foo' > foo.txt").run
Dia::SandBox.new(Dia::Profiles::NO_FILESYSTEM_WRITE, "echo 'foo' > foo.txt").run
