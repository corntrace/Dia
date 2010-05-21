gem('ffi', '= 0.6.2')
require('ffi')
require(File.expand_path('profiles.rb' , File.dirname(__FILE__)))
require(File.expand_path('commonapi.rb', File.dirname(__FILE__)))
require(File.expand_path('sandbox.rb'  , File.dirname(__FILE__)))

module Dia
  VERSION = '1.5'
  class SandboxException < StandardError; end
end

