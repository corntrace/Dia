require 'rubygems'
require 'ffi'

module Dia
  module CommonAPI
    extend FFI::Library
    attach_function :sandbox_init, [ :string, :int, :string ], :int
  end
end
