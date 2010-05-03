gem 'ffi', '= 0.6.2'
require 'ffi'
require File.join(File.dirname(__FILE__), 'dia/profiles.rb')
require File.join(File.dirname(__FILE__), 'dia/commonapi.rb')
require File.join(File.dirname(__FILE__), 'dia/sandbox.rb')

module Dia
  VERSION = '1.5.RC'
  class SandboxException < StandardError; end
end

