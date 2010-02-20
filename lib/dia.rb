gem 'ffi', '=0.5.4'
require 'ffi'
require File.join(File.dirname(__FILE__), 'dia/profiles.rb')
require File.join(File.dirname(__FILE__), 'dia/commonapi.rb')
require File.join(File.dirname(__FILE__), 'dia/sandbox.rb')

module Dia
  VERSION = '1.2'
  class SandBoxException < StandardError; end
end

