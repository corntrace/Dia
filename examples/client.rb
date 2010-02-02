require 'rubygems'
require 'lib/dia'

Dia::SandBox.new("echo 'foo' > foo.txt", Dia::Profiles::NO_FILESYSTEM_WRITE).run
Dia::SandBox.new("echo 'bar' > bar.txt", Dia::Profiles::NO_FILESYSTEM_WRITE).run
