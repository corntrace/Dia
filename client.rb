require 'rubygems'
require 'lib/dia'

sandbox = Dia::SandBox.new("/Applications/Firefox.app/Contents/MacOS/firefox-bin", Dia::Profiles::NO_INTERNET)
sandbox.run

puts "Running firefox with a PID of #{sandbox.pid}, using the #{sandbox.profile} profile"
