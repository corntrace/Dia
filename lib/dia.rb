gem('ffi', '0.6.2')
require('ffi') 
Dir[File.expand_path('dia/*.rb', File.dirname(__FILE__))].each { |lib| require(lib) }

module Dia
  VERSION = '2.0'
end
