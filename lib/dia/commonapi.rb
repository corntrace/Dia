require 'rubygems'
require 'ffi'

module Dia
  module CommonAPI
    extend FFI::Library
    ffi_lib(%w(sandbox system libSystem.B.dylib))
    attach_function :sandbox_init, [ :pointer, :uint64, :pointer ], :int
  end
end
