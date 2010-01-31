require 'rubygems'
require 'ffi'

module Dia
  module CommonAPI
    extend FFI::Library
    attach_function :sandbox_init, [ :string, :int, :pointer ], :int
  end
end
