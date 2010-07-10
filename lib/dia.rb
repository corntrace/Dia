gem('ffi', '0.6.2')
require('ffi') 
require(File.expand_path('dia/shared_features', File.dirname(__FILE__)))
require(File.expand_path('dia/functions'      , File.dirname(__FILE__)))
require(File.expand_path('dia/profiles'       , File.dirname(__FILE__)))
require(File.expand_path('dia/ruby_block'     , File.dirname(__FILE__)))
require(File.expand_path('dia/exceptions'     , File.dirname(__FILE__)))
module Dia
  VERSION = '2.0.0.pre'
end
